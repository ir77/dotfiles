# -------------------- Message ------------------
cat << EOS
=============================================

welcome to ...

##  #  ####   #####  #### ##  # 
##  # ### #      ## ##    ##  # 
##  # ##        ##  ###   ##  # 
##  # ##       ###   ###  ##### 
##  # ##       ##     ### ##  # 
##  # ###     ##       ## ##  # 
 ###   ####   ##### ####  ##  # 

=============================================

EOS

# -------------------- 基本設定 ------------------
	function basicSettings {
		export PATH=/usr/local/bin:$PATH
		
		# emacs like keybind 
		bindkey -e
	}
	basicSettings

# -------------------- プロンプト表示設定 -------------
	function myPromptSettings {
		autoload colors
		colors
		autoload -Uz vcs_info
		autoload -Uz add-zsh-hook
		autoload -Uz is-at-least
		autoload -Uz colors

		# ${fg[...]} や $reset_color をロード
		autoload -U colors; colors

		# 以下の3つのメッセージをエクスポートする
		#$vcs_info_msg_0_ : 通常メッセージ用 (緑)
		#$vcs_info_msg_1_ : 警告メッセージ用 (黄色)
		#$vcs_info_msg_2_ : エラーメッセージ用 (赤)
		zstyle ':vcs_info:*' max-exports 3

		zstyle ':vcs_info:*' enable git svn hg bzr
		# 標準のフォーマット(git 以外で使用)
		# misc(%m) は通常は空文字列に置き換えられる
		zstyle ':vcs_info:*' formats '(%s)-[%b]'
		zstyle ':vcs_info:*' actionformats '(%s)-[%b]' '%m' '<!%a>'
		zstyle ':vcs_info:(svn|bzr):*' branchformat '%b:r%r'
		zstyle ':vcs_info:bzr:*' use-simple true

		if is-at-least 4.3.10; then
			# git 用のフォーマット
			# git のときはステージしているかどうかを表示
			zstyle ':vcs_info:git:*' formats '(%s)-[%b]' '%c%u %m'
			zstyle ':vcs_info:git:*' actionformats '(%s)-[%b]' '%c%u %m' '<!%a>'
			zstyle ':vcs_info:git:*' check-for-changes true
			zstyle ':vcs_info:git:*' stagedstr "+"    # %c で表示する文字列
			zstyle ':vcs_info:git:*' unstagedstr "-"  # %u で表示する文字列
		fi

		# プロンプトが表示されるたびにプロンプト文字列を評価、置換する
		setopt prompt_subst
	}
	myPromptSettings

	if is-at-least 4.3.11; then
		zstyle ':vcs_info:git+set-message:*' hooks \
												git-hook-begin \
												git-untracked \
												git-push-status \
												git-nomerge-branch \
												git-stash-count

		function +vi-git-hook-begin() {
			if [[ $(command git rev-parse --is-inside-work-tree 2> /dev/null) != 'true' ]]; then
				# 0以外を返すとそれ以降のフック関数は呼び出されない
				return 1
			fi

			return 0
		}

		function +vi-git-untracked() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if command git status --porcelain 2> /dev/null \
				| awk '{print $1}' \
				| command grep -F '??' > /dev/null 2>&1 ; then

				# unstaged (%u) に追加
				hook_com[unstaged]+='?'
			fi
		}

		function +vi-git-push-status() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if [[ "${hook_com[branch]}" != "master" ]]; then
				# master ブランチでない場合は何もしない
				return 0
			fi

			# push していないコミット数を取得する
			local ahead
			ahead=$(command git rev-list origin/master..master 2>/dev/null \
				| wc -l \
				| tr -d ' ')

			if [[ "$ahead" -gt 0 ]]; then
				# misc (%m) に追加
				hook_com[misc]+="(p${ahead})"
			fi
		}

		function +vi-git-nomerge-branch() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			if [[ "${hook_com[branch]}" == "master" ]]; then
				# master ブランチの場合は何もしない
				return 0
			fi

			local nomerged
			nomerged=$(command git rev-list master..${hook_com[branch]} 2>/dev/null | wc -l | tr -d ' ')

			if [[ "$nomerged" -gt 0 ]] ; then
				# misc (%m) に追加
				hook_com[misc]+="(m${nomerged})"
			fi
		}

		function +vi-git-stash-count() {
			# zstyle formats, actionformats の2番目のメッセージのみ対象にする
			if [[ "$1" != "1" ]]; then
				return 0
			fi

			local stash
			stash=$(command git stash list 2>/dev/null | wc -l | tr -d ' ')
			if [[ "${stash}" -gt 0 ]]; then
				# misc (%m) に追加
				hook_com[misc]+=":S${stash}"
			fi
		}
	fi

	CURRENT_BG='NONE'
	SEGMENT_SEPARATOR=$'\UE0B0'$'\UE0B0'$'\UE0B0'
	R_SEGMENT_SEPARATOR=$'\UE0B2'$'\UE0B2'$'\UE0B2'

	declare m_prompt=""
	declare m_prompt_color="0"
	function _update_vcs_info_msg() {
		local -a messages
		# local m_prompt

		LANG=en_US.UTF-8 vcs_info

		if [[ -z ${vcs_info_msg_0_} ]]; then
			# vcs_info で何も取得していない場合はプロンプトを表示しない
			# m_prompt=$'[%B%F{white}%*%f%b]'
			m_prompt=""
			m_prompt_color="0"
		else
			# vcs_info で情報を取得した場合
			# $vcs_info_msg_0_ , $vcs_info_msg_1_ , $vcs_info_msg_2_ を
			# それぞれ緑、黄色、赤で表示する
			[[ -n "$vcs_info_msg_0_" ]] && messages+=( "${vcs_info_msg_0_}" )
			[[ -n "$vcs_info_msg_1_" ]] && messages+=( "${vcs_info_msg_1_}" )
			[[ -n "$vcs_info_msg_2_" ]] && messages+=( "${vcs_info_msg_2_}" )

			if [[ -n "$vcs_info_msg_2_" ]]; then
				m_prompt_color="2"
			elif [[ "$vcs_info_msg_1_" != ' ' ]]; then
				if [[ -n "$vcs_info_msg_1_" ]]; then
					m_prompt_color="1"
				fi
			elif [[ -n "$vcs_info_msg_0_" ]]; then
				m_prompt_color="0"
			fi
			
			# 間にスペースを入れて連結する
			m_prompt="⭠ ${(j: :)messages}"
		fi
	}


	# Begin a segment
	# Takes two arguments, background and foreground. Both can be omitted,
	# rendering default background/foreground.
	prompt_segment() {
		local bg fg
		[[ -n $1 ]] && bg="%K{$1}" || bg="%k"
		[[ -n $2 ]] && fg="%F{$2}" || fg="%f"
		if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
      echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
		else
			echo -n "%{$bg%}%{$fg%} "
		fi
		CURRENT_BG=$1
		[[ -n $3 ]] && echo -n $3
	}

	# End the prompt, closing any open segments
	prompt_end() {
		if [[ -n $CURRENT_BG ]]; then
      echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR "
		else
			echo -n "%{%k%}"
		fi
		echo -n "%{%f%}"
		# CURRENT_BG=''
	}

	### Prompt components
	# Each component will draw itself, and hide itself if no information needs to be shown

	# Context: user@hostname (who am I and where am I)
	prompt_context() {
		local user=`whoami`
		if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
      echo -n "%{%K{white}%}%{%F{black}%} %(!.%{%F{yellow}%}.)$user@%m "
		fi
	}

	# Dir: current working directory
	prompt_dir() {
    echo -n "%{%K{white}%}%{%F{black}%} \UE0B2"
    wd=${pwd/\//''}
    wdArray=( `echo $wd | tr -s '/' ' '`)
		if [[ ${#wdArray[@]} -ge '4' ]]; then
      echo -n "%{%K{blue}%}%{%F{black}%} ... \UE0B1 ${wdArray[${#wdArray[@]}-2]} \UE0B1 ${wdArray[${#wdArray[@]}-1]} \UE0B1 ${wdArray[${#wdArray[@]}]} \UE0B1 "
    else
      echo -n "%{%K{blue}%}%{%F{black}%} ${wd//\// \UE0B1 } "
    fi
	}

	# Status:
	# - was there an error
	# - am I root
	# - are there background jobs?
	prompt_status() {
		local symbols
		symbols=()
		[[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘"
		[[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡"
		[[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

		[[ -n "$symbols" ]] && prompt_segment black default "$symbols"
	}

	echo_message() {
		if [[ "$m_prompt_color" == "2" ]]; then
			prompt_segment red black
		elif [[ "$m_prompt_color" == "1" ]]; then
			prompt_segment yellow black
		else
			# prompt_segment green black
			prompt_segment cyan black
		fi
		echo -n "$m_prompt"
	}

	## Main prompt
	left_prompt() {
		RETVAL=$?
		prompt_status
		echo_message
    prompt_end
	}

	right_prompt() {
		RETVAL=$?
    echo -n " %{%k%F{white}%}$R_SEGMENT_SEPARATOR"
		prompt_context
		prompt_dir
	}

  PROMPT='$(left_prompt)'
  RPROMPT='$(right_prompt)'

	function myPromptSettings2 {
		add-zsh-hook precmd _update_vcs_info_msg

		# lsコマンドとzsh補完候補の色を揃える設定
		# unset LANG
		# export LSCOLORS=ExFxCxdxBxegedabagacad
		# export LS_COLORS='di=01;34:ln=01;35:so=01;32:ex=01;31:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'

		# 補完関数の表示を強化する
		zstyle ':completion:*' list-colors 'di=;34;1' 'ln=;35;1' 'so=;32;1' 'ex=31;1' 'bd=46;34' 'cd=43;34'
		zstyle ':completion:*:default' menu select=2
		zstyle ':completion:*:manuals' separate-sections true
		zstyle ':completion:*' verbose yes
		zstyle ':completion:*' completer _expand _complete _match _prefix _approximate _list _history
		zstyle ':completion:*:messages' format '%F{YELLOW}%d'$DEFAULT
		zstyle ':completion:*:warnings' format '%F{RED}No matches for:''%F{YELLOW} %d'$DEFAULT
		zstyle ':completion:*:descriptions' format '%F{YELLOW}completing %B%d%b'$DEFAULT
		zstyle ':completion:*:options' description 'yes'
		zstyle ':completion:*:descriptions' format '%F{yellow}Completing %B%d%b%f'$DEFAULT

		zstyle ':completion:*:manuals' separate-sections true
		zstyle ':completion:*' list-separator '-->'

		# マッチ種別を別々に表示
		zstyle ':completion:*' group-name ''

		#=============================
		## source zsh-syntax-highlighting
		##=============================
		if [ -f ~/.zsh/zsh-syntax-highlighting.zsh ]; then
		  source ~/.zsh/zsh-syntax-highlighting.zsh
		else 
		  mkdir ~/.zsh
		  git clone git://github.com/zsh-users/zsh-syntax-highlighting.git ~/.zsh
		fi
	}
	myPromptSettings2

# --------------------補完設定-------------------- 
	function myCompletionSettings {
		autoload -Uz compinit # 補完機能を有効にする
		compinit
		# 補完で小文字でも大文字にマッチさせる
		zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' 

		# cd したら自動的にpushdする
		setopt auto_pushd

		# 補完候補が複数あるときに自動的に一覧表示する
		setopt auto_menu

		# bindkey "^I" menu-complete   # 展開する前に補完候補を出させる(Ctrl-iで補完するようにする)
		# setopt always_last_prompt    # カーソル位置は保持したままファイル名一覧を順次その場で表示
		#
		# 補完候補にファイルの種類も表示
		setopt list_types

    setopt auto_list # 補完候補を一覧で表示する(d)

    setopt list_packed # 補完候補をできるだけ詰めて表示する
	}
	myCompletionSettings

# --------------------ヒストリー-------------------- 
	function myHistorySettings {
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
	}
	myHistorySettings

# --------------------エイリアス------------------
	function myAliasSettings {
    alias history="history -Di 1" # 実行時間とかかった時間を表示

    alias cp="cp -i" # 保険で警告
    alias mv="mv -i" # 保険で警告

		alias lgtm='sh ~/Dropbox/code/shellscript/lgtm.sh/lgtm.sh -m | pbcopy'
		alias playground='open ~/Dropbox/code/XcodePlayground/MyPlayground.playground'

		alias sl="/Users/ucucAir2/Dropbox/code/script/sl/sl"
		alias jsc="/System/Library/Frameworks/JavaScriptCore.framework/Versions/A/Resources/jsc"

		setopt complete_aliases # aliased ls needs if file/dir completions work
		bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

		# javaのコンパイル時に文字化けするのを防ぐ
		alias java='java -Dfile.encoding=UTF-8'
		alias javac='javac -J-Dfile.encoding=UTF-8'

		# rmコマンドでゴミ箱に送る
		alias rm='trash'
    # alias rm='mv -i ~/.Trash' # 他のOS用

		# Dropbox以下の容量を調べるときに使うコマンド
		# sudo du -hxd 1 ~/Dropbox/    
		alias duDropbox="du -hxd 1 ~/Dropbox/"
		alias duHome="du -gxd 1 ~/ | awk '$1 > 1{print}'"

		# grep結果に色を点ける
		alias grep="grep -a --color"

		# Python実行時に.pycファイルを作成しないようにする
		# alias python="python -B"

		# 画面クリア時にlsを行う
		alias clear=clear

		alias ls="ls -GFS"
		alias la="ls -aA"
		alias ll="ls -l"
		alias lal="ls -a -lA"

		alias memo="vim ~/Dropbox/Backup/memo.txt"
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

		#alias rand="echo "hoge1"$'\n'"hoge2"$'\n'"hoge3" | php -R 'echo rand(0, PHP_INT_MAX)." ".$argn.PHP_EOL;' | sort | head -n 1"
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
    # shiftで引数をずらす
		function runc () { gcc $1 && shift && ./a.out $@; rm a.out }
		function runcpp () { g++ $1 && shift && ./a.out $@; rm a.out }
		function runcpp2 () { g++ $1 && shift && ./a.out $@}
		function runocaml () { ocaml $1 }
		function runHaskell () { ghc -o a.out $1 && shift && ./a.out $@}

		alias -s c=runc
		alias -s cpp=runcpp
		alias -s ml=runocaml
		alias -s hs=runHaskell

		# .appの起動
		if [[ ! -e ~/.zsh/app ]]; then
			for i in /Applications/*.app; do
			file=$(basename "$i" .app)
			name=$(echo $file | tr '[ A-Z]' '[_a-z]')
			echo alias $name="\"open -a '$file'\"" >> ~/.zsh/app
			done
		fi
		source ~/.zsh/app
	}
	myAliasSettings

#------------------- functions -------------------
	function findText() {
		find ./ -type f -print | xargs grep $1
	}

	function makeGifFromMov() {
		ffmpeg -i $1 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=3 --delay=3 > out.gif
	}
	# vimにctrl-zで戻る
	fancy-ctrl-z () {
		if [[ $#BUFFER -eq 0 ]]; then
			BUFFER="fg"
			zle accept-line
		else
			zle push-input
			zle clear-screen
		fi
	}
	zle -N fancy-ctrl-z
	bindkey '^Z' fancy-ctrl-z

	function d(){
		open dict://$1
	}

	# 一定時間以上かかる処理の場合は終了時に通知してくれる
	# http://kazuph.hateblo.jp/entry/2013/10/23/005718
	# 下のほうが楽かも
	# http://qiita.com/takc923/items/75d67a08edfbaa5fd304
	local COMMAND="0"
	local COMMAND_TIME="0"

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

	function history-all { history -E 1 }

	function peco-select-history() {
		local tac
		if which tac > /dev/null; then
			tac="tac"
		else
			tac="tail -r"
		fi
		BUFFER=$(\history -n 1 | \
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

#-------------------- その他 --------------------
	function myOtherSettings {

    setopt notify # バックグラウンドジョブの状態変化を即時報告する

    setopt no_beep # ビープ音を鳴らさないようにする
		setopt nolistbeep # ビープ音を鳴らないようにする

		# ディレクトリ名だけでcdする
		setopt auto_cd

		# バックグラウンドジョブが終了したらすぐに知らせる。
		#setopt no_tify

		# 自動修正機能 ex.lls →  ls?
		setopt correct

		# 日本語ファイル名を表示可能にする
		setopt print_eight_bit
		 
		# フローコントロールを無効にする
		setopt no_flow_control
		 
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
		setopt auto_param_slash      

		# 他の設定ファイルを読み込む
		[ -f ~/.zshrc.mine ] && source ~/.zshrc.private

		## 言語環境を日本語、UTF-8 にそろえておく
		export LANG=ja_JP.UTF-8
		export LESSCHARSET=utf-8 
	}
	myOtherSettings


#-------------------- tmux --------------------
	function tmuxSettings {
		# 既にtmuxを起動してないか
    if [[ ! -n $TMUX ]]; then
      # get the IDs
      ID="`tmux list-sessions`"
      if [[ -z "$ID" ]]; then
        tmux new-session && exit
      fi
      create_new_session="Create New Session"
      ID="$ID\n${create_new_session}:"
      ID="`echo $ID | peco | cut -d: -f1`"
      if [[ "$ID" = "${create_new_session}" ]]; then
        tmux new-session && exit
      elif [[ -n "$ID" ]]; then
        tmux attach-session -t "$ID" && exit
      else
        echo 'Start terminal without tmux'
      fi
    fi
	}
	tmuxSettings


#-------------------- pyenv --------------------
	if which pyenv > /dev/null; then 
		eval "$(pyenv init -)"; 
	fi

# ---------------- Cocos2d-x 3.2 ---------------- #
	function myCocos2d-xSettings {
		# Add environment variable COCOS_CONSOLE_ROOT for cocos2d-x
		export COCOS_CONSOLE_ROOT=/Users/ucucAir2/Downloads/cocos2d-x/cocos2d-x-3.2/tools/cocos2d-console/bin
		export PATH=$COCOS_CONSOLE_ROOT:$PATH

		# Add environment variable ANT_ROOT for cocos2d-x
		export ANT_ROOT=/usr/local/Cellar/ant/1.9.4/libexec/bin
		export PATH=$ANT_ROOT:$PATH

		# Add environment variable NDK_ROOT for cocos2d-x
		export NDK_ROOT=/Users/ucucAir2/Downloads/cocos2d-x/android/ndk/
		export PATH=$NDK_ROOT:$PATH

		# Add environment variable ANDROID_SDK_ROOT for cocos2d-x
		export ANDROID_SDK_ROOT=/Users/ucucAir2/Downloads/cocos2d-x/android/sdk/
		export PATH=$ANDROID_SDK_ROOT:$PATH
		export PATH=$ANDROID_SDK_ROOT/tools:$ANDROID_SDK_ROOT/platform-tools:$PATH

		alias androidEmulator='emulator -avd cocos'
		alias cocosAndroid='cocos run -p android --ap 19'
	}
	myCocos2d-xSettings
