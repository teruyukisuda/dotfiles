syntax on
colorscheme badwolf


" leaderキーを,に変更
let mapleader = ","
" ,のデフォルトの機能は、\で使えるように退避
noremap \  ,


"set t_Co=256
set term=xterm-256color
"highlight Normal ctermbg=none

"行番号表示
set number

" スワップファイルを作成しない
set noswapfile

"バックアップファイルのディレクトリを指定する
set backupdir=$HOME/vimbackup

"クリップボードをMacと連携する
set clipboard=unnamed

"開いたファイルのパスへ自動的に移動する
set autochdir

"vi互換をオフする
set nocompatible
filetype plugin on

"スワップファイル用のディレクトリを指定する
set directory=$HOME/vimbackup

"タブの代わりに空白文字を指定する
"set expandtab

"変更中のファイルでも、保存しないで他のファイルを表示する
set hidden

"インクリメンタルサーチを行う
set incsearch
"強調サーチ
set hlsearch

"検索の時に大文字小文字を区別しない
"ただし大文字小文字の両方が含まれている場合は大文字小文字を区別する
set ignorecase
set smartcase

"行末／行頭の移動可能に設定
set whichwrap=b,s,[,],<,>

"閉括弧が入力された時、対応する括弧を強調する
"set showmatch

"新しい行を作った時に高度な自動インデントを行う
set smarttab

" grep検索を設定する
set grepformat=%f:%l:%m,%f:%l%m,%f\ \ %l%m,%f
set grepprg=grep\ -nh

set guifont=Ricty:h13
set guifontwide=Ricty:h13

"タブ幅の設定
set tabstop=4
set shiftwidth=4
set softtabstop=4
"set smartindent
"新しい行のインデントを現在行と同じにする
"set autoindent 

"カーソル行の強調表示
set cursorline

set list
set listchars=tab:>-,trail:-,eol:↲

"選択行にあるコマンドを実行する
vnoremap <Space><CR> :!sh<CR>    # 行選択中に実行
nnoremap <Space><CR> V:!sh<CR>   # 行選択していない状態から実行

"コマンドを実行する
vnoremap <Space><CR> :!sh<CR>    # 行選択中に実行
nnoremap <Space><CR> V:!sh<CR>   # 行選択していない状態から実行

"検索結果のハイライトをEsc連打でクリアする
nnoremap <ESC><ESC> :nohlsearch<CR>

"スペースh スペースl で行頭行末に移動する
nnoremap <Space>h  ^
nnoremap <Space>l  $

"ノーマルモードでF9にNerdのショートカット割り当て
"nnoremap <F9> :NERDTreeToggle <CR>
nnoremap <silent><C-e> :NERDTreeToggle<CR>

"RedoはUにバインド
nnoremap U :Redo<CR>
"Ctrl+pで0レジスタの値をペースト
nnoremap <C-p> <S-">0p

"バッファの移動
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>

nnoremap <Leader>0 :silent ! start "%"

" insertモードから抜ける
inoremap <C-j> <Esc>
inoremap <C-e> <Esc>A
inoremap <C-a> <Esc>I
vnoremap <C-j> <Esc>

" insertモードでインサート
"inoremap <C-n> <Down>
"inoremap <C-p> <Up>
"inoremap <C-b> <Left>
"inoremap <C-f> <Right>

" Markdown Preview (kannokanno/previmプラグイン用）
" " <Ctrl+p>でプレビュー
nnoremap <silent> <C-p> :PrevimOpen<CR>

" vimgrepの後次へ前へ
nnoremap [q :cprevi]us<CR>
nnoremap ]q :cnext<CR>
nnoremap [Q :<C-u>cfirst<CR>
nnoremap ]Q :<C-u>clast<CR>

"バックスペースが効かないので、
set backspace=indent,eol,start

"tmux使ってもカーソルが挿入モードで変わるように設定
if exists('$TMUX')
    let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
    let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
    let &t_SI = "\<Esc>]50;CursorShape=1\x7"
    let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif

