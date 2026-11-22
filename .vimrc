"--------------------vim shortcut --------------------"
  " https://qiita.com/baby-degu/items/9b6b275b72c37a02001c
  " ■修飾語
  "   i: inside インサイド
  "   a: around　アラウンド
  "   t: to 〜へ
  " ■名詞
  "   w: word　単語
  "   s: sentence　文
  "   ): sentence (another way of doing it)　（文を表す別の表記方法）
  "   p: paragraph
  "   }: paragraph (another way of doing it)　（段落を表す別の表記方法）
  "   t: tag (think HTML/XML)　（HTML/XMLを連想せよ）
  "   b: block (think programming)　（プログラミングのブロックを連想せよ）
  " ■画面単位の移動
  "   M: 画面の中間に移動する
  "   ^U: 画面の半分だけ上に移動
  "   ^D: 画面の半分だけ下に移動
  "   ^F: ページダウン
  "   ^B: ページアップ
  " ■前後への移動
  "   Ctrl-i: 以前のナビゲーションロケーションに移動
  "   Ctrl-o: 以前の位置に戻る
  " ■基本的な変更/挿入オプション
  "   I: 行先頭から挿入する
  "   A: 行末尾から付け加えていく
  "   o: 現在の行から一行下に新しい行を追加する
  "   O: 現在の行から一行上に新しい行を追加する
  "   r: 現在カーソルで選択されている一文字を変更する
  "   R: 現在カーソルで選択されている一文字を変更し、入力状態のままになる
  " ■その他
  "   反対の行動は基本的に大文字

"--------------------netrwtree shortcut--------------------"
  "    Ex・・・・・起動
  "    gt・・・・・移動
  "・Open
  "    Enter・・・・ファイルを開く | ディレクトリを移動する
  "    v・・・・・・垂直方向で開く（画面分割）
  "    t・・・・・・新しいタブで表示する
  "・Move
  "    u・・・・・・前のディレクトリに戻る
  "    U・・・・・・戻ったディレクトリにまた戻る
  "・Other
  "    d・・・・・・ディレクトリを作成する
  "    %・・・・・・ファイルを作成する
  "    D・・・・・・ファイル/ディレクトリを削除する

"--------------------encoding--------------------"
  scriptencoding utf-8
  set encoding		  =utf-8
  set fileformats		=unix,dos,mac
  set fileencodings	=ucs-bom,utf-8,shift-jis,iso-2022-jp-3,iso-2022-jp-2,euc-jisx0213,euc-jp,cp932

  if &encoding == 'utf-8'
    set ambiwidth=double
  endif

