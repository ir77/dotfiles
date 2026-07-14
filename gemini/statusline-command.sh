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
is_sandboxed=$(echo "$input" | jq -r '.sandbox.enabled // false')
[ "$is_sandboxed" = "true" ] && sandbox_icon="🔒" || sandbox_icon="🔓"

# --- model ---
model=$(echo "$input" | jq -r '.model.display_name // "unknown"' \
  | sed 's/^[Gg]emini[- ]//' \
  | sed 's/ (Medium)//' \
  | sed 's/ (High)//' \
  | sed 's/ (Low)//')
model_label="${model}"

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

rate_str=""
gw_rem=$(echo "$input" | jq -r '.quota["gemini-weekly"].remaining_fraction // empty')
tp_rem=$(echo "$input" | jq -r '.quota["3p-weekly"].remaining_fraction // empty')

if [ -n "$gw_rem" ]; then
  gw_used_pct=$(python3 -c "print(round((1 - float('$gw_rem')) * 100))" 2>/dev/null || echo "0")
  rate_str="${BOLD}Gemini:${BOLD_OFF}$(color_pct "$gw_used_pct")"
fi

if [ -n "$tp_rem" ]; then
  tp_used_pct=$(python3 -c "print(round((1 - float('$tp_rem')) * 100))" 2>/dev/null || echo "0")
  [ -n "$rate_str" ] && rate_str="${rate_str} "
  rate_str="${rate_str}${BOLD}Third-Party:${BOLD_OFF}$(color_pct "$tp_used_pct")"
fi

gw_reset_in=$(echo "$input" | jq -r '.quota["gemini-weekly"].reset_in_seconds // empty')
if [ -n "$gw_reset_in" ] && [ "$gw_reset_in" -gt 0 ]; then
  rem_days=$(( gw_reset_in / 86400 ))
  rem_hours=$(( (gw_reset_in % 86400) / 3600 ))
  rem_mins=$(( (gw_reset_in % 3600) / 60 ))
  rate_str="${rate_str} ${BOLD}(⌛ ${rem_days}d:${rem_hours}h:${rem_mins}m)${RESET}"
fi

# --- context bar ---
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
exceeds_200k=$(echo "$input" | jq -r '.exceeds_200k_tokens // false')

warning_str=""
if [ "$exceeds_200k" = "true" ]; then
  warning_str=" ${C_RED}⚠️>200k${RESET}"
fi

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
  ctx_str="💭 ${bar_clr}${bar}${RESET} ${BOLD}${pct}%${BOLD_OFF}${warning_str}"
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
[ -n "$rate_str" ] && line2="${line2}${SEP}${rate_str}"

printf '%b\n%b\n' "$line1" "$line2"
