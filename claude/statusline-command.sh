#!/usr/bin/env bash
input=$(cat)

# ANSI helpers
RESET='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
BOLD_OFF='\033[22m'

# Starship-inspired palette (bold bright ANSI colors)
C_DIR='\033[1;94m'     # bold bright blue    — directory (starship directory)
C_BRANCH='\033[1;95m'  # bold bright purple  — git branch (starship git_branch)
C_MODEL='\033[1;96m'   # bold bright cyan    — model
C_SEP='\033[32m'       # green               — ❯ separator
C_GREEN='\033[92m'     # bright green
C_YELLOW='\033[93m'    # bright yellow
C_RED='\033[91m'       # bright red
C_MAGENTA='\033[95m'   # bright magenta

SEP=" ${C_SEP}❯${RESET} "

# U+E0A0 Nerd Font git branch icon
GIT_ICON=$(printf '\xee\x82\xa0')

# --- sandbox ---
dir=$(echo "$input" | jq -r '.workspace.current_dir')
sandbox_global=$(jq -r '.sandbox.enabled // false' ~/.claude/settings.json 2>/dev/null)
proj_settings="$dir/.claude/settings.json"
if [ -f "$proj_settings" ]; then
  sandbox_proj=$(jq -r 'if .sandbox.enabled == null then empty else (.sandbox.enabled | tostring) end' "$proj_settings" 2>/dev/null)
  is_sandboxed="${sandbox_proj:-$sandbox_global}"
else
  is_sandboxed="$sandbox_global"
fi
[ "$is_sandboxed" = "true" ] && sandbox_icon="🔒" || sandbox_icon="🔓"

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // "unknown"' \
  | sed 's/^[Cc]laude[- ]//' \
  | sed 's/\([a-z]\)-\([0-9]\)/\1\2/' \
  | sed 's/\([0-9]\)-\([0-9]\)/\1.\2/' \
  | sed 's/ \([0-9]\)/\1/g' \
  | awk '{print toupper(substr($0,1,1)) substr($0,2)}' \
  | sed 's/ context)/)/g' \
  | sed 's/ (/(/g')
effort=$(echo "$input" | jq -r '.effort.level // empty')
[ -n "$effort" ] && model_label="${model}(${effort})" || model_label="${model}"

