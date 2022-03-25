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
}
myEnvironmentSettings

# --------------------export--------------------
  eval "$(/opt/homebrew/bin/brew shellenv)"

  # 言語環境を日本語、UTF-8 にそろえておく
  export LANG=ja_JP.UTF-8
  export LESSCHARSET=utf-8

  export GOPATH=${HOME}/go
  export PATH="$PATH:/Users/ucucmacmini/flutter/bin"
  export XDG_CONFIG_HOME=~/.config
  export PATH=$HOME/.nodebrew/current/bin:$PATH
  export PATH="/usr/local/opt/openjdk@11/bin:$PATH"
  export CPPFLAGS="-I/usr/local/opt/openjdk@11/include"
  export FZF_DEFAULT_OPTS='--layout=reverse --border --exit-0 --height 80%'

  # Github Personal access tokens管理用
  # echo "export GITHUB_ACCESS_TOKEN=xxx" > ~/.zshrc_private
  source ~/.zshrc_private

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

#------------------- その他 -------------------
function myOtherSettings {
  # 一定時間以上かかる処理の場合は終了時に通知してくれる
  # http://kazuph.hateblo.jp/entry/2013/10/23/005718
  local COMMAND="0"
  local COMMAND_TIME="0"

  # zsh-completions
  fpath=(/usr/local/share/zsh-completions $fpath)
  autoload -U compinit
  compinit -u

  # zsh-syntax-highlighting
  # M1 Macに移行したら消す
  # source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # 補完時に大文字小文字を無視する
  zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
}
myOtherSettings

# --------------------エイリアス------------------
function myAliasSettings {
  alias history="history -Di 1" # 実行時間とかかった時間を表示

  alias cp="cp -i" # 保険で警告
  alias mv="mv -i" # 保険で警告

  setopt complete_aliases # aliased ls needs if file/dir completions work
  bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)

  # rmコマンドでゴミ箱に送る
  alias rm='trash'

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
  function runRustc () { rustc -o a.out $1 && ./a.out && rm a.out }

  alias -s c=runc
  alias -s cpp=runcpp
  alias -s ml=runocaml
  alias -s hs=runHaskell
  alias -s rs=runRustc

  # Haskell
  alias ghci='stack ghci'
  alias ghc='stack ghc --'
  alias runghc='stack runghc --'

  function gitCommit() {
    authors=`git config --list | grep duet.env.git | grep initials | wc -l`
    if [ ${authors} -eq 0 ] ; then
      git commit -v
    else 
      git duet-commit
    fi
  }

  # git
  alias g="git"
  alias gb='git branch'
  alias gba='git branch -a'
  alias gc='gitCommit'
  alias gca='git commit -v -a'
  alias gcam='git commit -v -a -m'
  alias gcm='git commit -v -m'
  alias gdca='git duet-commit --amend'
  alias gco='git checkout'
  alias gcp='git cherry-pick'
  alias gd='git diff'
  alias gds='git diff --staged'
  alias gl='git log'
  alias glo='git log --oneline -10'
  alias gp='git push'
  alias gs='git status'

  alias idea="open -na 'IntelliJ IDEA.app' --args"
}
myAliasSettings

#------------------- fzf -------------------
  function fzf-ack-search() {
    ack "$@" . | fzf --preview $'echo {} | awk -F ":" \'{print "+" $2 " " $1}\' | xargs less'
    zle accept-line # 次のpromptを表示する
  }
  zle -N fzf-ack-search
  bindkey '^j' fzf-ack-search

  function fzf_any_search() {
    local fdpath='fd . ~ --full-path --type d --exclude debug --exclude Library | sed -e "s/^/cd /"'
    local history='\history -n 1 | uniq | tail -r'
    local result=$({ eval "$fdpath" ; eval "$history" ; } | fzf --query "$LBUFFER")
    if [[ "$result" =~ ^cd ]]; then
      eval "$result"
      zle accept-line # 次のpromptを表示する
    else
      BUFFER="$result"
    fi
  }
  zle -N fzf_any_search
  bindkey '^s' fzf_any_search

#------------------- functions -------------------
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

eval $(thefuck --alias)
eval "$(anyenv init -)"
eval "$(starship init zsh)"
