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

# Nerd Font icons
GIT_ICON=$(printf '\xee\x82\xa0')    # U+E0A0 git branch
ICON_BOLT=$(printf '\xef\x83\xa7')   # U+F0E7 font-awesome bolt
ICON_WRENCH=$(printf '\xef\x82\xad') # U+F0AD font-awesome wrench
ICON_TARGET=$(printf '\xef\x85\x80') # U+F140 font-awesome bullseye

# --- Directory ---
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
[ -z "$dir" ] && dir="$PWD"

# --- Sandbox (item 2) ---
is_sandboxed=$(echo "$input" | jq -r '.sandbox.enabled // false')
[ "$is_sandboxed" = "true" ] && sandbox_icon="🔒" || sandbox_icon="🔓"

# --- Model & Mode (item 5) ---
model=$(echo "$input" | jq -r '.model.display_name // .model.id // "unknown"')
cycle_mode=$(echo "$input" | jq -r '.cycle_mode // empty')
case "$cycle_mode" in
  accept-edits)
    mode_label="${ICON_WRENCH} edit"
    ;;
  auto|automode)
    mode_label="${ICON_BOLT} auto"
    ;;
  plan)
    mode_label="${ICON_TARGET} plan"
    ;;
  default|"")
    mode_label=""
    ;;
  *)
    mode_label="📋 ${cycle_mode}"
    ;;
esac

if [ -n "$mode_label" ]; then
  model_label="${sandbox_icon} ${model} [${mode_label}]"
else
  model_label="${sandbox_icon} ${model}"
fi

# --- Git (including stash: item 3) ---
branch=$(git -C "$dir" rev-parse --abbrev-ref HEAD 2>/dev/null)
if [ -n "$branch" ]; then
  staged=$(git -C "$dir" diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
  unstaged=$(git -C "$dir" diff --name-only 2>/dev/null | wc -l | tr -d ' ')
  unpushed=$(git -C "$dir" rev-list @{u}..HEAD 2>/dev/null | wc -l | tr -d ' ')
  untracked=$(git -C "$dir" ls-files --others --exclude-standard 2>/dev/null | wc -l | tr -d ' ')
  stash_count=$(git -C "$dir" stash list 2>/dev/null | wc -l | tr -d ' ')
fi

# --- Context Bar ---
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
  ctx_str="💭 ${DIM}░░░░░░░░░░${RESET} ${DIM}--%${RESET}"
fi

# --- Quota / Rate Limits (item 1) ---
color_pct() {
  local p=$1
  if   [ "$p" -lt 50 ]; then printf '%b' "${C_GREEN}${p}%${RESET}"
  elif [ "$p" -lt 80 ]; then printf '%b' "${C_YELLOW}${p}%${RESET}"
  else printf '%b' "${C_RED}${p}%${RESET}"; fi
}

rate_str=""
g5_rem=$(echo "$input" | jq -r '.quota["gemini-5h"].remaining_fraction // empty')
g5_reset=$(echo "$input" | jq -r '.quota["gemini-5h"].reset_in_seconds // empty')
gw_rem=$(echo "$input" | jq -r '.quota["gemini-weekly"].remaining_fraction // empty')
gw_reset=$(echo "$input" | jq -r '.quota["gemini-weekly"].reset_in_seconds // empty')

tp5_rem=$(echo "$input" | jq -r '.quota["3p-5h"].remaining_fraction // empty')

# 3P 5h (if active/consumed)
if [ -n "$tp5_rem" ] && [ "$tp5_rem" != "1" ]; then
  tp_used=$(awk "BEGIN {printf \"%.0f\", (1 - $tp5_rem) * 100}")
  rate_str="${BOLD}3p-5h:${BOLD_OFF}$(color_pct "$tp_used")"
elif [ -n "$g5_rem" ]; then
  g5_used=$(awk "BEGIN {printf \"%.0f\", (1 - $g5_rem) * 100}")
  rate_str="${BOLD}5h:${BOLD_OFF}$(color_pct "$g5_used")"
  if [ -n "$g5_reset" ] && [ "$g5_reset" -gt 0 ]; then
    h=$(( g5_reset / 3600 ))
    m=$(( (g5_reset % 3600) / 60 ))
    rate_str="${rate_str} ${BOLD}(⌛ ${h}h:${m}m)${RESET}"
  fi
fi

if [ -n "$gw_rem" ]; then
  gw_used=$(awk "BEGIN {printf \"%.0f\", (1 - $gw_rem) * 100}")
  [ -n "$rate_str" ] && rate_str="${rate_str} "
  rate_str="${rate_str}${BOLD}7d:${BOLD_OFF}$(color_pct "$gw_used")"
  if [ -n "$gw_reset" ] && [ "$gw_reset" -gt 0 ]; then
    d=$(( gw_reset / 86400 ))
    h=$(( (gw_reset % 86400) / 3600 ))
    rate_str="${rate_str} ${BOLD}(⌛ ${d}d:${h}h)${RESET}"
  fi
fi

# --- LINE 1: 📁 project ❯ branch ~N/+N/↑N/?N ⊙stash ---
line1="${C_DIR}📁 $(basename "$dir")${RESET}"

if [ -n "$branch" ]; then
  if [ "$unstaged"  -gt 0 ]; then u_str="${C_YELLOW}~${unstaged}${RESET}";   else u_str="${DIM}~0${RESET}"; fi
  if [ "$staged"    -gt 0 ]; then s_str="${C_GREEN}+${staged}${RESET}";     else s_str="${DIM}+0${RESET}"; fi
  if [ "$unpushed"  -gt 0 ]; then p_str="${C_MAGENTA}↑${unpushed}${RESET}"; else p_str="${DIM}↑0${RESET}"; fi
  if [ "$untracked" -gt 0 ]; then q_str="${DIM}/${RESET}${C_RED}?${untracked}${RESET}"; else q_str=""; fi
  if [ "$stash_count" -gt 0 ]; then stash_str=" ${C_YELLOW}⊙${stash_count}${RESET}"; else stash_str=""; fi

  line1="${line1}${SEP}${C_BRANCH}${GIT_ICON} ${branch}${RESET} ${u_str}${DIM}/${RESET}${s_str}${DIM}/${RESET}${p_str}${q_str}${stash_str}"
fi

# --- LINE 2: 🤖 model [mode] ❯ ctx ❯ rate limits ---
line2="${C_MODEL}${model_label}${RESET}"
line2="${line2}${SEP}${ctx_str}"
[ -n "$rate_str" ] && line2="${line2}${SEP}${rate_str}"

printf '%b\n%b\n' "$line1" "$line2"
