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

  let g:rc_dir = expand('~/.vim/rc')
  call dein#load_toml(g:rc_dir . '/dein.toml', {'lazy': 0})

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
" html-equiv などを 1 単語として * で検索する
set iskeyword+=-

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

" 補完 (vim 標準の <C-n> / <C-x><C-o>)
" 補完候補が出ているときは Tab で次の候補へ
inoremap <expr><TAB> pumvisible() ? "\<C-n>" : "\<TAB>"
autocmd FileType css           setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript    setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType xml           setlocal omnifunc=xmlcomplete#CompleteTags

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
" :Review と ,gq の実装は autoload/review.vim (コマンド定義は plugin/review.vim)

" fugitive
nnoremap <silent> <Leader>gs :Git<CR>
nnoremap <Leader>gr :Review<Space>
nnoremap <silent> <Leader>gd :Gvdiffsplit<CR>
nnoremap <silent> <Leader>gb :Git blame<CR>
nnoremap <silent> <Leader>gl :Git log --oneline -50<CR>
nnoremap <silent> <Leader>gq :call review#close()<CR>

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
