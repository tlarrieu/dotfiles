# shellcheck shell=bash
# Shared by the Claude agent scripts. Source it: . "$assets/lib/claude-agents.sh"

# Live sessions, one state file each, named after the session id (see
# claude-agent-state, which writes them; dot files are temporary)
agents_dir="${XDG_RUNTIME_DIR:-/tmp}/claude-agents"

# A state file holds one line: these fields, space separated
#   state         running, done, idle or attention (claude-agent-list
#                 tells monitoring too, see monitoring); view: continued in
#                 another session, which it shows (claude-agent-list marks
#                 them, and leaves them out)
#   pid           the claude process
#   started       when the session started (epoch)
#   window        its terminal's X window id
#   listen_on     its kitty's remote control socket
#   kitty_window  its kitty window id
#   project       the git repository (or directory) it runs in
#   transcript    its transcript path
#   since         when the current turn started (epoch)
#   pr            the pull request it works on, as <owner/repo>#<number>
#                 (agent_pr for claude-agent-pr's agents, branch_pr for the
#                 others), as of its last hook
#   root          the top of its worktree (- when it holds a space)
#   untold        yes: done, its turn over on something left running (see
#                 monitoring), its "Done" not told yet (see claude-agent-state)
# Missing values are written as -.
agent_fields=(state pid started window listen_on kitty_window project transcript since pr root untold)

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

# The pull request of mine (merge-queue's cache) whose head branch the
# worktree at <root> is on, in the repository its origin is: an agent working
# there works on it, whoever spawned it. Prints <owner/repo>#<number>, or
# nothing.
# Usage: branch_pr <root>
branch_pr() {
  local branch origin cache="${XDG_STATE_HOME:-$HOME/.local/state}/github/merge-queue/queue.tsv"
  [ -n "$1" ] && [ "$1" != - ] && [ -f "$cache" ] || return 0
  branch=$(git -C "$1" branch --show-current 2>/dev/null)
  [ -n "$branch" ] || return 0
  origin=$(git -C "$1" remote get-url origin 2>/dev/null) || return 0
  origin=${origin%.git} origin=${origin%/}
  awk -F'\t' -v branch="$branch" -v origin="${origin,,}" '
    NR == 1 { sub(/^#/, ""); for (i = 1; i <= NF; i++) column[$i] = i; next }
    $(column["branch"]) == branch && $(column["kind"]) ~ /^(other|ready|queued)$/ {
      repo = tolower($(column["repo"]))
      if (substr(origin, length(origin) - length(repo)) ~ "^[:/]" && substr(origin, length(origin) - length(repo) + 1) == repo) {
        print $(column["repo"]) "#" $(column["number"]); exit
      }
    }' "$cache"
}

# A session's title, from its transcript: the one given with /rename (or
# --name), else Claude's own; cut to 90 characters
# Usage: agent_title <transcript>
agent_title() {
  [ -f "$1" ] || return 0
  grep -E '"type":"(custom-title|agent-name|ai-title)"' "$1" | jq -rs '
    (map(select(.type == "custom-title")) | last | .customTitle)
    // (map(select(.type == "agent-name")) | last | .agentName)
    // (map(select(.type == "ai-title")) | last | .aiTitle) // empty
    | .[0:90]
  ' 2>/dev/null # (in jq: by character, where mawk cuts bytes)
}

# An agent's name, for notifications: its project, then its pull request
# (<owner/repo>#<number>: #<number>) or its session's title
# Usage: agent_name <project> <pr or -> <transcript>
agent_name() {
  local name=$1 title
  if [ -n "$2" ] && [ "$2" != - ]; then
    name+=" #${2##*#}"
  else
    title=$(agent_title "$3")
    [ -n "$title" ] && name+=" · $title"
  fi
  echo "$name"
}

# What an agent said last (the first line of its last text), from its
# transcript; cut to 200 characters
# Usage: agent_last_words <transcript>
agent_last_words() {
  [ -f "$1" ] || return 0
  tail -n 200 "$1" | jq -rs '
    [.[] | select(.type == "assistant") | .message.content | arrays | .[] | select(.type == "text") | .text]
    | last // empty | split("\n") | map(select(test("\\S"))) | first // empty | .[0:200]
  ' 2>/dev/null
}

# A notification about an agent which, clicked, jumps to it (see
# claude-agent-jump). One per agent: a newer one replaces it (its id kept in
# agent_notification <session>). Waiting for the click happens detached, so
# that hooks return at once. Needs $assets (the scripts' directory).
# Usage: agent_notify <session> <urgency> <title> <body>
agent_notification() { echo "$agents_dir/.$1.notification"; } # a dot file: no session's
agent_notify() {
  local id file
  file=$(agent_notification "$1")
  id=$(cat "$file" 2>/dev/null)
  # shellcheck disable=SC2016,SC2154 # $1..$7 belong to the inner sh; $assets: the caller's
  setsid -f sh -c '
    notify-send --app-name=claude --icon="$1/claude.png" --urgency="$3" ${6:+--replace-id="$6"} \
      --action=default=Jump --print-id --wait "$4" "$5" | {
      read -r id && echo "$id" >"$7"
      read -r action && [ "$action" = default ] && exec "$1/claude-agent-jump" "$2"
    }' sh "$assets" "$1" "$2" "$3" "$4" "$id" "$file" >/dev/null 2>&1
}

# A spawn's progress (see claude-agent-pr and claude-agent-spawn), in one
# notification shown at once, before the slow parts: each call replaces the
# previous one, its id kept in CLAUDE_AGENT_NOTIFICATION (exported: a spawn
# started by claude-agent-pr carries on with its notification). Its app name
# tells its state, which awesome colors (see its theme): blue when started,
# green when launched, red when failed (critical: it stays). Needs $assets.
# Usage: spawn_notify <started|launched|failed> <body>
spawn_notify() {
  local id urgency=normal
  [ "$1" = failed ] && urgency=critical
  id=$(notify-send --app-name="claude.spawn.$1" --icon="$assets/claude.png" --urgency="$urgency" --print-id \
    ${CLAUDE_AGENT_NOTIFICATION:+--replace-id="$CLAUDE_AGENT_NOTIFICATION"} Claude "$2" 2>/dev/null)
  [ -n "$id" ] && export CLAUDE_AGENT_NOTIFICATION=$id
  return 0
}

# Closes an agent's notification (see agent_notify), once outdated: it moved on
# Usage: agent_unnotify <session>
agent_unnotify() {
  local id file
  file=$(agent_notification "$1")
  id=$(cat "$file" 2>/dev/null) || return 0
  rm -f "$file"
  gdbus call --session --dest org.freedesktop.Notifications --object-path /org/freedesktop/Notifications \
    --method org.freedesktop.Notifications.CloseNotification "$id" >/dev/null 2>&1 &
}

# Whether <pid> is a live claude process running a session (not a dead one's
# reused pid): one in a terminal, or a background one (in claude's daemon,
# whose workers go by claude's version, e.g. 2.1.327). Not the daemon itself,
# nor its pty hosts: they outlive their sessions
alive() {
  case "$1" in "" | *[!0-9]*) return 1 ;; esac
  local comm argv=()
  read -r comm 2>/dev/null <"/proc/$1/comm" || return 1
  [[ $comm == claude || $comm =~ ^[0-9]+(\.[0-9]+)+$ ]] || return 1
  mapfile -d '' -n 2 argv 2>/dev/null <"/proc/$1/cmdline"
  case "${argv[1]}" in daemon | --bg-pty-host) return 1 ;; esac
}