"--------------------View--------------------"
  set number
  
  " show color scheme list -> colorscheme [tab]
  colorscheme desert

  "カーソル行の設定"
  highlight LineNr ctermfg=white
  highlight LineNr ctermbg=black
  set cursorline

  " インデントの縦線表示 (Vim 9+ の leadmultispace)
  set list
  set listchars=tab:»-
  silent! set listchars+=leadmultispace:\|\ 

  " ステータスラインを常に表示 (Powerline風・モード連動カラー)
  set laststatus=2
  set noshowmode

  function! s:setup_statusline_hl() abort
    " モードごとの配色 (jellybeans風: 256色 / True Color 両対応)
    highlight SLNormal       ctermfg=235 ctermbg=114 cterm=bold guifg=#151515 guibg=#99ad6a gui=bold
    highlight SLNormalSep    ctermfg=114 ctermbg=238            guifg=#99ad6a guibg=#404040
    highlight SLInsert       ctermfg=235 ctermbg=75  cterm=bold guifg=#151515 guibg=#70a5eb gui=bold
    highlight SLInsertSep    ctermfg=75  ctermbg=238            guifg=#70a5eb guibg=#404040
    highlight SLVisual       ctermfg=235 ctermbg=176 cterm=bold guifg=#151515 guibg=#c6b6ee gui=bold
    highlight SLVisualSep    ctermfg=176 ctermbg=238            guifg=#c6b6ee guibg=#404040
    highlight SLReplace      ctermfg=255 ctermbg=203 cterm=bold guifg=#ffffff guibg=#cf6a4c gui=bold
    highlight SLReplaceSep   ctermfg=203 ctermbg=238            guifg=#cf6a4c guibg=#404040
    highlight SLCommand      ctermfg=235 ctermbg=221 cterm=bold guifg=#151515 guibg=#fad07a gui=bold
    highlight SLCommandSep   ctermfg=221 ctermbg=238            guifg=#fad07a guibg=#404040
    highlight SLTerminal     ctermfg=235 ctermbg=80  cterm=bold guifg=#151515 guibg=#8fbfdc gui=bold
    highlight SLTerminalSep  ctermfg=80  ctermbg=238            guifg=#8fbfdc guibg=#404040

    highlight SLFile         ctermfg=252 ctermbg=238            guifg=#e8e8d3 guibg=#404040
    highlight SLFileSep      ctermfg=238 ctermbg=235            guifg=#404040 guibg=#262626
    highlight SLMid          ctermfg=247 ctermbg=235            guifg=#888888 guibg=#262626
    highlight SLInfoSep      ctermfg=238 ctermbg=235            guifg=#404040 guibg=#262626
    highlight SLInfo         ctermfg=250 ctermbg=238            guifg=#c8c8b8 guibg=#404040
    highlight SLInactive     ctermfg=244 ctermbg=236            guifg=#888888 guibg=#303030
  endfunction

  call s:setup_statusline_hl()

  function! StatuslineActive() abort
    let l:m = mode()
    if l:m ==# 'i'
      let [l:hl, l:sep, l:name] = ['SLInsert', 'SLInsertSep', 'INSERT']
    elseif l:m ==# 'v'
      let [l:hl, l:sep, l:name] = ['SLVisual', 'SLVisualSep', 'VISUAL']
    elseif l:m ==# 'V'
      let [l:hl, l:sep, l:name] = ['SLVisual', 'SLVisualSep', 'V-LINE']
    elseif l:m ==# "\<C-v>"
      let [l:hl, l:sep, l:name] = ['SLVisual', 'SLVisualSep', 'V-BLOCK']
    elseif l:m ==# 'R'
      let [l:hl, l:sep, l:name] = ['SLReplace', 'SLReplaceSep', 'REPLACE']
    elseif l:m ==# 'c'
      let [l:hl, l:sep, l:name] = ['SLCommand', 'SLCommandSep', 'COMMAND']
    elseif l:m ==# 't'
      let [l:hl, l:sep, l:name] = ['SLTerminal', 'SLTerminalSep', 'TERMINAL']
    else
      let [l:hl, l:sep, l:name] = ['SLNormal', 'SLNormalSep', 'NORMAL']
    endif

    let l:s = ''
    let l:s .= '%#' . l:hl . '# ' . l:name . ' %#' . l:sep . '#'
    let l:s .= '%#SLFile# %t%m%r %#SLFileSep#'
    let l:s .= '%#SLMid#%='
    let l:s .= '%#SLInfoSep#%#SLInfo# %{&fenc!=""?&fenc:&enc} │ %{&ff} │ %{&ft!=""?&ft:"no ft"} '
    let l:s .= '%#' . l:sep . '#%#' . l:hl . '# %p%% %l:%c '
    return l:s
  endfunction

  function! StatuslineInactive() abort
    return '%#SLInactive# %t%m%r %= %p%% %l:%c '
  endfunction

  augroup MyStatusline
    autocmd!
    autocmd ColorScheme * call s:setup_statusline_hl()
    autocmd WinEnter,BufEnter * setlocal statusline=%!StatuslineActive()
    autocmd WinLeave * setlocal statusline=%!StatuslineInactive()
  augroup END

  set statusline=%!StatuslineActive()

"--------------------Normalモード--------------------"
  " move vertically by visual line
  nnoremap j gj
  nnoremap k gk

  " move to beginning/end of line
  nnoremap B ^
  nnoremap E $

  "カーソルキーで行末／行頭の移動可能に設定。
  set whichwrap=b,s,[,],<,>
  nnoremap h <Left>
  "l を <Right>に置き換えて、折りたたみを l で開くことができるようにする。
  if has('folding')
   nnoremap <expr> l foldlevel(line('.')) ? "\<Right>zo" : "\<Right>"
  endif

  " 折りたたみ
  noremap f           za
  noremap F           zA

  " 画面の再描画時に検索結果のハイライトを消す
  noremap <C-L>	   :noh<C-L><CR>

  "<ESC>2回でハイライト解除, この設定を入れておかないと起動時の挙動がおかしくなる...
  nnoremap <ESC><ESC> :nohlsearch<CR><ESC>

  " 置換
  noremap S           :%s///g<LEFT><LEFT><LEFT>

