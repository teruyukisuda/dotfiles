" =============================================================================
" ~/.vimrc
"   - プラグイン管理は dein のみ (~/.vim/rc/dein.toml)
"   - Leader は ,  (元の , は \ に退避)
"   - Git レビュー用のキーは末尾の「Git レビュー」節にまとめてある
" =============================================================================

" -----------------------------------------------------------------------------
" MacVim
" -----------------------------------------------------------------------------
if has('gui_macvim')
  set guicursor=n-v-c:block-Cursor/lCursor-blinkon0
  set guicursor+=i:ver25-Cursor/lCursor-blinkon0
  set guicursor+=r:hor20-Cursor/lCursor-blinkon0
  set transparency=5
  set guifont=Menlo:h14
  set guioptions-=T
  set guioptions-=r
  set guioptions-=L
endif

" -----------------------------------------------------------------------------
" dein
" -----------------------------------------------------------------------------
if &compatible
  set nocompatible
endif

set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim

" Homebrew の fzf に同梱されている vim プラグイン (fzf.vim の土台)
if isdirectory('/opt/homebrew/opt/fzf')
  set runtimepath+=/opt/homebrew/opt/fzf
endif

if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#add('~/.cache/dein/repos/github.com/Shougo/dein.vim')

  let g:rc_dir    = expand('~/.vim/rc')
  let s:toml      = g:rc_dir . '/dein.toml'
  let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'
  call dein#load_toml(s:toml,      {'lazy': 0})
  call dein#load_toml(s:lazy_toml, {'lazy': 1})

  call dein#end()
  call dein#save_state()
endif

filetype plugin indent on
syntax enable

if dein#check_install()
  call dein#install()
endif

" -----------------------------------------------------------------------------
" 基本設定
" -----------------------------------------------------------------------------
let mapleader = ","
noremap \ ,

set fileencodings=ucs-bom,utf-8,cp932,euc-jp,latin1
set number
set noswapfile
set backupdir=$HOME/vimbackup
set directory=$HOME/vimbackup
set clipboard=unnamed
set hidden
set backspace=indent,eol,start
set whichwrap=b,s,[,],<,>

" カレントディレクトリは起動時の場所 (リポジトリルート) を維持する。
" autochdir を使うと fugitive / fzf / quickfix のパスがファイル位置に引きずられるため使わない。
" 必要なときは ,cd でリポジトリルートへ移動する。

" 検索
set incsearch
set hlsearch
set ignorecase
set smartcase
set shortmess-=S

" インデント
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=2

" 表示
set cursorline
set list
set listchars=tab:>-,trail:-,eol:↲

" diff
set diffopt+=vertical,internal,filler,closeoff,algorithm:histogram,indent-heuristic

" grep (:grep で rg を使い quickfix に流す)
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git'
  set grepformat=%f:%l:%c:%m
else
  set grepprg=grep\ -nh
  set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
endif

" tmux 内でもモードに応じてカーソル形状を変える
if exists('$TMUX')
  let &t_SI .= "\e[6 q"
  let &t_EI .= "\e[2 q"
  let &t_SR .= "\e[4 q"
endif

" -----------------------------------------------------------------------------
" 一般キーマップ
" -----------------------------------------------------------------------------
nnoremap j gj
nnoremap k gk
nnoremap / /\v
nnoremap ? ?\v

" 検索ハイライトを Esc 連打で消す
nnoremap <ESC><ESC> :nohlsearch<CR>

" 行頭 / 行末
nnoremap <Space>h ^
nnoremap <Space>l $

" 選択行 (または現在行) をシェルで実行して結果に置き換える
vnoremap <Space><CR> :!sh<CR>
nnoremap <Space><CR> V:!sh<CR>

" Redo
nnoremap U <C-r>

" 全体インデント
nnoremap <Leader>ii :normal gg=G<CR>

" html / xml を要素ごとに改行
nnoremap <Leader>ff :%s/></>\r</g<CR>

" quickfix 移動 (:grep, :Rg などの結果)
nnoremap <silent> [q :cprevious<CR>
nnoremap <silent> ]q :cnext<CR>
nnoremap <silent> [Q :<C-u>cfirst<CR>
nnoremap <silent> ]Q :<C-u>clast<CR>