# Whether claude process <pid> runs a background session: under claude's
# daemon (moved there with ←, or started with --bg). It has no terminal of
# its own: `claude attach` shows it (see claude-agent-jump)
# Usage: background <pid>
background() {
  local pid=$1 argv ppid
  while [ "$pid" -gt 1 ] 2>/dev/null; do
    argv=()
    mapfile -d '' -n 2 argv 2>/dev/null <"/proc/$pid/cmdline"
    [ "${argv[1]}" = daemon ] && return 0
    read_ppid "$pid" || return 1
    pid=$ppid
  done
  return 1
}

# Sets ppid: process <pid>'s parent. In bash, as forking for it (awk, ps)
# costs more than the rest of a walk up the tree. Its fields after its name,
# which may hold spaces and parentheses
# Usage: read_ppid <pid>
read_ppid() {
  local stat
  read -r stat 2>/dev/null <"/proc/$1/stat" || return 1
  stat=${stat##*) } # <state> <ppid> …
  stat=${stat#* }
  ppid=${stat%% *}
}

# Whether claude process <pid>'s turn left something running: a tool's shell
# (they source claude's shell snapshot), a Monitor's or a background Bash's.
# Its own hooks (our callers) aside
# Usage: monitoring <pid>
# All from /proc, in bash: pgrep scans every process, and claude-agent-list
# asks for each agent done or idle (rofi-github waits on it)
monitoring() {
  local self=$$ ppid child children=() more argv
  local -A ancestors=()
  while [ "$self" -gt 1 ] 2>/dev/null; do
    ancestors[$self]=1
    read_ppid "$self" || break
    self=$ppid
  done
  for child in /proc/"$1"/task/*/children; do
    more=()
    read -ra more 2>/dev/null <"$child" # one line, unterminated
    children+=("${more[@]}")
  done
  for child in "${children[@]}"; do
    [ -n "${ancestors[$child]}" ] && continue
    argv=()
    mapfile -d '' argv 2>/dev/null <"/proc/$child/cmdline"
    [[ "${argv[*]}" == */.claude/shell-snapshots/* ]] && return 0
  done
  return 1
}

# The terminals showing background session <session> (see background), one
# per line: <X window> <kitty socket> <kitty window> (- when unknown). Claude's
# agent view showing it, by its terminal's title (the session's, after a
# status glyph): a session in a kitty window, sent to the background (←) as
# it was (a view now, see claude-agent-list), or before typing anything (it
# hands its first prompt over to a background session, then shows those; no
# transcript of its own). Then those attached to it (claude attach). Needs
# $assets
# Usage: background_terminals <session> <transcript>
# shellcheck disable=SC2154 # state file fields, set by read_agent
background_terminals() {
  local session=$1 title='' shown f client argv i found var window socket id
  local "${agent_fields[@]/#/view_}"
  for f in "$agents_dir"/*; do
    [ -f "$f" ] || continue
    read_agent "$f" view_
    [ "$view_state" = view ] || [ ! -f "$view_transcript" ] || continue
    alive "$view_pid" || continue
    case "$view_window" in "" | *[!0-9]*) continue ;; esac
    [ "$view_listen_on" != - ] && [ "$view_kitty_window" != - ] || continue
    shown=$(kitty @ --to "$view_listen_on" ls --match "id:$view_kitty_window" 2>/dev/null |
      jq -r '.[0].tabs[0].windows[0].title // empty' 2>/dev/null)
    [[ $shown == *' '* ]] || continue
    shown=${shown#* }
    [ -n "$title" ] || title=$(agent_title "$2")
    [ -n "$title" ] || break
    # (agent_title cuts it)
    [ "$shown" = "$title" ] || { [ ${#title} -ge 90 ] && [[ $shown == "$title"* ]]; } || continue
    echo "$view_window $view_listen_on $view_kitty_window"
  done
  for client in $(pgrep -x claude); do
    argv=() found=''
    mapfile -d '' argv 2>/dev/null <"/proc/$client/cmdline"
    for i in "${!argv[@]}"; do
      [ "${argv[$i]}" = attach ] && [ "${argv[$((i + 1))]:0:8}" = "${session:0:8}" ] && found=yes # claude's short ids
    done
    [ -n "$found" ] || continue
    window='' socket=- id=-
    while IFS= read -r -d '' var; do
      case $var in
        WINDOWID=*) window=${var#*=} ;;
        KITTY_LISTEN_ON=*) socket=${var#*=} ;;
        KITTY_WINDOW_ID=*) id=${var#*=} ;;
      esac
    done 2>/dev/null <"/proc/$client/environ"
    case "$window" in "" | *[!0-9]*) ;; *) echo "$window $socket $id" ;; esac
  done
}

# Whether an agent's terminal is on screen (see claude-agent-displayed); a
# background one's (no window of its own): one showing it (see
# background_terminals). Needs $assets
# Usage: agent_displayed <session> <transcript> <X window> <kitty socket> <kitty window>
agent_displayed() {
  local window socket id
  [ "$3" != - ] && { "$assets/claude-agent-displayed" "$3" "$4" "$5"; return; }
  while read -r window socket id; do
    "$assets/claude-agent-displayed" "$window" "$socket" "$id" && return 0
  done < <(background_terminals "$1" "$2")
  return 1
}

# How much an agent in each state wants me: attention, then done (to read),
# running and monitoring (working, its turn over, on what it left running),
# idle. For when several qualify (see pr_agent)
# shellcheck disable=SC2034 # for the scripts sourcing us
declare -A agent_wants=([attention]=4 [done]=3 [running]=2 [monitoring]=2 [idle]=1)

# The session of the agent working on pull request <owner/repo>#<number>
# (see claude-agent-pr), the one wanting me the most when there are several;
# nothing when none does. Needs $assets (the scripts' directory) and
# records.sh.
# Usage: pr_agent <owner/repo>#<number>
pr_agent() {
  local wanted=$1 best='' best_rank=0
  # shellcheck disable=SC2154,SC2329 # record fields, set by each_record (which calls it)
  pick() {
    [ "$pr" = "$wanted" ] && [ "${agent_wants[$state]:-0}" -gt "$best_rank" ] && best=$session best_rank=${agent_wants[$state]:-0}
    return 0
  }
  each_record pick < <("$assets/claude-agent-list")
  echo "$best"
}

# The face of each state (mirrored in config/awesome/widgets/agents.lua)
# shellcheck disable=SC2034 # for the scripts sourcing us
declare -A agent_faces=([running]='󱚣' [monitoring]='󱚣' [done]='󱜙' [idle]='󱜙' [attention]='󱚟')

# How long since <epoch>, for turns: 42s, 4m, 1h05 (mirrored in
# config/awesome/widgets/agents.lua)
elapsed() {
  local seconds=$(($(date +%s) - $1))
  if [ "$seconds" -lt 60 ]; then echo "${seconds}s"
  elif [ "$seconds" -lt 3600 ]; then echo "$((seconds / 60))m"
  else printf '%dh%02d' $((seconds / 3600)) $((seconds % 3600 / 60)); fi
}