"emmetキーバインド
"let g:user_emmet_leader_key='<c-t>'
let g:user_emmet_leader_key='<C-Z>'



"----------------------------------------------------
"" Start Neobundle Settings.
"----------------------------------------------------
"" bundleで管理するディレクトリを指定
set runtimepath+=~/.vim/bundle/neobundle.vim/
 
call neobundle#begin(expand('~/.vim/bundle/'))

"neobundle自体をneobundleで管理
NeoBundleFetch 'Shougo/neobundle.vim'

"install
NeoBundle 'scrooloose/nerdtree'
NeoBundle 'mattn/emmet-vim'

" table-mode
NeoBundle 'dhruvasagar/vim-table-mode'
" table-modeのコーナーを|にしてmarkdown対応にする
let g:table_mode_corner = '|'

" コード補完
NeoBundle 'Shougo/neocomplete.vim'
" NeoBundle 'marcus/rsense'
" NeoBundle 'supermomonga/neocomplete-rsense.vim'
"
" 静的解析
NeoBundle 'scrooloose/syntastic'

" ドキュメント参照
NeoBundle 'thinca/vim-ref'
NeoBundle 'yuku-t/vim-ref-ri'

" メソッド定義元へのジャンプ
NeoBundle 'szw/vim-tags'

" 自動で閉じる
NeoBundle 'tpope/vim-endwise'

NeoBundle 'thinca/vim-quickrun'

" vimのセッションを保存する
NeoBundle 'tpope/vim-obsession'

