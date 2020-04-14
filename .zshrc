#-------------------- 全体 --------------------
function myEnvironmentSettings {
  setopt notify # バックグラウンドジョブの状態変化を即時報告する

  setopt no_beep # ビープ音を鳴らさないようにする
  setopt nolistbeep # ビープ音を鳴らないようにする

  # 自動修正機能 ex.lls →  ls?
  setopt correct

  # 日本語ファイル名を表示可能にする
  setopt print_eight_bit

  # フローコントロールを無効にする
  setopt no_flow_control

  # 明確なドットの指定なしで.から始まるファイルをマッチ
   setopt globdots

  # 濁点・半濁点の入ったファイルの表示
  setopt COMBINING_CHARS

  # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
  setopt auto_param_slash

  ## 言語環境を日本語、UTF-8 にそろえておく
  export LANG=ja_JP.UTF-8
  export LESSCHARSET=utf-8

  export GOPATH=${HOME}/go
  export PATH="$PATH:/Users/ucucmacmini/flutter/bin"

  export XDG_CONFIG_HOME=~/.config
}
myEnvironmentSettings

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
  alias g='cd $(ghq root)/$(ghq list | peco)' # ローカルリポジトリへの移動
  alias gh='hub browse $(ghq list | peco | cut -d "/" -f 2,3)' # リモートリポジトリへの移動

  alias history="history -Di 1" # 実行時間とかかった時間を表示

  alias cp="cp -i" # 保険で警告
  alias mv="mv -i" # 保険で警告

  alias lgtm='sh ~/Dropbox/code/shellscript/lgtm.sh/lgtm.sh -m | pbcopy'
  alias playground='open ~/Dropbox/code/XcodePlayground/MyPlayground.playground'

  alias sl="/Users/ucucAir2/Dropbox/code/script/sl/sl"

  setopt complete_aliases # aliased ls needs if file/dir completions work
  bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

  # rmコマンドでゴミ箱に送る
  alias rm='trash'
  # alias rm='mv -i ~/.Trash' # 他のOS用

  # grep結果に色を点ける
  alias grep="grep -a --color"

  # 画面クリア時にlsを行う
  alias clear=clear

  alias ls="ls -GFS"
  alias la="ls -aA"
  alias ll="ls -l"
  alias lal="ls -a -lA"

  alias vimrc="vim ~/.vimrc"
  alias zshrc="vim ~/.zshrc"

  # 打ったコマンドの後ろ(suffix)を見て, 適当に宜しくやってくれるやつ
  # ./でpythonを開く
  alias -s py=python
  alias -s rb='ruby'

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

  # Haskell
  alias ghci='stack ghci'
  alias ghc='stack ghc --'
  alias runghc='stack runghc --'
}
myAliasSettings

#------------------- その他 -------------------
function myOtherSettings {
  cd `cat ~/.curdir` # 端末を新規に開くと自動的に前回の pwd に移動して始める

  # 一定時間以上かかる処理の場合は終了時に通知してくれる
  # http://kazuph.hateblo.jp/entry/2013/10/23/005718
  # 下のほうが楽かも
  # http://qiita.com/takc923/items/75d67a08edfbaa5fd304
  local COMMAND="0"
  local COMMAND_TIME="0"

  # zsh-completions
  fpath=(/usr/local/share/zsh-completions $fpath)
  autoload -U compinit
  compinit -u

  # zsh-syntax-highlighting
  source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # 補完時に大文字小文字を無視する
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
}
myOtherSettings

#------------------- peco -------------------
  function peco-ack-search() {
    ack "$@" . | peco --exec 'awk -F : '"'"'{print "+" $2 " " $1}'"'"' | xargs less '
  }
  zle -N peco-ack-search
  bindkey '^j' peco-ack-search

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

#------------------- functions -------------------
function processFileWithCommand() { # args: filename command
  cat $1 | while read line
  do
    $2 $line
  done
}

function makeGifFromMov() {
  ffmpeg -i $1 -pix_fmt rgb24 -r 10 -f gif - | gifsicle --optimize=5 --delay=5 > out.gif
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

eval "$(starship init zsh)"