# --- git ---
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  staged=$(git -C "$dir" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git -C "$dir" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  unpushed=$(git -C "$dir" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
  untracked=$(git -C "$dir" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  stash_count=$(git -C "$dir" stash list 2>/dev/null | wc -l | tr -d ' ')
fi

# --- rate limits ---
color_pct() {
  local p=$1
  if   [ "$p" -lt 50 ]; then printf '%b' "${C_GREEN}${p}%${RESET}"
  elif [ "$p" -lt 80 ]; then printf '%b' "${C_YELLOW}${p}%${RESET}"
  else printf '%b' "${C_RED}${p}%${RESET}"; fi
}

color_pct_7d() {
  local p=$1 d=$2
  local threshold=$(( d * 100 / 7 ))
  if   [ "$p" -gt 80 ] || [ "$p" -gt "$threshold" ]; then printf '%b' "${C_RED}${p}%${RESET}"
  elif [ "$p" -gt $(( threshold * 4 / 5 )) ]; then printf '%b' "${C_YELLOW}${p}%${RESET}"
  else printf '%b' "${C_GREEN}${p}%${RESET}"; fi
}

five_h=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
seven_d=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_d_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

days_elapsed=4
reset_epoch=""
if [ -n "$seven_d_resets" ]; then
  reset_epoch="$seven_d_resets"
  now_epoch=$(date +%s)
  elapsed_secs=$(( now_epoch - (reset_epoch - 7 * 86400) ))
  days_elapsed=$(( elapsed_secs / 86400 + 1 ))
  [ "$days_elapsed" -lt 1 ] && days_elapsed=1
  [ "$days_elapsed" -gt 7 ] && days_elapsed=7
fi

# --- context bar ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
if [ -n "$used" ]; then
  pct=$(printf '%.0f' "$used")
  units=$(( pct * 20 / 100 ))
  [ "$units" -gt 20 ] && units=20
  full=$(( units / 2 ))
  half=$(( units % 2 ))
  empty_count=$(( 10 - full - half ))
  bar=""
  i=0; while [ "$i" -lt "$full"        ]; do bar="${bar}█"; i=$(( i + 1 )); done
  [ "$half" -eq 1 ] && bar="${bar}▌"
  i=0; while [ "$i" -lt "$empty_count" ]; do bar="${bar}░"; i=$(( i + 1 )); done
  if   [ "$pct" -lt 50 ]; then bar_clr="${C_GREEN}"
  elif [ "$pct" -lt 80 ]; then bar_clr="${C_YELLOW}"
  else bar_clr="${C_RED}"; fi
  ctx_str="💭 ${bar_clr}${bar}${RESET} ${BOLD}${pct}%${BOLD_OFF}"
else
  ctx_str="💭 ${DIM}░░░░░░░░░░░${RESET} ${DIM}--%${RESET}"
fi

# --- LINE 1: 📁 project ❯  branch ~N/+N/↑N ---
line1="${C_DIR}📁 $(basename "$dir")${RESET}"

if [ -n "$branch" ]; then
  # diff stats: each non-zero value gets a color, zeros get dim
  if [ "$unstaged"  -gt 0 ]; then u_str="${C_YELLOW}~${unstaged}${RESET}";   else u_str="${DIM}~0${RESET}"; fi
  if [ "$staged"    -gt 0 ]; then s_str="${C_GREEN}+${staged}${RESET}";     else s_str="${DIM}+0${RESET}"; fi
  if [ "$unpushed"  -gt 0 ]; then p_str="${C_MAGENTA}↑${unpushed}${RESET}"; else p_str="${DIM}↑0${RESET}"; fi
  if [ "$untracked" -gt 0 ]; then q_str="${DIM}/${RESET}${C_RED}?${untracked}${RESET}"; else q_str=""; fi
  if [ "$stash_count" -gt 0 ]; then stash_str=" ${C_YELLOW}⊙${stash_count}${RESET}"; else stash_str=""; fi

  line1="${line1}${SEP}${C_BRANCH}${GIT_ICON} ${branch}${RESET} ${u_str}${DIM}/${RESET}${s_str}${DIM}/${RESET}${p_str}${q_str}${stash_str}"
fi

# --- LINE 2: 🔒 model ❯ ctx ❯ rate limits ---
line2="${C_MODEL}${sandbox_icon} ${model_label}${RESET}"
line2="${line2}${SEP}${ctx_str}"

if [ -n "$five_h" ] || [ -n "$seven_d" ]; then
  rate_str=""
  if [ -n "$five_h" ]; then
    fh_pct=$(printf '%.0f' "$five_h")
    rate_str="${BOLD}5h:${BOLD_OFF}$(color_pct "$fh_pct")"
  fi
  if [ -n "$seven_d" ]; then
    sd_pct=$(printf '%.0f' "$seven_d")
    [ -n "$five_h" ] && rate_str="${rate_str} "
    [ -n "$reset_epoch" ] && sd_label="${BOLD}${days_elapsed}/7d:${BOLD_OFF}" || sd_label="${BOLD}7d:${BOLD_OFF}"
    rate_str="${rate_str}${sd_label}$(color_pct_7d "$sd_pct" "$days_elapsed")"

    if [ -n "$reset_epoch" ]; then
      now_epoch=$(date +%s)
      remaining_secs=$(( reset_epoch - now_epoch ))
      if [ "$remaining_secs" -gt 0 ]; then
        rem_days=$(( remaining_secs / 86400 ))
        rem_hours=$(( (remaining_secs % 86400) / 3600 ))
        rem_mins=$(( (remaining_secs % 3600) / 60 ))
        rate_str="${rate_str} ${BOLD}(⌛${rem_days}d:${rem_hours}h:${rem_mins}m)${RESET}"
      fi
    fi
  fi
  line2="${line2}${SEP}${rate_str}"
fi

printf '%b\n%b\n' "$line1" "$line2"
