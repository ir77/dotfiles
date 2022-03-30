
#-------------------- 全体 --------------------
function myEnvironmentSettings {
  # Fig pre block. Keep at the top of this file.
  export PATH="${PATH}:${HOME}/.local/bin"
  eval "$(fig init zsh pre)"

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
}; myEnvironmentSettings

# --------------------export/source--------------------
function myExportSettings {
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

  source /opt/homebrew/share/zsh-abbr/zsh-abbr.zsh
  # zsh-syntax-highlighting
  # M1 Macに移行したら消す
  # source /usr/local/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 
  source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

  # Github Personal access tokens管理用
  # echo "export GITHUB_ACCESS_TOKEN=xxx" > ~/.zshrc_private
  source ~/.zshrc_private
}; myExportSettings

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

  # コマンドを打った状態で上下キーを押すと履歴から補完する
  autoload history-search-end
  zle -N history-beginning-search-backward-end history-search-end
  zle -N history-beginning-search-forward-end history-search-end
  bindkey "^P" history-beginning-search-backward-end
  bindkey "^N" history-beginning-search-forward-end
}; myHistorySettings

#------------------- 補完  -------------------
function myCompletionSettings {
  # figお試し中
  ## zsh-completions
  #fpath=(/usr/local/share/zsh-completions $fpath)
  #autoload -U compinit
  #compinit -u

  ## 補完時に大文字小文字を無視する
  #zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

  #setopt complete_aliases # aliased ls needs if file/dir completions work
  #bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
}; myCompletionSettings

# --------------------エイリアス------------------
function myAliasSettings {
  # rmコマンドでゴミ箱に送る
  alias rm='trash'

  # grep結果に色を点ける
  alias grep="grep -a --color"

  alias vimrc="vim ~/.vimrc"
  alias zshrc="vim ~/.zshrc"

  alias idea="open -na 'IntelliJ IDEA.app' --args"
}; myAliasSettings

#------------------- fzf -------------------
  function fzf-ack-search() {
    ack "$@" . --ignore-dir=debug | fzf --preview $'echo {} | awk -F ":" \'{print $1 " -r " $2 ":" " -H " $2}\' | xargs bat --color=always' | awk -F ":" '{print $1 " -H " $2}' | xargs bat --color=always
    zle accept-line
  }
  zle -N fzf-ack-search
  bindkey '^h' fzf-ack-search

  function fzf_any_search() {
    local fdpath='fd . ~ --full-path --type d --exclude debug --exclude Library | sed -e "s/^/cd /"'
    local history='\history -n 1 | sort | uniq | grep -v "cd" | tail -r'
    local result=$({ eval "$fdpath" ; eval "$history" ; } | fzf --query "$LBUFFER")
    if [[ "$result" =~ ^cd ]]; then
      eval "$result"
      zle accept-line
    else
      BUFFER="$result"
      zle clear-screen
    fi
  }
  zle -N fzf_any_search
  bindkey '^s' fzf_any_search

eval "$(thefuck --alias)"
eval "$(anyenv init -)"
eval "$(starship init zsh)"
# Fig post block. Keep at the bottom of this file.
eval "$(fig init zsh post)"

