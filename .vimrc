"--------------------基本設定--------------------"
	scriptencoding utf-8

"--------------------NeoBundle--------------------"
	if has('vim_starting')
		filetype plugin off
		filetype indent off
		execute 'set runtimepath+=' . expand('~/.vim/bundle/neobundle.vim')
		call neobundle#rc(expand('~/.vim/bundle'))
	endif
	NeoBundle 'git://github.com/Shougo/neobundle.vim.git'
	"after install, turn shell ~/.vim/bundle/vimproc, (n,g)make-f your_machines_makefile
	NeoBundle 'Shougo/vimproc'
	NeoBundle 'Shougo/neocomplcache'
	NeoBundle 'Shougo/neosnippet'
	NeoBundle 'Shougo/neosnippet-snippets'
	NeoBundle 'git://github.com/scrooloose/syntastic.git'
	NeoBundle 'git://github.com/Yggdroot/indentLine.git'
	NeoBundle 'kana/vim-submode'
	NeoBundle 'Align'

"--------------------neosnippet--------------------"
	" <TAB>: completion.
	" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	inoremap <expr><S-TAB>  pumvisible() ? "\<C-p>" : "\<S-TAB>"
	"tabで補完候補の選択を行う
	"inoremap <expr><TAB> pumvisible() ? "\<Down>" : "\<TAB>"
	"inoremap <expr><S-TAB> pumvisible() ? "\<Up>" : "\<S-TAB>"

	" Plugin key-mappings.
	imap <C-k>     <Plug>(neosnippet_expand_or_jump)
	smap <C-k>     <Plug>(neosnippet_expand_or_jump)

	" SuperTab like snippets behavior.
	" imap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
	imap <expr><TAB> pumvisible() ? "\<C-n>" : neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"
	smap <expr><TAB> neosnippet#jumpable() ? "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

	" 前回行われた補完をキャンセルします
	inoremap <expr><C-g> neocomplcache#undo_completion()
	" 補完候補のなかから、共通する部分を補完します
	inoremap <expr><C-l> neocomplcache#complete_common_string()
	" 改行で補完ウィンドウを閉じる
	inoremap <expr><CR> neocomplcache#smart_close_popup() . "\<CR>"

	" For snippet_complete marker.
	if has('conceal')
		set conceallevel=2 concealcursor=i
	endif

	" 補完ウィンドウの設定
	set completeopt=menuone
	 
	" 起動時に有効化
	let g:neocomplcache_enable_at_startup = 1
	 
	" 大文字が入力されるまで大文字小文字の区別を無視する
	let g:neocomplcache_enable_smart_case = 1
	 
	" _(アンダースコア)区切りの補完を有効化
	let g:neocomplcache_enable_underbar_completion = 1
	let g:neocomplcache_enable_camel_case_completion  =  1
	 
	" ポップアップメニューで表示される候補の数
	let g:neocomplcache_max_list = 20
	 
	" シンタックスをキャッシュするときの最小文字長
	let g:neocomplcache_min_syntax_length = 2
	 
	" ディクショナリ定義
	let g:neocomplcache_dictionary_filetype_lists = {
		\ 'default' : ''
		\ }
	 
	if !exists('g:neocomplcache_keyword_patterns')
			let g:neocomplcache_keyword_patterns = {}
	endif

	let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

