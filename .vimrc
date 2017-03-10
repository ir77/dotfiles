"--------------------encoding--------------------"
  scriptencoding utf-8
  set termencoding	=utf-8
  set encoding		=utf-8
  set fileformats		=unix,dos,mac
  set fileencoding	=utf-8
  set fileencodings	=ucs-bom,utf-8,shift-jis,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932

  if &encoding == 'utf-8'
    set ambiwidth=double
  endif

"-------------------- dein.vim --------------------"
  let s:dein_dir = expand('~/.cache/dein') " プラグインが実際にインストールされるディレクトリ
  let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

  if &runtimepath !~# '/dein.vim'
    if !isdirectory(s:dein_repo_dir)
      execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
    endif
    execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
  endif

  if dein#load_state(s:dein_dir)
    call dein#begin(s:dein_dir)

    " プラグインリストを収めた TOML ファイル
    " 予め TOML ファイル（後述）を用意しておく
    let g:rc_dir    = expand('~/.vim/rc')
    let s:toml      = g:rc_dir . '/dein.toml'
    let s:lazy_toml = g:rc_dir . '/dein_lazy.toml'

    " TOML を読み込み、キャッシュしておく
    call dein#load_toml(s:toml,      {'lazy': 0})
    call dein#load_toml(s:lazy_toml, {'lazy': 1})

    call dein#end()
    call dein#save_state()
  endif

  if dein#check_install()
    call dein#install()
  endif

"--------------------View--------------------"
  set number
  set t_Co=256

  "colorscheme desert
  "colorscheme molokai
  "colorscheme zenburn

  highlight Normal ctermbg=black ctermfg=grey
  highlight StatusLine term=none cterm=none ctermfg=black ctermbg=grey
  "カーソル行の強調"
  highlight LineNr ctermfg=white
  highlight LineNr ctermbg=black
  set cursorline

  " au BufRead,BufNewFile *.txt set syntax=desert.vim
  au BufRead,BufNewFile *.txt set syntax=hybrid.vim
  au BufRead,BufNewFile *.jinja2 set syntax=htmljinja.vim

  " ファイルエンコーディングや文字コードをステータス行に表示する
  set laststatus=2 "ステータスラインを常に表示
  set statusline=%<%f\ %m\ %r%h%w%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=\ (%v,%l)/%L%8P\

  " 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
  let g:netrw_altv = 1
  " 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
  let g:netrw_alto = 1
  let g:netrw_keepdir = 0

  "Enter・・・ファイルを開く | ディレクトリを移動する
  "o・・・水平方向で開く（画面分割）
  "v・・・垂直方向で開く（画面分割）
  "t・・・新しいタブで表示する
  "p・・・プレビューウィンドウで表示する
  "-・・・上の階層に移動
  "u・・・前のディレクトリに戻る
  "U・・・戻ったディレクトリにまた戻る
  "c・・・開いているバッファ（%a）をカレントディレクトリに変更

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

"--------------------Normalモード--------------------"
  nnoremap <C-[> :<C-u>tab stj <C-R>=expand('<cword>')<CR><CR> " ctagsジャンプ
  nnoremap <C-]> g<C-]>

  noremap f           za
  " noremap F           zA

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

  " タブの移動をemacs風に
  " nnoremap <C-b>  gT
  " nnoremap <C-f>  gt

"--------------------Insertモード--------------------"
  inoremap <C-A>     <HOME>
  inoremap <C-E>     <END>
  inoremap <C-D>     <DEL>
  inoremap <C-H>     <BS>
  inoremap <C-B>     <LEFT>
  inoremap <C-F>     <RIGHt>
  inoremap <C-N>	   <DOWN>
  inoremap <C-P>	   <UP>

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
  vnoremap J	gJ

  " カーソル位置の単語をヤンクした単語に置換
  vnoremap <silent> cy   c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

"--------------------折り畳み--------------------"
  "インデントで折り畳みを自動作成
  set foldmethod=indent
  "ウィンドウの端に確保される折り畳みを表示
  set foldcolumn=3
  "すべての折り畳みを閉じる
  set foldlevel=2
  " どのレベルの深さまで折りたたむか
  set foldnestmax=2

"--------------------検索設定--------------------"
  set ignorecase "大文字/小文字の区別なく検索する
  set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
  set wrapscan "検索時に最後まで行ったら最初に戻る

"-------------------- その他 --------------------"
  set synmaxcol=200 " Vimが長いテキストで重くなる現象を回避 - Qiita http://qiita.com/shotat/items/da0f42ea90610ca0dadb
  set modeline   " expand tabが効かなくなったので追加
  set autoread   " 他での変更を自動再読み込み

  set autoindent " 自動でインデント
  " set paste      " ペースト時にautoindentを無効に(onにするとC-PNBFなどが動かない)

  " 現在のディレクトリに自動的に移動する
  set autochdir

  " マウスの設定
  set mouse=a

  " Use Vim default instead of 100% vi compativility
  " viとの互換性を無効にする(INSERT中にカーソルキーが有効になる)
  set nocompatible

  "日本語の全角文字を直す
  set ambiwidth=double

  " TABの幅を指定
  " Tabを画面上の見た目で何文字分に展開するかを指定
  set tabstop=2
  " vimが自動で挿入する量
  set shiftwidth=2
  " キーボードで入力したTabで挿入される空白の量
  set softtabstop=2
  " タブをスペースに変更
  set expandtab

  "インデントラインを設定"
  let g:indentLine_char = '|'

  " vim の自動文章折り返し機能を回避"
  set formatoptions=q

  " vimのヤンクとOSのクリップボードを共有する
  set clipboard+=unnamed

  " Don't keep a backup file
  set nobackup
  set noswapfile

  "インクリメンタル検索on"
  set incsearch

  "スクロール開始行の設定 ex.5 => 下上5行目からスクロール開始"
  " set scrolloff=5

  " vimのビープ音を殺す
  set vb t_vb=

  " scrollが遅いことを解決できる？
  set lazyredraw
  set ttyfast

  "カラー設定 最後に設定する
  syntax on
