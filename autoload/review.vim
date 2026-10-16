" =============================================================================
" :Review と ,gq の実装 (コマンドは plugin/review.vim、キーは .vimrc の「Git レビュー」節)
"   fugitive (tpope/vim-fugitive) が必要
" =============================================================================

" fugitive の画面 (ステータス / ログ / blame / コミット / fugitive:// の比較元) や
" quickfix・プレビュー・:Review の一覧ではない、普通のファイルのウィンドウか
function! s:IsFileWindow(winid) abort
  let l:buf = winbufnr(a:winid)
  return getbufvar(l:buf, '&buftype') ==# ''
        \ && bufname(l:buf) !~# '^fugitive://'
        \ && index(['fugitive', 'git', 'fugitiveblame'], getbufvar(l:buf, '&filetype')) < 0
endfunction

" カーソル位置に関係なく、普通のファイルのウィンドウを 1 つだけ残して他のタブとウィンドウを閉じる。
" 候補は 今のウィンドウ → 今のタブ → 他のタブ の順に探し、無ければ空のバッファにする
function! review#close() abort
  let l:target = 0
  if s:IsFileWindow(win_getid())
    let l:target = win_getid()
  else
    let l:tabs = [tabpagenr()] + filter(range(1, tabpagenr('$')), 'v:val != tabpagenr()')
    for l:tab in l:tabs
      for l:winid in map(range(1, tabpagewinnr(l:tab, '$')), 'win_getid(v:val, l:tab)')
        if s:IsFileWindow(l:winid)
          let l:target = l:winid
          break
        endif
      endfor
      if l:target
        break
      endif
    endfor
  endif
  if l:target
    call win_gotoid(l:target)
  endif
  tabonly
  only
  if !l:target
    enew
  endif
endfunction

" git を実行して空行を除いた標準出力を返す。失敗したら stderr を例外にする
function! s:ReviewGit(args) abort
  let l:result = FugitiveExecute(a:args)
  if l:result.exit_status != 0
    throw 'review: ' . join(filter(copy(l:result.stderr), 'v:val !=# ""'), ' ')
  endif
  return filter(copy(l:result.stdout), 'v:val !=# ""')
endfunction

" バッファ名をリポジトリルートからの相対パスにする (fugitive:// の比較元にも対応)
function! s:ReviewRelPath(name, root) abort
  if a:name =~# '^fugitive://'
    return matchstr(a:name, '^fugitive://.\{-}//\x\+/\zs.*')
  endif
  let l:abs = resolve(fnamemodify(a:name, ':p'))
  return stridx(l:abs, a:root) == 0 ? strpart(l:abs, len(a:root)) : ''
endfunction

