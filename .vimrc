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
set signcolumn=yes          " gitgutter の記号で画面が左右にずれないよう常時表示
set updatetime=100          " gitgutter の反映遅延 (既定 4000ms)

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

" quickfix 移動 (:grep, :Rg, :GitGutterQuickFix などの結果)
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
nnoremap sq :<C-u>q<CR>
nnoremap sQ :<C-u>bd<CR>
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
" Git レビュー (fugitive + gitgutter + fzf.vim + git-messenger)
" -----------------------------------------------------------------------------
" 使い方の要点
"   ,gs  : ステータス画面。 = でインライン差分 / dv で左右差分 / - でステージ切替 / X で変更破棄 / cc でコミット
"   ,gD  : 未ステージの変更ファイルを全部タブで開き、左右差分にする (gt で次のファイル, ]c [c でハンク移動)
"   ,gH  : HEAD との差分を全部タブで開く (ステージ済みも含めて全部見たいとき)
"   ,gd  : 現在のファイルだけ左右差分
"   ,gq  : レビュー用に開いたタブを全部閉じる
"   ]h [h: ハンク移動   ,hp: プレビュー   ,hs: ハンクをステージ   ,hu: ハンクを取り消し
"   ,gf  : 変更ファイルを fzf で選んで開く   ,gc: このファイルのコミット履歴   ,gC: リポジトリのコミット履歴
"   ,gm  : カーソル行の blame をポップアップ表示

" fugitive
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <silent> <Leader>gd :Gvdiffsplit<CR>
nnoremap <silent> <Leader>gD :Git difftool -y<CR>
nnoremap <silent> <Leader>gH :Git difftool -y HEAD<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gl :Git log --oneline -50<CR>
nnoremap <silent> <Leader>gq :tabonly<CR>:only<CR>

" fzf.vim (git)
nnoremap <silent> <Leader>gf :GFiles?<CR>
nnoremap <silent> <Leader>gc :BCommits<CR>
nnoremap <silent> <Leader>gC :Commits<CR>

" gitgutter
let g:gitgutter_map_keys = 0
let g:gitgutter_preview_win_floating = 0
nmap ]h <Plug>(GitGutterNextHunk)
nmap [h <Plug>(GitGutterPrevHunk)
nmap <Leader>hp <Plug>(GitGutterPreviewHunk)
nmap <Leader>hs <Plug>(GitGutterStageHunk)
xmap <Leader>hs <Plug>(GitGutterStageHunk)
nmap <Leader>hu <Plug>(GitGutterUndoHunk)
omap ih <Plug>(GitGutterTextObjectInnerPending)
omap ah <Plug>(GitGutterTextObjectOuterPending)
xmap ih <Plug>(GitGutterTextObjectInnerVisual)
xmap ah <Plug>(GitGutterTextObjectOuterVisual)
" 全ハンクを quickfix に流す (]q [q で巡回)
command! Gqf GitGutterQuickFix | copen
nnoremap <silent> <Leader>hq :Gqf<CR>
" 変更のない行を折りたたんでハンクだけ見る
nnoremap <silent> <Leader>hf :GitGutterFold<CR>

" git-messenger
let g:git_messenger_no_default_mappings = v:true
nmap <Leader>gm <Plug>(git-messenger)

" fugitive の画面と s プレフィックス / バッファ移動の衝突を解消する
"   - ステータス画面では fugitive が s を「ステージ」に割り当てるので外す (ステージは - で行う)
"   - fugitive:// の比較元バッファと一時バッファはバッファ一覧 (:bn :bp :Buffers) に出さない
augroup FugitiveReviewKeys
  autocmd!
  autocmd User FugitiveIndex silent! nunmap <buffer> s
  autocmd User FugitiveIndex,FugitiveObject,FugitivePager setlocal nobuflisted
augroup END

" -----------------------------------------------------------------------------
" 配色
" -----------------------------------------------------------------------------
colorscheme badwolf