" insert モード
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
inoremap <C-b> <Left>
inoremap <C-f> <Right>
noremap  <C-j> <Esc>
noremap! <C-j> <Esc>

" ウィンドウ / タブ操作 (prefix: s)
nnoremap s <Nop>
nnoremap sj <C-w>j
nnoremap sk <C-w>k
nnoremap sl <C-w>l
nnoremap sh <C-w>h
nnoremap sJ <C-w>J
nnoremap sK <C-w>K
nnoremap sL <C-w>L
nnoremap sH <C-w>H
nnoremap sN gt
nnoremap sP gT
nnoremap sr <C-w>r
nnoremap s= <C-w>=
nnoremap so <C-w>_<C-w><Bar>
nnoremap sO <C-w>=
nnoremap sn :<C-u>bn<CR>
nnoremap sp :<C-u>bp<CR>
nnoremap st :<C-u>tabnew<CR>
nnoremap ss :<C-u>sp<CR>
nnoremap sv :<C-u>vs<CR>
" バッファを閉じる (ウィンドウだけ閉じるなら :q)
nnoremap sq :<C-u>bd<CR>
nnoremap <silent> sb :<C-u>Buffers<CR>
nnoremap <silent> sB :<C-u>Windows<CR>
nnoremap <silent> sT :<C-u>Windows<CR>

" ファイルパス (plugin/copypath.vim)
nnoremap <Leader>cp :CopyPath<CR>
nnoremap <Leader>cf :CopyFileName<CR>
nnoremap <Leader>cu :echo expand("%:p")<CR>

" カレントディレクトリを Git リポジトリのルートへ
nnoremap <silent> <Leader>cd :Gcd<CR>:pwd<CR>

" 行内の URL をブラウザで開く
function! HandleURI()
  let s:uri = matchstr(getline("."), '[a-z]*:\/\/[^ >,;:]*')
  echo s:uri
  if s:uri != ""
    exec "!open \"" . s:uri . "\""
  else
    echo "No URI found in line."
  endif
endfunction
map <Leader>w :call HandleURI()<CR>

" 現在のファイルを Safari で開く
nnoremap <Leader>b :!open -a Safari %<CR>

" -----------------------------------------------------------------------------
" プラグイン設定
" -----------------------------------------------------------------------------
" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'default'

" NERDTree
nnoremap <silent> <C-e> :NERDTreeToggle<CR>

" easymotion
map  <Leader>s <Plug>(easymotion-bd-f2)
nmap <Leader>s <Plug>(easymotion-overwin-f2)
map  <Leader>l <Plug>(easymotion-bd-jk)
nmap <Leader>l <Plug>(easymotion-overwin-line)

" vim-table-mode (markdown 互換)
let g:table_mode_corner = '|'

" previm
augroup PrevimSettings
  autocmd!
  autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
augroup END
let g:previm_open_cmd = 'open -a "Google Chrome"'
nnoremap <silent> <C-p> :PrevimOpen<CR>

" emmet
let g:user_emmet_leader_key = '<C-Z>'

" neocomplete
let g:acp_enableAtStartup = 0
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
    \ }
if !exists('g:neocomplete#keyword_patterns')
  let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS>  neocomplete#smart_close_popup()."\<C-h>"
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" -----------------------------------------------------------------------------
" fzf.vim (ファイル / バッファ / grep)
" -----------------------------------------------------------------------------
let g:fzf_layout = { 'down': '40%' }
let g:fzf_preview_window = ['right:50%', 'ctrl-/']

nnoremap <silent> <Leader>uf :Files<CR>
nnoremap <silent> <Leader>ub :Buffers<CR>
nnoremap <silent> <Leader>um :History<CR>
nnoremap <silent> <Leader>ua :GFiles<CR>
nnoremap <silent> <Leader>r  :Rg<CR>
" カーソル下の単語で Rg
nnoremap <silent> <Leader>R  :Rg <C-r><C-w><CR>

