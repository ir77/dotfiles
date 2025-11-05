# Amazon Q pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.pre.zsh"
# -------------------- 全体 --------------------{{{
zmodload zsh/zprof
setopt notify # バックグラウンドジョブの状態変化を即時報告する
setopt no_beep # ビープ音を鳴らさないようにする
setopt nolistbeep # ビープ音を鳴らないようにする
setopt correct # 自動修正機能 ex.lls →  ls?
setopt print_eight_bit # 日本語ファイル名を表示可能にする
setopt no_flow_control # フローコントロールを無効にする
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt COMBINING_CHARS # 濁点・半濁点の入ったファイルの表示
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
#}}}

#--------------------- 補完 -------------------{{{
autoload -U compinit
zstyle ':completion:*' use-cache on
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:warnings' format '%B%F{yellow}補完キャッシュを再生成してください%b%f'
zstyle ':completion:*' cache-path ~/.zcompcache
compinit -C

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を無視する

setopt complete_aliases # aliased ls needs if file/dir completions work
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
#}}}

# -------------------- zinitの導入 --------------------{{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice wait lucid
zinit light olets/zsh-abbr
zinit light zsh-users/zsh-syntax-highlighting
# zinit light zsh-users/zsh-completions # Amazon Q 導入したのでoff
#}}}

# -------------------- export/source --------------------{{{
eval "$(/opt/homebrew/bin/brew shellenv)"

# 言語環境を日本語、UTF-8 にそろえておく
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

export XDG_CONFIG_HOME=~/.config
export FZF_DEFAULT_OPTS='--layout=reverse --border --exit-0 --height 80%'

export NVM_DIR="$HOME/.nvm"

# Lazy-load nvm to avoid startup cost
_nvm_lazy_load() {
  unset -f nvm node npm npx yarn pnpm >/dev/null 2>&1
  local nvm_sh="/opt/homebrew/opt/nvm/nvm.sh"
  local nvm_completion="/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"
  [[ -s "$nvm_sh" ]] && source "$nvm_sh"
  [[ -s "$nvm_completion" ]] && source "$nvm_completion"
  if [[ -s "$NVM_DIR/alias/default" ]]; then
    nvm use default >/dev/null
  fi
}

nvm() {
  _nvm_lazy_load
  nvm "$@"
}

node() {
  _nvm_lazy_load
  command node "$@"
}

npm() {
  _nvm_lazy_load
  command npm "$@"
}

npx() {
  _nvm_lazy_load
  command npx "$@"
}

yarn() {
  _nvm_lazy_load
  command yarn "$@"
}

pnpm() {
  _nvm_lazy_load
  command pnpm "$@"
}

eval "$(thefuck --alias)"
eval "$(starship init zsh)"

# Github Personal access tokens管理用
# echo "export GITHUB_ACCESS_TOKEN=xxx" > ~/.zshrc_private
source ~/.zshrc_private
#}}}

# -------------------- ヒストリー --------------------{{{
HISTFILE=~/.zsh_history
HISTSIZE=1000000
SAVEHIST=1000000

# 重複したコマンドを無視する
setopt hist_ignore_all_dups

# 重複したディレクトリを追加しない
setopt pushd_ignore_dups

# 同時に起動したzshの間でヒストリを共有する
setopt share_history

# コマンドを打った状態で上下キーを押すと履歴から補完する
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
#}}}

# -------------------- エイリアス ------------------{{{
alias rm='trash' # rmコマンドでゴミ箱に送る
alias grep="grep -a --color" # grep結果に色を点ける
alias idea="open -na 'IntelliJ IDEA.app' --args"
#}}}

#--------------------- function -------------------{{{
function git() {
  # 最初の引数が "commit" かつ、`.git-authors` コマンドが存在する場合
  if [[ "$1" == "commit" ]] && command -v .git-authors &>/dev/null; then
    # `git duet-commit` を実行する
    command git duet-commit "${@:2}"
  else
    # それ以外の全てのgitコマンドは、そのまま実行する
    command git "$@"
  fi
}

function gemini-prompt() {
  gemini --model="gemini-2.5-flash" --prompt "$1"
}

function gemini-prompt-websearch() {
  gemini --model="gemini-2.5-flash" --prompt "WebSearch: $1"
}

function fzf-ack-search() {
  # 1. ack を使ってコード検索を実行。
  # 2. fzf を用いてインタラクティブに検索結果を選択。
  # 3. 選択した結果を bat を使ってシンタックスハイライト付きで表示。
  ack "$@" . --ignore-dir=debug |\
    fzf --preview $'echo {} | awk -F ":" \'{print $1 " -r " $2 ":" " -H " $2}\' | xargs bat --color=always' |\
    awk -F ":" '{print $1 " -H " $2}' |\
    xargs bat --color=always
  zle accept-line
}
zle -N fzf-ack-search
bindkey '^w' fzf-ack-search

function fzf_cd() {
  local fdpath='fd . ~ --full-path --type d --exclude debug --exclude Library | sed -e "s/^/cd /"'
  local result=$({ eval "$fdpath"; } | fzf --query "$LBUFFER")
  eval "$result"
  zle accept-line
}
zle -N fzf_cd
bindkey '^s' fzf_cd

function fzf_history() {
  local result=$(
    history -n 1 |
    awk '!seen[$0]++' |
    grep -v '^cd' |
    tail -r |
    fzf --query "$LBUFFER" --tiebreak=index
  )  
  BUFFER="$result"
  zle clear-screen
}
zle -N fzf_history
bindkey '^r' fzf_history

killport() {
  local pids=$(lsof -t -i :$1 2>/dev/null)

  if [[ -z "$pids" ]]; then
    echo "エラー: ポート $1 を使用中のプロセスは見つかりません。" >&2
    return 1
  fi

  echo "--- プロセス情報 ---"
  lsof -P -i :$1 2>/dev/null
  echo "----------------------"

  echo "ポート $1 (PID: $pids) のプロセスを終了します。"
  kill $pids
}
#}}}

# Amazon Q post block. Keep at the bottom of this file.
if [[ -o interactive ]]; then
  zprof | head -n 10
fi
[[ -f "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/amazon-q/shell/zshrc.post.zsh"
