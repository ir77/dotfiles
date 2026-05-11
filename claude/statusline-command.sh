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

# --- dir + sandbox (needed before model) ---
dir=$(echo "$input" | jq -r '.workspace.current_dir')
sandbox_global=$(jq -r '.sandbox.enabled // false' ~/.claude/settings.json 2>/dev/null)
proj_settings="$dir/.claude/settings.json"
if [ -f "$proj_settings" ]; then
  sandbox_proj=$(jq -r 'if .sandbox.enabled == null then empty else (.sandbox.enabled | tostring) end' "$proj_settings" 2>/dev/null)
  is_sandboxed="${sandbox_proj:-$sandbox_global}"
else
  is_sandboxed="$sandbox_global"
fi
[ "$is_sandboxed" = "true" ] && sandbox_icon="📦 " || sandbox_icon=""

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // "unknown"' \
  | sed 's/^[Cc]laude[- ]//' \
  | sed 's/\([a-z]\)-\([0-9]\)/\1\2/' \
  | sed 's/\([0-9]\)-\([0-9]\)/\1.\2/' \
  | sed 's/ \([0-9]\)/\1/g' \
  | awk '{print toupper(substr($0,1,1)) substr($0,2)}' \
  | sed 's/ context)/)/g' \
  | sed 's/ (/(/g')
effort=$(echo "$input" | jq -r '.effort.level // empty' | sed 's/xhigh/xh/;s/low/l/;s/medium/m/;s/high/h/')
[ -n "$effort" ] && model_label="${model}(${effort})" || model_label="${model}"
model_str="${sandbox_icon}${BOLD}${CYAN}${model_label}${RESET}"

# --- git ---
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  staged=$(git -C "$dir" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git -C "$dir" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  unpushed=$(git -C "$dir" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
  git_str="${BOLD}${YELLOW}${branch}${RESET}"
  if [ "$staged" -gt 0 ] || [ "$unstaged" -gt 0 ]; then
    git_str="${git_str} ${RED}~${unstaged}${RESET}${DIM}/${RESET}${GREEN}+${staged}${RESET}"
  fi
  [ "$unpushed" -gt 0 ] 2>/dev/null && git_str="${git_str}${DIM}/${RESET}${MAGENTA}↑${RESET}"
else
  git_str=""
fi

# --- project ---
proj_name=$(basename "$dir")
proj_str="${BOLD}${BLUE}${proj_name}${RESET}"

# --- rate limits ---
color_pct() {
  local p=$1
  if   [ "$p" -lt 50 ]; then printf '%b' "${GREEN}${p}%${RESET}"
  elif [ "$p" -lt 80 ]; then printf '%b' "${YELLOW}${p}%${RESET}"
  else printf '%b' "${RED}${p}%${RESET}"; fi
}

# 7d rate limit coloring: red if ahead of even daily pace (uses actual resets_at)
color_pct_7d() {
  local p=$1
  local threshold=$(( days_elapsed * 100 / 7 ))
  if   [ "$p" -gt 80 ] || [ "$p" -gt "$threshold" ]; then printf '%b' "${RED}${p}%${RESET}"
  elif [ "$p" -gt $(( threshold * 4 / 5 )) ]; then printf '%b' "${YELLOW}${p}%${RESET}"
  else printf '%b' "${GREEN}${p}%${RESET}"; fi
}

five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

# Calculate days elapsed (1–7) in the current 7-day window from resets_at (Unix epoch)
days_elapsed=4  # fallback: neutral midpoint
reset_epoch=""
if [ -n "$seven_d_resets" ]; then
  reset_epoch="$seven_d_resets"
  now_epoch=$(date +%s)
  elapsed_secs=$(( now_epoch - (reset_epoch - 7 * 86400) ))
  days_elapsed=$(( elapsed_secs / 86400 + 1 ))
  [ "$days_elapsed" -lt 1 ] && days_elapsed=1
  [ "$days_elapsed" -gt 7 ] && days_elapsed=7
fi
rate_section=""
if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
  rate_parts=""
  if [ -n "$five_h" ]; then
    fh_pct=$(printf '%.0f' "$five_h")
    rate_parts="${DIM}5h:${RESET}$(color_pct "$fh_pct")"
  fi
  if [ -n "$seven_d" ]; then
    sd_pct=$(printf '%.0f' "$seven_d")
    [ -n "$reset_epoch" ] && sd_label="${DIM}${days_elapsed}/7d:${RESET}" || sd_label="${DIM}7d:${RESET}"
    sd_part="${sd_label}$(color_pct_7d "$sd_pct")"
    [ -n "$rate_parts" ] && rate_parts="${rate_parts} ${sd_part}" || rate_parts="$sd_part"
  fi
  rate_section="${SEP}${rate_parts}"
fi


# --- context window ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  filled=$(( pct * 9 / 100 ))
  [ "$filled" -gt 9 ] && filled=9
  empty_count=$(( 9 - filled ))
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
cost_val=$(echo "$total_in $total_out" | awk '{printf "%.2f", ($1 * 3 / 1000000) + ($2 * 15 / 1000000)}')
cost_str="${DIM}cost${RESET} ${BOLD}\$${cost_val}${RESET}"

# --- assemble ---
if [ -n "$git_str" ]; then
  printf '%b\n' "${proj_str}${SEP}${model_str}${SEP}${git_str}${SEP}${bar_str}${rate_section}${SEP}${cost_str}"
else
  printf '%b\n' "${proj_str}${SEP}${model_str}${SEP}${bar_str}${rate_section}${SEP}${cost_str}"
fi
