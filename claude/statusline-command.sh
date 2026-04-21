#!/usr/bin/env bash
input=$(cat)

# --- color codes ---
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
CYAN='\033[36m'
YELLOW='\033[33m'
GREEN='\033[32m'
RED='\033[31m'
BLUE='\033[34m'
MAGENTA='\033[35m'
SEP="${DIM} │ ${RESET}"

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
model_str="${BOLD}${CYAN}${model}${RESET}"

# --- git ---
dir=$(echo "$input" | jq -r '.workspace.current_dir')
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  staged=$(git -C "$dir" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git -C "$dir" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  unpushed=$(git -C "$dir" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
  git_str="${BOLD}${YELLOW}${branch}${RESET} ${RED}~${unstaged}${RESET}${DIM}/${RESET}${GREEN}+${staged}${RESET}"
  [ "$unpushed" -gt 0 ] 2>/dev/null && git_str="${git_str}${DIM}/${RESET}${MAGENTA}↑${RESET}"
else
  git_str=""
fi

# --- rate limits ---
color_pct() {
  local p=$1
  if   [ "$p" -lt 50 ]; then printf '%b' "${GREEN}${p}%${RESET}"
  elif [ "$p" -lt 80 ]; then printf '%b' "${YELLOW}${p}%${RESET}"
  else printf '%b' "${RED}${p}%${RESET}"; fi
}

# 7d rate limit coloring: red if over weekday pace (Mon=20%, Tue=40%, ..., Fri+=100%)
color_pct_7d() {
  local p=$1
  local dow threshold
  dow=$(date +%u)  # 1=Mon, 2=Tue, ..., 5=Fri, 6=Sat, 7=Sun
  case "$dow" in
    1) threshold=20 ;;
    2) threshold=40 ;;
    3) threshold=60 ;;
    4) threshold=80 ;;
    *) threshold=100 ;;
  esac
  if   [ "$p" -gt 80 ] || [ "$p" -gt "$threshold" ]; then printf '%b' "${RED}${p}%${RESET}"
  elif [ "$p" -gt $(( threshold * 4 / 5 )) ]; then printf '%b' "${YELLOW}${p}%${RESET}"
  else printf '%b' "${GREEN}${p}%${RESET}"; fi
}

five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
  fh_pct=${five_h:+$(printf '%.0f' "$five_h")}
  sd_pct=${seven_d:+$(printf '%.0f' "$seven_d")}
  fh_col=$([ -n "$fh_pct" ] && color_pct "$fh_pct" || printf "${DIM}-${RESET}")
  sd_col=$([ -n "$sd_pct" ] && color_pct_7d "$sd_pct" || printf "${DIM}-${RESET}")
  rate_str="${DIM}5h:${RESET}${fh_col}${DIM}/${RESET}${DIM}7d:${RESET}${sd_col}"
  rate_section="${SEP}${rate_str}"
else
  rate_section=""
fi


# --- context window ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  filled=$(( pct * 15 / 100 ))
  [ "$filled" -gt 15 ] && filled=15
  empty_count=$(( 15 - filled ))
  bar=""
  i=0; while [ "$i" -lt "$filled" ];  do bar="${bar}█";   i=$(( i + 1 )); done
  i=0; while [ "$i" -lt "$empty_count" ]; do bar="${bar}░"; i=$(( i + 1 )); done
  if   [ "$pct" -lt 50 ]; then bar_color="${GREEN}"
  elif [ "$pct" -lt 80 ]; then bar_color="${YELLOW}"
  else bar_color="${RED}"; fi
  bar_str="${DIM}ctx${RESET} ${bar_color}[${bar}]${RESET} ${BOLD}${pct}%${RESET}"
else
  bar_str="${DIM}ctx [no data]${RESET}"
fi

# --- cost ---
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // 0')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // 0')
cost_val=$(echo "$total_in $total_out" | awk '{printf "%.4f", ($1 * 3 / 1000000) + ($2 * 15 / 1000000)}')
cost_str="${DIM}cost${RESET} ${BOLD}\$${cost_val}${RESET}"

# --- assemble ---
if [ -n "$git_str" ]; then
  printf '%b\n' "${model_str}${SEP}${git_str}${rate_section}${SEP}${bar_str}${SEP}${cost_str}"
else
  printf '%b\n' "${model_str}${rate_section}${SEP}${bar_str}${SEP}${cost_str}"
fi