" :Review          ステータス画面を開く (未コミットの変更のレビュー)
" :Review {範囲}   git diff と同じ書き方の範囲 (A..B / main... / abc123^! / HEAD~3 / A B) を受け取り、
"                  1 つ目のタブに範囲内のコミットと変更ファイルの一覧、2 つ目以降にファイルごとの左右差分を開く
function! review#start(range) abort
  let l:args = split(a:range)
  let l:blank = empty(bufname('%')) && !&modified && line('$') == 1 && empty(getline(1))
  if empty(l:args)
    execute l:blank ? 'Gedit :' : 'Git'
    return
  endif
  try
    let l:status = s:ReviewGit(['diff', '--name-status'] + l:args)
    let l:numstat = s:ReviewGit(['diff', '--numstat'] + l:args)
    " 1 つの rev だけなら作業ツリーまでの差分になる。コミット一覧は HEAD までを出す
    let l:to_worktree = len(l:args) == 1 && a:range !~# '\.\.\|\^[!@-]'
    " git log の A...B は両側のコミットになるので、diff と同じ「分岐点から B まで」の A..B に直す
    let l:logrange = len(l:args) == 2 ? [l:args[0] . '..' . l:args[1]]
          \ : l:to_worktree ? [l:args[0] . '..HEAD'] : [substitute(l:args[0], '\.\.\.', '..', '')]
    let l:commits = s:ReviewGit(['log', '--oneline', '--no-decorate'] + l:logrange)
  catch /^review:/
    echohl ErrorMsg | echomsg v:exception | echohl None
    return
  endtry
  if empty(l:status)
    echomsg 'review: 差分がありません: ' . a:range
    return
  endif
  let l:root = resolve(FugitiveWorkTree()) . '/'
  let l:gitdir = FugitiveGitDir()

  if !l:blank
    tabnew
  endif
  " difftool は今のタブの後ろにファイルごとのタブを足すので、今のタブを一覧に使う
  let l:list_tab = tabpagenr()
  execute 'Git difftool -y ' . a:range
  execute l:list_tab . 'tabnext'
  enew
  setlocal buftype=nofile bufhidden=wipe noswapfile nobuflisted
  let l:lines = ['Review: ' . a:range . (l:to_worktree ? '  (作業ツリーまで)' : ''),
        \ 'Enter: ファイル行はそのタブへ / コミット行はコミットを開く   gt gT: タブ移動   ,gq: 全部閉じる', '']
  let l:commit_lines = {}
  let l:file_lines = {}
  call add(l:lines, 'Commits (' . len(l:commits) . ')')
  for l:c in l:commits
    call add(l:lines, '  ' . l:c)
    let l:commit_lines[len(l:lines)] = matchstr(l:c, '^\x\+')
  endfor
  call extend(l:lines, ['', 'Files (' . len(l:status) . ')'])
  let l:width = max(map(copy(l:status), 'strdisplaywidth(join(split(v:val, "\t")[1:], " -> "))'))
  for l:i in range(len(l:status))
    let l:cols = split(l:status[l:i], "\t")
    let l:mark = l:cols[0][0]
    let l:path = l:cols[-1]
    let l:shown = join(l:cols[1:], ' -> ')
    let l:num = split(get(l:numstat, l:i, "-\t-"), "\t")
    let l:count = l:num[0] ==# '-' ? 'binary' : '+' . l:num[0] . ' -' . l:num[1]
    call add(l:lines, printf('  %s  %s%s  %s', l:mark, l:shown,
          \ repeat(' ', l:width - strdisplaywidth(l:shown)), l:count))
    let l:file_lines[len(l:lines)] = {'path': l:path, 'old': l:cols[1], 'mark': l:mark}
  endfor
  call setline(1, l:lines)
  setlocal nomodifiable
  silent! execute 'file' fnameescape('[Review ' . a:range . ']')
  let b:review = {'root': l:root, 'gitdir': l:gitdir, 'commits': l:commit_lines, 'files': l:file_lines}
  nnoremap <buffer> <silent> <CR> :<C-u>call review#open()<CR>
  call cursor(len(l:lines) - len(l:status) + 1, 1)
endfunction

" 一覧の行で Enter: ファイルならそのファイルの差分タブへ、コミットならそのコミットを横分割で開く
function! review#open() abort
  let l:lnum = line('.')
  if has_key(b:review.commits, l:lnum)
    execute 'split' fnameescape(FugitiveFind(b:review.commits[l:lnum], b:review.gitdir))
    return
  endif
  if !has_key(b:review.files, l:lnum)
    return
  endif
  let l:file = b:review.files[l:lnum]
  for l:tab in range(1, tabpagenr('$'))
    for l:buf in tabpagebuflist(l:tab)
      if index([l:file.path, l:file.old], s:ReviewRelPath(bufname(l:buf), b:review.root)) >= 0
            \ && l:tab != tabpagenr()
        execute l:tab . 'tabnext'
        return
      endif
    endfor
  endfor
  " 内容を変えずに名前だけ変えたファイルは difftool がタブを作らない
  echomsg 'review: このファイルの差分タブがありません: ' . l:file.path
        \ . (l:file.mark ==# 'R' ? ' (名前の変更だけで内容の差分はありません)' : '')
endfunction
