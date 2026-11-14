#!/usr/bin/env bash
# Claude Code status line: model · effort · dir · branch · context · session · week

input=$(cat)

IFS=$'\t' read -r model effort dir context session week < <(
  jq -r '[
    .model.display_name // "",
    .effort.level // "",
    .workspace.current_dir // "",
    .context_window.used_percentage // "",
    .rate_limits.five_hour.used_percentage // "",
    .rate_limits.seven_day.used_percentage // ""
  ] | map(tostring | if . == "" then "-" else . end) | @tsv' <<<"$input"
)
for var in model effort dir context session week; do
  [ "${!var}" = "-" ] && printf -v "$var" ''
done

sep='\033[2m · \033[0m'
out=''
append() { [ -n "$out" ] && out+="$sep"; out+="$1"; }

# $1: percentage, $2: bar width, $3: optional label
gauge() {
  local pct width=$2 label=$3 color='\033[2m' filled bar='' i
  pct=$(printf '%.0f' "$1")
  [ "$pct" -ge 75 ] && color='\033[2;33m'
  [ "$pct" -ge 90 ] && color='\033[2;31m'
  filled=$(( (pct * width + 50) / 100 ))
  for ((i = 1; i <= width; i++)); do
    if [ "$i" -le "$filled" ]; then bar+='▰'; else bar+='▱'; fi
  done
  printf '%b%s%s %d%%\033[0m' "$color" "${label:+$label }" "$bar" "$pct"
}

[ -n "$model" ] && append "\033[2;36m${model}\033[0m"

if [ -n "$effort" ]; then
  ecolor='\033[2m'
  case "$effort" in
    medium) ecolor='\033[2;32m' ;;
    high) ecolor='\033[2;33m' ;;
    xhigh) ecolor='\033[2;31m' ;;
  esac
  append "${ecolor}${effort}\033[0m"
fi

append "\033[2;34m$(basename "$dir")\033[0m"

branch=$(cd "$dir" 2>/dev/null && git --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)
[ -n "$branch" ] && append "\033[2;32m${branch}\033[0m"

[ -n "$context" ] && append "$(gauge "$context" 10 ctx)"
[ -n "$session" ] && append "$(gauge "$session" 10 session)"
[ -n "$week" ] && append "$(gauge "$week" 10 week)"

printf '%b' "$out"
