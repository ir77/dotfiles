# --------------------基本設定-------------------- #
	PATH=/usr/local/bin:$PATH
	export PATH
	export PATH="/Applications/UpTeX.app/teTeX/bin:$PATH"
	
	# pythonからSkypeをプログラムで操作する際に必要
	#VERSIONER_PYTHON_PREFER_32_BIT=yes /usr/bin/python
	export VERSIONER_PYTHON_PREFER_32_BIT=yes
	
	# emacs like keybind 
	bindkey -e
	
	# Added by the Heroku Toolbelt
	export PATH="/usr/local/heroku/bin:$PATH"
# --------------------基本設定-------------------- #

#--------------------表示設定-------------------- 
	# プロンプトの設定
	autoload colors
	colors

	PROMPT="%n%% "
	RPROMPT="[%~]"
	SPROMPT="correct: %R -> %r ? "

	# lsコマンドとzsh補完候補の色を揃える設定
	unset LANG
	export LSCOLORS=ExFxCxdxBxegedabagacad
	export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
	zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
	zstyle ':completion:*:default' menu select=2
	zstyle ':completion:*' list-separator '-->'
	zstyle ':completion:*:manuals' separate-sections true

	#=============================
	## source zsh-syntax-highlighting
	##=============================
	if [ -f ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
	  source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
	fi
# ----------------------****---------------------- 

# --------------------補完設定-------------------- 
	# 補完機能を有効にする
	autoload -Uz compinit
	compinit
	# 補完で小文字でも大文字にマッチさせる
	zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 

	# cd したら自動的にpushdする
	setopt auto_pushd

	# 補完候補が複数あるときに自動的に一覧表示する
	setopt auto_menu

	# 補完候補にファイルの種類も表示
	setopt list_types

	# bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)
	# setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示

#--------------------********--------------------

# --------------------ヒストリー-------------------- 
	# ヒストリの設定
	HISTFILE=~/.zsh_history
	HISTSIZE=1000000
	SAVEHIST=1000000

	# 重複したコマンドを無視する
	setopt hist_ignore_dups

	# 重複したディレクトリを追加しない
	setopt pushd_ignore_dups

	# 同時に起動したzshの間でヒストリを共有する
	setopt share_history
	 
	# 同じコマンドをヒストリに残さない
	setopt hist_ignore_all_dups

	autoload history-search-end
	zle -N history-beginning-search-backward-end history-search-end
	zle -N history-beginning-search-forward-end history-search-end
	bindkey "^P" history-beginning-search-backward-end
	bindkey "^N" history-beginning-search-forward-end

# --------------------********--------------------

# --------------------エイリアス------------------
	setopt complete_aliases # aliased ls needs if file/dir completions work
	bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

	# javaのコンパイル時に文字化けするのを防ぐ
	alias java='java -Dfile.encoding=UTF-8'
	alias javac='javac -J-Dfile.encoding=UTF-8'

	# erutaso
	alias erutaso="~/Code/Terminal/sl-master/./erutaso"

	# rmコマンドでゴミ箱に送る
	alias trashClean='rm ~/.trash/*'
	alias rm='gmv -f --backup=numbered --target-directory ~/.trash'

	# Dropbox以下の容量を調べるときに使うコマンド
	# sudo du -hxd 1 ~/Dropbox/    
	alias duDropbox="du -hxd 1 ~/Dropbox/"

	# グローバルエイリアス
	alias -g L='| less'
	alias -g G='| grep'
	# grep結果に色を点ける
	alias grep="grep -a --color"

	# Python実行時に.pycファイルを作成しないようにする
	alias python="python -B"

	# 画面クリア時にlsを行う
	alias clear=clear

	alias ls="ls -GFS"
	alias la="ls -aA"
	alias ll="ls -l"
	alias lal="ls -a -lA"

	alias memo="vim ~/Dropbox/Backup/memo.txt"
	alias vimrc="vim ~/.vimrc"
	alias zshrc="vim ~/.zshrc"

#--------------------********--------------------

#------------------- function -------------------
	function tex(){
		platex -kanji=sjis $1.tex
		jbibtex -kanji=sjis $1
		platex -kanji=sjis $1.tex
		platex -kanji=sjis $1.tex
		dvipdfmx $1.dvi
		open $1.pdf
	}

	function texEUC(){
		platex -kanji=euc $1.tex
		jbibtex -kanji=euc $1
		platex -kanji=euc $1.tex
		platex -kanji=euc $1.tex
		dvipdfmx $1.dvi
		open $1.pdf
	}

	function texUTF8(){
		platex -kanji=utf8 $1.tex
		jbibtex -kanji=utf8 $1
		platex -kanji=utf8 $1.tex
		platex -kanji=utf8 $1.tex
		dvipdfmx $1.dvi
		open $1.pdf
	}

	# w3mでgoogle検索
	function google() {
		local str opt
		if [ $ != 0 ]; then
			for i in $*; do
				str="$str+$i"
			done
			str=`echo $str | sed 's/^\+//'`
			opt='search?num=50&hl=ja&lr=lang_ja'
			opt="${opt}&q=${str}"
		fi
		w3m http://www.google.co.jp/$opt
	}

	#--- cd 時の仕掛け ---
	function precmd () {
		#path 指定のみで cd 実行
		pwd=`pwd`
		#実行の度に pwd 保存
		echo $pwd > ~/.curdir
	}
	# 端末を新規に開くと自動的に前回の pwd に移動して始める
	cd `cat ~/.curdir`

	function nkfgrep (){
		  #echo "grep $1 $2"
		  LC_CTYPE=C ~/.nkfgrep.sh $1 $2
		}

	function nkfdiff () {
		diff $1 $2 | nkf -u
	}

	function saveworkspace() {
		pwd=`pwd`
		#実行の度に pwd 保存
		echo $pwd > ~/.workspace
	}
	alias cdworkspace="cd `cat ~/.workspace`"

#------------------- function -------------------

#-------------------- その他 --------------------
	# ディレクトリ名だけでcdする
	setopt auto_cd

	## バックグラウンドジョブが終了したらすぐに知らせる。
	setopt no_tify

	# cd後に自動でls
	function chpwd() { ls }

	# 自動修正機能 ex.lls →  ls?
	setopt correct

	# 日本語ファイル名を表示可能にする
	setopt print_eight_bit
	 
	# フローコントロールを無効にする
	setopt no_flow_control
	 
	# '#' 以降をコメントとして扱う
	setopt interactive_comments
	 
	# ビープ音を鳴らないようにする
	setopt nolistbeep

	# 明確なドットの指定なしで.から始まるファイルをマッチ
	setopt globdots

	# Node.jsのバージョン管理
	source ~/Dropbox/Backup/Export/nvm/bash_completion
	# nvmの自動起動
	. ~/Dropbox/Backup/Export/nvm/nvm.sh 
	nvm use v0.8.9
	# nvm alias default v0.x.x としてエイリアスを作成し、
	# nvm use default とするのもあり

	# 他の設定ファイルを読み込む
	[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

	## 言語環境を日本語、UTF-8 にそろえておく
	export LANG=ja_JP.UTF-8
	export LESSCHARSET=utf-8 
	
# -------------------- その他 --------------------
