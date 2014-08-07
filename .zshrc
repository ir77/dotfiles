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

	# ${fg[...]} や $reset_color をロード
	autoload -U colors; colors

	#作業ディレクトリがクリーンなら緑
	#追跡されていないファイルがあるときは黄色
	#追跡されているファイルに変更があるときは赤
	#変更あり＋未追跡ファイルありで太字の赤
	function rprompt-git-current-branch {
		local name st color

		if [[ "$PWD" =~ '/\.git(/.*)?$' ]]; then
			return
		fi
		name=$(basename "`git symbolic-ref HEAD 2> /dev/null`")
		if [[ -z $name ]]; then
				return
		fi
		st=`git status 2> /dev/null`
		if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
				color=${fg[green]}
		elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
				color=${fg[yellow]}
		elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
				color=${fg_bold[red]}
		else
				color=${fg[red]}
	fi

	# %{...%} は囲まれた文字列がエスケープシーケンスであることを明示する
	# これをしないと右プロンプトの位置がずれる
	echo "%{$color%}$name%{$reset_color%} "
	}

	# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
	setopt prompt_subst

	#PROMPT="%n%% "
	#RPROMPT="[%~]"

	PROMPT=$'[( `rprompt-git-current-branch`) %~]\n[%B%F{white}%*%f%b] => '
	RPROMPT="--------------------------------------------------------"
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
	setopt hist_ignore_all_dups

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
	alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"
	alias cddot="cd ~/Dropbox/Backup/SymbolicLink/dotfiles"

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
	alias ememo="emacs ~/Dropbox/Backup/memo.txt"
	alias vimrc="vim ~/.vimrc"
	alias zshrc="vim ~/.zshrc"

	# 打ったコマンドの後ろ(suffix)を見て, 適当に宜しくやってくれるやつ
	# ./でpythonを開く
	alias -s py=python
	alias -s rb='ruby'
	
	alias excel="open /Applications/Microsoft\ Office\ 2011\ 23.40.30/Microsoft\ Excel.app"
	alias powerPoint="open /Applications/Microsoft\ Office\ 2011\ 23.40.30/Microsoft\ PowerPoint.app"
	alias word="open /Applications/Microsoft\ Office\ 2011\ 23.40.30/Microsoft\ Word.app"

	alias word="open /Applications/Microsoft\ Office\ 2011\ 23.40.30/Microsoft\ Word.app"

	alias disk_Utility="open /Applications/Utilities/Disk\ Utility.app"
	alias activity_Monitor="open /Applications/Utilities/Activity\ Monitor.app"

	alias -s {xlsx,xls,xltx,xlt,csv}=excel
	alias -s {docx,doc,dotx,dot}=word
	alias -s {pptx,ppt,potx,pot}=powerPoint

	# ./で画像を開く
	if [ `uname` = "Darwin" ]; then
	  alias eog='open -a Preview'
	fi
	alias -s {pdf,png,jpg,bmp,PNG,JPG,BMP}=eog

	# ./で圧縮ファイルを展開する
	function extract() {
	  case $1 in
		*.tar.gz|*.tgz) tar xzvf $1;;
		*.tar.xz) tar Jxvf $1;;
		*.zip) unzip $1;;
		*.lzh) lha e $1;;
		*.tar.bz2|*.tbz) tar xjvf $1;;
		*.tar.Z) tar zxvf $1;;
		*.gz) gzip -dc $1;;
		*.bz2) bzip2 -dc $1;;
		*.Z) uncompress $1;;
		*.tar) tar xvf $1;;
		*.arj) unarj $1;;
	  esac
	}
	alias -s {gz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract

	# ./でC言語の実行
	#function runcpp () { g++ -O2 $1; ./a.out }
	#function runc () { gcc -o $1; ./a.out }
	function runc () { gcc $1 && shift && ./a.out $@; rm a.out }
	function runcpp () { g++ $1 && shift && ./a.out $@; rm a.out }
	alias -s c=runc
	alias -s cpp=runcpp

	# .appの起動
	if [[ ! -e ~/.zsh/app ]]; then
		for i in /Applications/*.app; do
		file=$(basename "$i" .app)
		name=$(echo $file | tr '[ A-Z]' '[_a-z]')
		echo alias $name="\"open -a '$file'\"" >> ~/.zsh/app
		done
	fi
	source ~/.zsh/app

#--------------------********--------------------

#------------------- function -------------------
	function d(){
		open dict://$1
	}

	function tex(){
		VAR=`nkf -g $1.tex`
		if [ "${VAR}" = "Shift_JIS" ]; then
			platex -kanji=sjis $1.tex
			jbibtex -kanji=sjis $1
			platex -kanji=sjis $1.tex
			platex -kanji=sjis $1.tex
			dvipdfmx $1.dvi
			open $1.pdf
		elif [ "${VAR}" = "EUC-JP" ]; then
			platex -kanji=euc $1.tex
			jbibtex -kanji=euc $1
			platex -kanji=euc $1.tex
			platex -kanji=euc $1.tex
			dvipdfmx $1.dvi
			open $1.pdf
		fi
		echo ${VAR}
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


	# 一定時間以上かかる処理の場合は終了時に通知してくれる
	local COMMAND=""
	local COMMAND_TIME=""

	#--- cd 時の仕掛け ---
	function precmd () {
		#path 指定のみで cd 実行
		pwd=`pwd`
		#実行の度に pwd 保存
		echo $pwd > ~/.curdir

		if [ "$COMMAND_TIME" -ne "0" ] ; then
			local d=`date +%s`
			d=`expr $d - $COMMAND_TIME`
			if [ "$d" -ge "10" ] ; then
				COMMAND="$COMMAND "
				which terminal-notifier > /dev/null 2>&1 && terminal-notifier -message "${${(s: :)COMMAND}[1]}" -m "$COMMAND";
			fi
		fi
		COMMAND="0"
		COMMAND_TIME="0"
	}

	preexec () {
		COMMAND="${1}"
		if [ "`perl -e 'print($ARGV[0]=~/ssh|^vi/)' $COMMAND`" -ne 1 ] ; then
			COMMAND_TIME=`date +%s`
		fi
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

	function command_not_found_handler() {
		local str opt
		if [ $# != 0 ]; then
			for i in $*; do
				# $strが空じゃない場合、検索ワードを+記号でつなぐ(and検索)
				str="$str${str:++}$i"
			done
			opt='search?num=100'
			opt="${opt}&q=${str}"
		fi
		open -a Safari http://www.google.co.jp/$opt
	}

	function history-all { history -E 1 }

	function peco-select-history() {
		local tac
		if which tac > /dev/null; then
			tac="tac"
		else
			tac="tail -r"
		fi
		BUFFER=$(history -n 1 | \
			eval $tac | \
			peco --query "$LBUFFER"
		)
	}
	zle -N peco-select-history
	bindkey '^r' peco-select-history

	# {{{
	# cd 履歴を記録
	typeset -U chpwd_functions
	CD_HISTORY_FILE=${HOME}/.cd_history_file # cd 履歴の記録先ファイル
	function chpwd_record_history() {
		echo $PWD >> ${CD_HISTORY_FILE}
	}
	chpwd_functions=($chpwd_functions chpwd_record_history)

	# peco を使って cd 履歴の中からディレクトリを選択
	# 過去の訪問回数が多いほど選択候補の上に来る
	function peco_get_destination_from_history() {
		sort ${CD_HISTORY_FILE} | uniq -c | sort -r | \
			sed -e 's/^[ ]*[0-9]*[ ]*//' | \
			sed -e s"/^${HOME//\//\\/}/~/" | \
			peco | xargs echo
	}

	# peco を使って cd 履歴の中からディレクトリを選択し cd するウィジェット
	function peco_cd_history() {
		local destination=$(peco_get_destination_from_history)
		echo "cd "${destination/#\~/${HOME}}
		[ -n $destination ] && cd ${destination/#\~/${HOME}}
		zle reset-prompt
	}
	zle -N peco_cd_history
	# }}}
	bindkey '^s' peco_cd_history

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
	#source ~/Dropbox/Backup/Export/nvm/bash_completion

	# nvmの自動起動
	#. ~/Dropbox/Backup/Export/nvm/nvm.sh 
	#nvm use v0.8.9
	# nvm alias default v0.x.x としてエイリアスを作成し、
	# nvm use default とするのもあり

	# 濁点・半濁点の入ったファイルの表示
	setopt COMBINING_CHARS

	# ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
	# setopt auto_param_slash      

	# 他の設定ファイルを読み込む
	[ -f ~/.zshrc.mine ] && source ~/.zshrc.mine

	## 言語環境を日本語、UTF-8 にそろえておく
	export LANG=ja_JP.UTF-8
	export LESSCHARSET=utf-8 
	
# -------------------- その他 --------------------

# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
export COCOS_CONSOLE_ROOT=/Users/JP20014/Desktop/cocos2d-x/tools/cocos2d-console/bin
export PATH=$COCOS_CONSOLE_ROOT:$PATH

# Add environment variable ANT_ROOT for cocos2d-x
export ANT_ROOT=/usr/local/Cellar/ant/1.9.4/libexec/bin
export PATH=$ANT_ROOT:$PATH