" vimのセッションを保存する
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/neomru.vim'
""" unite.vim
" 入力モードで開始する
"let g:unite_enable_start_insert=1
 " バッファ一覧
nnoremap <silent> ,ub :<C-u>Unite buffer<CR>
" ファイル一覧
nnoremap <silent> ,uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" レジスタ一覧
nnoremap <silent> ,ur :<C-u>Unite -buffer-name=register register<CR>
" 最近使用したファイル一覧
nnoremap <silent> ,um :<C-u>Unite file_mru<CR>
" 常用セット
nnoremap <silent> ,uu :<C-u>Unite buffer file_mru<CR>
" 全部乗せ
nnoremap <silent> ,ua :<C-u>UniteWithBufferDir -buffer-name=files buffer file_mru bookmark file<CR>
" ウィンドウを分割して開く
"au FileType unite nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
"au FileType unite inoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
" ウィンドウを縦に分割して開く
"au FileType unite nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
"au FileType unite inoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
" ESCキーを2回押すと終了する
au FileType unite nnoremap <silent> <buffer> <ESC><ESC> q
au FileType unite inoremap <silent> <buffer> <ESC><ESC> <ESC>q

" ウインドウのリサイズ Ctrl + Yでリサイズモード
NeoBundle 'simeji/winresizer'
let g:winresizer_start_key = '<C-Y>'

" ↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓↓ markdownプレビュー
" （http://note103.hateblo.jp/entry/2014/02/11/005326)
" （https://mba-hack.blogspot.jp/2013/11/vimmarkdown.html)
" (https://github.com/kannokanno/previm)
NeoBundle 'vim-scripts/vim-auto-save'
NeoBundle 'kannokanno/previm'
"NeoBundle 'syui/scroll.vim'
NeoBundle 'kana/vim-submode'
augroup PrevimSettings
	    autocmd!
		    autocmd BufNewFile,BufRead *.{md,mdwn,mkd,mkdn,mark*} set filetype=markdown
		augroup END
augroup END
let g:previm_open_cmd = 'open -a Safari'
" ↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑↑ markdownプレビュー


nnoremap <Leader>b :!open -a Safari %<CR>

" ファイル検索
NeoBundle "ctrlpvim/ctrlp.vim"

call neobundle#end()

filetype plugin on
filetype plugin indent on
"      
"
"未インストールのプラグインがある場合、インストールするかどうかを尋ねてくれるようにする設定
"毎回聞かれると邪魔な場合もあるので、この設定は任意です。
NeoBundleCheck
"       
"--------------------------------------------------
" End Neobundle Settings.
"--------------------------------------------------


"--------------------------------------------------
" Start Plug Settings.
"--------------------------------------------------
call plug#begin('~/.vim/plugged')

Plug 'w0rp/ale'
Plug 'prettier/vim-prettier', { 'do': 'yarn istall'}

call plug#end()
"--------------------------------------------------
" End Plug Settings.
"--------------------------------------------------
"
"
"--------------------------------------------------
" Start prettier-vim configuration
"--------------------------------------------------
" tab_width
let g:prettier#config#tab_width = 4

" use tabs over spaces
let g:prettier#config#use_tabs = 'true'

"--------------------------------------------------
" End prettier-vim configuration
"--------------------------------------------------
"
"
" -------------------------------
"  " Rsense
"  " -------------------------------
let g:rsenseHome = '/usr/local/lib/rsense-0.3'
let g:rsenseUseOmniFunc = 1

" --------------------------------
" neocomplete.vim
" --------------------------------
"Note: This option must be set in .vimrc(_vimrc).  NOT IN .gvimrc(_gvimrc)!
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist',
    \ 'scheme' : $HOME.'/.gosh_completions'
        \ }
" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return (pumvisible() ? "\<C-y>" : "" ) . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? "\<C-y>" : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? "\<C-y>" : "\<Space>"

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" --------------------------------
" rubocop
" --------------------------------
" syntastic_mode_mapをactiveにするとバッファ保存時にsyntasticが走る
" active_filetypesに、保存時にsyntasticを走らせるファイルタイプを指定する
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes':['ruby'] }
let g:syntastic_ruby_checkers = ['rubocop']


" --------------------------------
" quickrun (うまくいかないなー）
" --------------------------------
"let g:quickrun_config = {}
"let g:quickrun_config['html'] = {
"      \   'outputter': 'browser'
"      \ }
"let g:quickrun_config['html'] = { 'command' : 'open', 'exec' : '%c %s', 'outputter': 'browser' }
"let g:quickrun_config = {'*': {'hook/time/enable': '1'},}


"↓ URLが書いてある行で「,」「w」を続けて押すと、規定のブラウザでURLが開きます。
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
"↑ URLが書いてある行で「,」「w」を続けて押すと、規定のブラウザでURLが開きます。

"Vimで現在開いているファイルのパスを取得する設定(CopyPath,CopyFileName）のスクリプトは~/.vim/plugin内にある
" ,cp
" ,cf
nnoremap <Leader>cp :CopyPath<CR>
nnoremap <Leader>cf :CopyFileName<CR>
"↑ Vimで現在開いているファイルのパスを取得する設定
"
" ↓ CtrlP用の設定
" http://qiita.com/oahiroaki/items/d71337fb9d28303a54a8
" Prefix: s
nnoremap s <Nop>
nnoremap sa :<C-u>CtrlP<Space>
nnoremap sb :<C-u>CtrlPBuffer<CR>
nnoremap sd :<C-u>CtrlPDir<CR>
nnoremap sf :<C-u>CtrlP<CR>
nnoremap sl :<C-u>CtrlPLine<CR>
nnoremap sm :<C-u>CtrlPMRUFiles<CR>
nnoremap sq :<C-u>CtrlPQuickfix<CR>
nnoremap ss :<C-u>CtrlPMixed<CR>
nnoremap st :<C-u>CtrlPTag<CR>

let g:ctrlp_map = '<Nop>'
" Guess vcs root dir
let g:ctrlp_working_path_mode = 'ra'
" Open new file in current window
let g:ctrlp_open_new_file = 'r'
let g:ctrlp_extensions = ['tag', 'quickfix', 'dir', 'line', 'mixed']
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:18'
" ↑ CtrlP用の設定
"