"--------------------Insertモード--------------------"
  inoremap <C-A>     <HOME>
  inoremap <C-E>     <END>
  inoremap <C-D>     <DEL>
  inoremap <C-H>     <BS>
  inoremap <C-B>     <LEFT>
  inoremap <C-F>     <RIGHT>

  "BSで削除できるものを指定する
  " indent  : 行頭の空白
  " eol     : 改行
  " start   : 挿入モード開始位置より手前の文字
  set backspace=indent,eol,start

"--------------------commandモード--------------------"
  cnoremap <C-A>	   <HOME>
  cnoremap <C-E>     <END>
  cnoremap <C-D>	   <DEL>
  cnoremap <C-H>	   <BS>
  cnoremap <C-B>	   <LEFT>
  cnoremap <C-F>	   <RIGHT>
  cnoremap <C-K>     <ESC>lv$hda

"--------------------visualモード--------------------"
  vnoremap S	:s///g<LEFT><LEFT><LEFT>
  vnoremap J	gJ

  " インデント変更時はvisulal modeから抜けないようにする
  vnoremap > >gv
  vnoremap < <gv

  " カーソル位置の単語をヤンクした単語に置換
  vnoremap <silent> cy   c<C-r>0<ESC>:let@/=@1<CR>:noh<CR>

"--------------------折り畳み--------------------"
  set foldmethod=indent "インデントで折り畳みを自動作成
  set foldcolumn=3 "ウィンドウの端に確保される折り畳みを表示
  set foldnestmax=2 " どのレベルの深さまで折りたたむか
  set foldlevelstart=0 " close most folds by default

"--------------------検索設定--------------------"
  set ignorecase "大文字/小文字の区別なく検索する
  set smartcase "検索文字列に大文字が含まれている場合は区別して検索する
  set wrapscan "検索時に最後まで行ったら最初に戻る
  set incsearch "インクリメンタル検索on"
  set hlsearch "highlight matches

"-------------------- タブ設定 --------------------"
  set tabstop=2 " Tabを画面上の見た目で何文字分に展開するかを指定
  set shiftwidth=2 " vimが自動で挿入する量
  set softtabstop=2 " キーボードで入力したTabで挿入される空白の量
  set expandtab " タブをスペースに変更

"-------------------- ファイル設定 --------------------"
  augroup MyFileSettings
    autocmd!
    autocmd BufNewFile,BufRead *.txt setlocal syntax=hybrid.vim
    autocmd FileType python setl tabstop=4 expandtab shiftwidth=4 softtabstop=4
    autocmd FileType rust setl tabstop=4 expandtab shiftwidth=4 softtabstop=4
    autocmd FileType Makefile setl noexpandtab 
    autocmd FileType zsh setlocal foldmethod=marker
  augroup END

"-------------------- ファイラー設定 --------------------"

  let g:netrw_liststyle = 3 " tree style listing
  let g:netrw_banner = 1 " 上のバナーを見せる (0で非表示)
  let g:netrw_winsize   = 70 " vで開くときにnetrwの領域を30%にする

  let g:netrw_altv = 1 " 'v'でファイルを開くときは右側に開く。(デフォルトが左側なので入れ替え)
  let g:netrw_alto = 1 " 'o'でファイルを開くときは下側に開く。(デフォルトが上側なので入れ替え)
  let g:netrw_keepdir = 0

"-------------------- その他 --------------------"
  " コマンドライン補完を見やすく、使いやすくする
  set wildmenu
  set wildmode=list:longest,full

  " 最後に編集を行った位置から再開
  autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

  " scrollが遅いことへの対策
  set lazyredraw " redraw only when we need to.
  set ttyfast
  set synmaxcol=200 " Vimが長いテキストで重くなる現象を回避 - Qiita http://qiita.com/shotat/items/da0f42ea90610ca0dadb

  set autoread   " 他での変更を自動再読み込み

  set autoindent " 自動でインデント

  " 現在のディレクトリに自動的に移動する
  set autochdir

  " マウスの設定
  set mouse=a

  " vim の自動文章折り返し機能を回避"
  set formatoptions=q

  " vimのヤンクとOSのクリップボードを共有する
  set clipboard+=unnamed

  " Don't keep a backup file
  set nobackup
  set noswapfile

  " vimのビープ音を殺す
  set vb t_vb=

  "カラー設定 最後に設定する
  syntax on
