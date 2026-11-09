# shellcheck shell=bash
# Shared by the Claude agent scripts. Source it: . "$assets/lib/claude-agents.sh"

# Live sessions, one state file each, named after the session id (see
# claude-agent-state, which writes them; dot files are temporary)
agents_dir="${XDG_RUNTIME_DIR:-/tmp}/claude-agents"

# A state file holds one line: these fields, space separated
#   state         running, done, idle or attention
#   pid           the claude process
#   started       when the session started (epoch)
#   window        its terminal's X window id
#   listen_on     its kitty's remote control socket
#   kitty_window  its kitty window id
#   project       the git repository (or directory) it runs in
#   transcript    its transcript path
#   since         when the current turn started (epoch)
#   pr            the pull request it works on, as <owner/repo>#<number>
#                 (see claude-agent-pr, and agent_pr for agents started
#                 before it recorded it)
# Missing values are written as -.
agent_fields=(state pid started window listen_on kitty_window project transcript since pr)

# Sets the fields of state file <file> as variables, each name prefixed with
# [prefix] (all empty when the file is missing)
# Usage: read_agent <file> [prefix]
read_agent() {
  local -a names=("${agent_fields[@]/#/$2}")
  local name
  for name in "${names[@]}"; do printf -v "$name" ''; done
  [ -f "$1" ] && read -r "${names[@]}" <"$1"
  return 0
}

# Writes the field variables to state file <file> at once (through a rename),
# so that readers never see it half written
# Usage: write_agent <file>
write_agent() {
  local name tmp
  local -a values=()
  for name in "${agent_fields[@]}"; do values+=("${!name:--}"); done
  tmp=$(mktemp "$agents_dir/.write.XXXXXX") || return 1
  echo "${values[*]}" >"$tmp" && mv "$tmp" "$1"
}

# The pull request an agent works on, from its transcript: claude-agent-pr's
# agents open with "Fix <its URL>" or "Review <its URL>" (an agent merely
# mentioning one doesn't count). Prints <owner/repo>#<number>, or nothing.
# Reads up to the first prompt only.
# Usage: agent_pr <transcript>
agent_pr() {
  [ -f "$1" ] || return 0
  jq -nr 'first(inputs | select(.type == "user")
    | .message.content | if type == "array" then (.[0].text // "") else . end
    | select(length > 0))
    | capture("^(Fix|Review) https://github\\.com/(?<repo>[^/\\s]+/[^/\\s]+)/pull/(?<number>[0-9]+)")
    | "\(.repo)#\(.number)"' "$1" 2>/dev/null
}

# Whether <pid> is a live claude process (not a dead one's reused pid)
alive() {
  case "$1" in "" | *[!0-9]*) return 1 ;; esac
  [ "$(cat "/proc/$1/comm" 2>/dev/null)" = claude ]
}

# The face of each state (mirrored in config/awesome/widgets/agents.lua)
# shellcheck disable=SC2034 # for the scripts sourcing us
declare -A agent_faces=([running]='󱚣' [done]='󱜙' [idle]='󱜙' [attention]='󱚟')

# How long since <epoch>, for turns: 42s, 4m, 1h05 (mirrored in
# config/awesome/widgets/agents.lua)
elapsed() {
  local seconds=$(($(date +%s) - $1))
  if [ "$seconds" -lt 60 ]; then echo "${seconds}s"
  elif [ "$seconds" -lt 3600 ]; then echo "$((seconds / 60))m"
  else printf '%dh%02d' $((seconds / 3600)) $((seconds % 3600 / 60)); fi
}