"--------------------View設定--------------------"
	colorscheme desert
	"colorscheme molokai
	"colorscheme zenburn

	"カラー設定"
	syntax on

	highlight Normal ctermbg=black ctermfg=grey
	"highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
	"highlight CursorLine term=none cterm=none ctermfg=none ctermbg=darkgray

	"カーソル行の強調"
	set cursorline
	"行数を表示"
	set number

	"インデントラインを設定"
	set list lcs=tab:\|\ 

	" ファイルエンコーディングや文字コードをステータス行に表示する
	set laststatus=2 "ステータスラインを常に表示
	set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\ 

	" 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
	let g:netrw_altv = 1
	" 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
	let g:netrw_alto = 1

	"Enter・・・ファイルを開く | ディレクトリを移動する
	"o・・・水平方向で開く（画面分割）
	"v・・・垂直方向で開く（画面分割）
	"t・・・新しいタブで表示する
	"p・・・プレビューウィンドウで表示する
	"-・・・上の階層に移動
	"u・・・前のディレクトリに戻る
	"U・・・戻ったディレクトリにまた戻る
	"c・・・開いているバッファ（%a）をカレントディレクトリに変更
	
	"vimのすごい便利なのにあまり使われていない「タブページ」機能 - Qiita
	"http://qiita.com/wadako111/items/755e753677dd72d8036d
	" Anywhere SID.
	function! s:SID_PREFIX()
	  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
	endfunction

	" Set tabline.
	function! s:my_tabline()  "{{{
	  let s = ''
	  for i in range(1, tabpagenr('$'))
		let bufnrs = tabpagebuflist(i)
		let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
		let no = i  " display 0-origin tabpagenr.
		let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
		let title = fnamemodify(bufname(bufnr), ':t')
		let title = '[' . title . ']'
		let s .= '%'.i.'T'
		let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
		let s .= no . ':' . title
		let s .= mod
		let s .= '%#TabLineFill# '
	  endfor
	  let s .= '%#TabLineFill#%T%=%#TabLine#'
	  return s
	endfunction "}}}

	let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

	" The prefix key.
	nnoremap    [Tag]   <Nop>
	nmap    t [Tag]
	" Tab jump
	" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ
	for n in range(1, 9)
	  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
	endfor

	" tc 新しいタブを一番右に作る
	map <silent> [Tag]c :tablast <bar> tabnew<CR>
	" tx タブを閉じる
	map <silent> [Tag]x :tabclose<CR>
	" tn 次のタブ
	map <silent> [Tag]n :tabnext<CR>
	" tp 前のタブ
	map <silent> [Tag]p :tabprevious<CR>

"--------------------Normalモード--------------------"
	"noremap <C-A>	   <HOME>
	"noremap <C-E>	   <END>
	noremap f           za
	noremap F           zA

	"カーソルキーで行末／行頭の移動可能に設定。
	set whichwrap=b,s,[,],<,>
	nnoremap h <Left>
	nnoremap l <Right>
	"l を <Right>に置き換えて、折りたたみを l で開くことができるようにする。
	if has('folding')
		nnoremap <expr> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
	endif
	
	" 画面の再描画時に検索結果のハイライトを消す
	noremap <C-L>	   :noh<C-L><CR>

	" 置換
    noremap S           :%s///g<LEFT><LEFT><LEFT>

	" 一行挿入
	noremap <CR> o<ESC>
	noremap <S-CR> O<ESC>

	" スペースキーを使ってスクロール
	nnoremap <Space> jzz
	nnoremap <S-Space> kzz

	"Vimの便利な画面分割＆タブページと、それを更に便利にする方法 - Qiita
	"http://qiita.com/tekkoc/items/98adcadfa4bdc8b5a6ca
	"画面分割時のウィンドウサイズの変更を便利にする
	call submode#enter_with('bufmove', 'n', '', 's>', '<C-w><')
	call submode#enter_with('bufmove', 'n', '', 's<', '<C-w>>')
	call submode#enter_with('bufmove', 'n', '', 's+', '<C-w>+')
	call submode#enter_with('bufmove', 'n', '', 's-', '<C-w>-')
	call submode#map('bufmove', 'n', '', '>', '<C-w><')
	call submode#map('bufmove', 'n', '', '<', '<C-w>>')
	call submode#map('bufmove', 'n', '', '+', '<C-w>+')
	call submode#map('bufmove', 'n', '', '-', '<C-w>-')
	
