# zmodload zsh/zprof

# -------------------- 全体 --------------------{{{
eval "$(/opt/homebrew/bin/brew shellenv)"

setopt notify # バックグラウンドジョブの状態変化を即時報告する
setopt no_beep # ビープ音を鳴らさないようにする
setopt print_eight_bit # 日本語ファイル名を表示可能にする
setopt no_flow_control # フローコントロールを無効にする
setopt globdots # 明確なドットの指定なしで.から始まるファイルをマッチ
setopt COMBINING_CHARS # 濁点・半濁点の入ったファイルの表示
setopt auto_param_slash # ディレクトリ名の補完で末尾の / を自動的に付加し、次の補完に備える
#}}}

# -------------------- zinitの導入 --------------------{{{
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d $ZINIT_HOME ]]; then
  mkdir -p "$(dirname $ZINIT_HOME)"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "${ZINIT_HOME}/zinit.zsh"

zinit ice lucid wait
zinit light olets/zsh-abbr

zinit ice blockf
zinit light zsh-users/zsh-completions

# シンタックスハイライト (プラグインの最後に読み込むのが原則)
zinit light zsh-users/zsh-syntax-highlighting
#}}}

#--------------------- 補完 -------------------{{{
autoload -Uz compinit
compinit -u

zinit cdreplay -q # 補完設定を再適用

zstyle ':completion:*' menu select # 補完候補を矢印キーで選べるようにする
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # 補完候補に色を付ける
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # 補完時に大文字小文字を無視する
zstyle ':completion:*' verbose yes # 補完候補の説明を表示する
zstyle ':completion:*' group-name '' # 補完候補をグループ化する
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f' # グループの見出しを黄色で表示
zstyle ':completion:*:options' description 'yes' # オプションの説明を表示
zstyle ':completion:*' list-separator '-->' # 候補と説明の間の区切り
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s' # 選択中のステータス表示

setopt complete_aliases # aliased ls needs if file/dir completions work
zmodload zsh/complist
bindkey "^[[Z" reverse-menu-complete  # Shift-Tabで補完候補を逆順する("\e[Z"でも動作する)
#}}}

# -------------------- export/source --------------------{{{
# 言語環境を日本語、UTF-8 にそろえておく
export LANG=ja_JP.UTF-8
export LESSCHARSET=utf-8

export XDG_CONFIG_HOME=~/.config
export FZF_DEFAULT_OPTS='--layout=reverse --border --exit-0 --height 80%'
export PATH="$HOME/.local/bin:$PATH"

export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export LDFLAGS="-L/opt/homebrew/opt/ruby/lib"
export CPPFLAGS="-I/opt/homebrew/opt/ruby/include"

eval "$(starship init zsh)"

# Vite+ bin (https://viteplus.dev)
. "$HOME/.vite-plus/env"

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
  # historyを新しい順(tail -r)にしてから重複排除(awk)することで、最新の実行履歴を優先して残す
  local result=$(
    history -n 1 |
    tail -r |
    awk '!seen[$0]++' |
    grep -v '^cd' |
    fzf --query "$LBUFFER" --tiebreak=index
  )  
  BUFFER="$result"
  zle clear-screen
}
zle -N fzf_history
bindkey '^r' fzf_history

function git-duet-interactive() {
  local authors_file="$(git rev-parse --show-toplevel 2>/dev/null)/.git-authors"
  [[ -f "$authors_file" ]] || { echo "エラー: .git-authors が見つかりません" >&2; return 1; }

  # 全著者エントリ: "initials  name" (元の順序)
  local all_entries
  all_entries=$(awk '/^authors:/{p=1;next}/^[^ ]/{p=0}p' "$authors_file" \
    | awk '{gsub(/:/,"",$1); printf "%-6s %s\n",$1,substr($0,index($0,$2))}')

  # 直近3ヶ月のactiveなinitials (commit数の多い順)
  local recent_inits
  recent_inits=$(
    git log --since="2 months ago" --format="%ae" 2>/dev/null \
    | sort | uniq -c | sort -rn | awk '{print $2}' \
    | awk 'NR==FNR{map[$1]=$2; next} $0 in map{print map[$0]}' \
        <(awk '/^email_addresses:/{p=1;next}/^[^ ]/{p=0}p' "$authors_file" \
          | awk '{gsub(/:/,"",$1); print $2,$1}') -
  )

  # recent優先、残りは元順序で出力。境界にセパレータを挿入
  local all_inits_ordered
  all_inits_ordered=$(
    { echo "$recent_inits"; awk '{print $1}' <<< "$all_entries" } \
    | awk 'seen[$0]++ == 0'
  )

  local entries
  entries=$(
    sep=""
    while IFS= read -r init; do
      if [[ -z "$sep" ]] && ! grep -qx "$init" <<< "$recent_inits" 2>/dev/null; then
        [[ -n "$recent_inits" ]] && echo "  ─────────────────────────────────"
        sep=1
      fi
      grep "^$init " <<< "$all_entries"
    done <<< "$all_inits_ordered"
  )

  local selected
  selected=$(echo "$entries" | fzf --multi --prompt="git duet> " \
    --header="TABで複数選択、ENTERで確定" \
    | grep -v "^  ─" \
    | awk '{print $1}')

  [[ -z "$selected" ]] && return 0

  local initials=("${(@f)selected}")
  git duet "${initials[@]}"
}

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

# if [[ -o interactive ]]; then
#   zprof | head -n 10
# fi

# Added by Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"