" -----------------------------------------------------------------------------
" Git レビュー (fugitive + fzf.vim)
" -----------------------------------------------------------------------------
" 使い方の要点
"   ,gs  : ステータス画面。= でインライン差分、差分のハンク上で - でステージ / X で取り消し、dv で左右差分、cc でコミット
"   ,gr  : :Review {範囲}。1 つ目のタブに範囲内のコミットと変更ファイルの一覧、2 つ目以降にファイルごとの左右差分
"          (一覧のファイル行で Enter でそのタブへ、コミット行で Enter でコミットを開く)
"   ,gd  : 現在のファイルだけ左右差分
"   ,gl  : コミットログ   ,gb: blame
"   ,gq  : レビュー用に開いたタブと fugitive の画面を閉じ、普通のファイルのウィンドウを 1 つだけ残す
"   ,gf  : 変更ファイルを fzf で選んで開く   ,gc: このファイルのコミット履歴   ,gC: リポジトリのコミット履歴

" fugitive
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <Leader>gr :Review<Space>
nnoremap <silent> <Leader>gd :Gvdiffsplit<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gl :Git log --oneline -50<CR>
nnoremap <silent> <Leader>gq :call <SID>ReviewClose()<CR>

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
function! s:ReviewClose() abort
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

" :Review          ステータス画面を開く (未コミットの変更のレビュー)
" :Review {範囲}   git diff と同じ書き方の範囲 (A..B / main... / abc123^! / HEAD~3 / A B) を受け取り、
"                  1 つ目のタブに範囲内のコミットと変更ファイルの一覧、2 つ目以降にファイルごとの左右差分を開く
command! -nargs=* Review call s:Review(<q-args>)

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

function! s:Review(range) abort
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
  nnoremap <buffer> <silent> <CR> :<C-u>call <SID>ReviewOpen()<CR>
  call cursor(len(l:lines) - len(l:status) + 1, 1)
endfunction

" 一覧の行で Enter: ファイルならそのファイルの差分タブへ、コミットならそのコミットを横分割で開く
function! s:ReviewOpen() abort
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

" fzf.vim (git)
nnoremap <silent> <Leader>gf :GFiles?<CR>
nnoremap <silent> <Leader>gc :BCommits<CR>
nnoremap <silent> <Leader>gC :Commits<CR>

" fugitive の画面と s プレフィックス / バッファ移動の衝突を解消する
"   - ステータス画面では fugitive が s を「ステージ」に割り当てるので外す (ステージは - で行う)
"   - fugitive:// の比較元バッファと一時バッファはバッファ一覧 (:bn :bp :Buffers) に出さない
"   - コミットの画面などには fugitive が gq を割り当てないので、:bdelete で閉じられるようにする
"     (blame から <CR> で飛んだ先がこれで、元のファイルのウィンドウを置き換えている)
augroup FugitiveReviewKeys
  autocmd!
  autocmd User FugitiveIndex silent! nunmap <buffer> s
  autocmd User FugitiveIndex,FugitiveObject,FugitivePager setlocal nobuflisted
  autocmd User FugitiveObject if !get(maparg('gq', 'n', 0, 1), 'buffer', 0)
        \ | nnoremap <buffer> <silent> gq :<C-u>bdelete<CR>
        \ | endif
augroup END

" -----------------------------------------------------------------------------
" 配色
" -----------------------------------------------------------------------------
" badwolf の diff の色は灰色の濃淡だけで、変更行 (DiffChange) は CursorLine と同じ色になり
" 左右差分で追加・変更・変更なしの区別が付きにくい。diff の 4 色だけ色相の違う背景に上書きする
augroup DiffColors
  autocmd!
  autocmd ColorScheme badwolf
        \   highlight DiffAdd    ctermfg=NONE ctermbg=22 guifg=NONE    guibg=#005f00 cterm=NONE gui=NONE
        \ | highlight DiffDelete ctermfg=52   ctermbg=52 guifg=#5f0000 guibg=#5f0000 cterm=NONE gui=NONE
        \ | highlight DiffChange ctermfg=NONE ctermbg=17 guifg=NONE    guibg=#00005f cterm=NONE gui=NONE
        \ | highlight DiffText   ctermfg=15   ctermbg=25 guifg=#ffffff guibg=#005faf cterm=bold gui=bold
augroup END
colorscheme badwolf