"--------------------Insertモード--------------------"
	inoremap <C-A>     <HOME>
	inoremap <C-E>     <END>
	inoremap <C-D>     <DEL>
	inoremap <C-B>     <LEFT>
	inoremap <C-H>     <BS>
	inoremap <C-F>     <RIGHt>

	"非補完時は行移動をj,kと同じ動作にして補完中は候補選択
	"inoremap <silent> <expr> <C-p>  pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
	"inoremap <silent> <expr> <C-n>  pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"
	"inoremap <silent> <expr> <Up>   pumvisible() ? "\<C-p>" : "<C-r>=MyExecExCommand('normal k')<CR>"
	"inoremap <silent> <expr> <Down> pumvisible() ? "\<C-n>" : "<C-r>=MyExecExCommand('normal j')<CR>"
	inoremap <C-N>	   <DOWN>
	inoremap <C-P>	   <UP>

	" jj でノーマルモードに移動する 
	"inoremap jj <esc>

	"BSで削除できるものを指定する
	" indent  : 行頭の空白
	" eol     : 改行
	" start   : 挿入モード開始位置より手前の文字
	set backspace=indent,eol,start

"--------------------commandモード--------------------"
	cnoremap <C-F>	   <RIGHT>
	cnoremap <C-B>	   <LEFT>
	cnoremap <C-A>	   <HOME>
	cnoremap <C-E>     <END>
	cnoremap <C-D>	   <DEL>
	cnoremap <C-H>	   <BS>
	cnoremap <C-K>     <ESC>lv$hda

"--------------------visualモード--------------------"
	vnoremap S	:s///g<LEFT><LEFT><LEFT>
	vnoremap =	:Align 
	
	" カーソル位置の単語をヤンクした単語に置換
	vnoremap <silent> cy   c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

"--------------------折り畳み--------------------"
	"インデントで折り畳みを自動作成
	set foldmethod=indent 
	"ウィンドウの端に確保される折り畳みを表示
	set foldcolumn=3 
	"すべての折り畳みを閉じる
	set foldlevel=0 
	" どのレベルの深さまで折りたたむか
	set foldnestmax=2

"--------------------encoding--------------------"
	set termencoding	=utf-8
	set encoding		=utf-8
	set fileformats		=unix,dos,mac
	set fileencoding	=utf-8
	set fileencodings	=ucs-bom,utf-8,shift-jis,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932

	if &encoding == 'utf-8'
		set ambiwidth=double
	endif

"--------------------検索設定--------------------"
	set ignorecase "大文字/小文字の区別なく検索する
	set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
	set wrapscan "検索時に最後まで行ったら最初に戻る

"-------------------- その他 --------------------"
	filetype plugin on
	filetype indent on

	" マウスの設定
	set mouse=a

	" Use Vim default instead of 100% vi compativility
	" viとの互換性を無効にする(INSERT中にカーソルキーが有効になる)
	set nocompatible

	"日本語の全角文字を直す
	set ambiwidth=double

	" TABの幅を指定
	" Tabを画面上の見た目で何文字分に展開するかを指定
	set tabstop		=4
	" vimが自動で挿入する量
	set shiftwidth	=4
	" キーボードで入力したTabで挿入される空白の量
	set softtabstop =4

	" vim の自動文章折り返し機能を回避"
	set formatoptions=q

	" 自動でインデント
	set autoindent

	" vimのヤンクとOSのクリップボードを共有する
	set clipboard=unnamed,autoselect

	" Don't keep a backup file
	set nobackup

	" 閉じ括弧が入力されたとき対応する括弧を表示
	set showmatch

	"インクリメンタル検索on"
	set incsearch

	"スクロール開始行の設定 ex.5 => 下上5行目からスクロール開始"
	set scrolloff=5

	" vimのビープ音を殺す
	set vb t_vb=

"--------------------別ファイルの読み込み--------------------"
	"if filereadable(expand('~/.vimrc.chInsert'))
	"	source ~/.vimrc.chInsert
	"endif

