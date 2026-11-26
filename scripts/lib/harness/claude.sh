# shellcheck shell=bash
# Claude Code, as a harness (see the contract in lib/agents.sh, which sources
# us): its transcripts, its processes, its branding. Its hooks go through
# harness/claude-hook, its settings.json registering them.
# Functions are named claude_<what the contract calls them>.

# shellcheck disable=SC2034,SC2154 # read through harness_brand; agent_scripts: lib/agents.sh's
claude_label=Claude claude_icon="$agent_scripts/claude.png" claude_sound="$agent_scripts/claude.ogg"
claude_glyph=$'\uec82' # Nerd Fonts' cod-claude (3.5 on)

# Whether <pid> is a live claude process running a session (not a dead one's
# reused pid): one in a terminal, or a background one (in claude's daemon,
# whose workers go by claude's version, e.g. 2.1.327). Not the daemon itself,
# nor its pty hosts: they outlive their sessions
# Usage: claude_alive <pid>
claude_alive() {
  case "$1" in "" | *[!0-9]*) return 1 ;; esac
  local comm argv=()
  read -r comm 2>/dev/null <"/proc/$1/comm" || return 1
  [[ $comm == claude || $comm =~ ^[0-9]+(\.[0-9]+)+$ ]] || return 1
  mapfile -d '' -n 2 argv 2>/dev/null <"/proc/$1/cmdline"
  case "${argv[1]}" in daemon | --bg-pty-host) return 1 ;; esac
}

# Whether claude process <pid> runs a background session: under claude's
# daemon (moved there with ←, or started with --bg). It has no terminal of
# its own: `claude attach` shows it (see claude_attach)
# Usage: claude_background <pid>
claude_background() {
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

# Whether claude process <pid>'s turn left something running (see
# claude_tools)
# Usage: claude_busy <pid>
claude_busy() { [ -n "$(claude_tools "$1")" ]; }

# The tools claude process <pid> runs, one pid a line: its tools' shells
# (they source claude's shell snapshot), a Bash's (in the foreground or the
# background) or a Monitor's. Its own hooks (our callers) aside
# Usage: claude_tools <pid>
# All from /proc, in bash: pgrep scans every process, and agent-list
# asks for each agent done, idle or waiting (rofi-github waits on it)
claude_tools() {
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
    [[ "${argv[*]}" == */.claude/shell-snapshots/* ]] && echo "$child"
  done
  return 0
}

# A session's title, from its transcript: the one given with /rename (or
# --name), else Claude's own; cut to 90 characters
# Usage: claude_title <transcript>
claude_title() {
  [ -f "$1" ] || return 0
  grep -E '"type":"(custom-title|agent-name|ai-title)"' "$1" | jq -rs '
    (map(select(.type == "custom-title")) | last | .customTitle)
    // (map(select(.type == "agent-name")) | last | .agentName)
    // (map(select(.type == "ai-title")) | last | .aiTitle) // empty
    | .[0:90]
  ' 2>/dev/null # (in jq: by character, where mawk cuts bytes)
}

# What it said last (the first line of its last text), from its transcript;
# cut to 200 characters
# Usage: claude_last_words <transcript>
claude_last_words() {
  [ -f "$1" ] || return 0
  tail -n 200 "$1" | jq -rs '
    [.[] | select(.type == "assistant") | .message.content | arrays | .[] | select(.type == "text") | .text]
    | last // empty | split("\n") | map(select(test("\\S"))) | first // empty | .[0:200]
  ' 2>/dev/null
}

# The skills a first prompt can call (/<name>), one a line: <name>, a tab,
# <description>, from their SKILL.md's frontmatter (the name defaulting to
# their directory's): mine (~/.claude) first, then repository [dir]'s own,
# by name, one of mine hiding the repository's (as Claude ranks them:
# personal over project). Claude's built-in ones
# (/code-review…) aside: they have no SKILL.md
# Usage: claude_skills [dir]
claude_skills() {
  local roots=("$HOME/.claude/skills") root file
  [ -n "$1" ] && roots+=("$1/.claude/skills")
  for root in "${roots[@]}"; do
    for file in "$root"/*/SKILL.md; do
      [ -f "$file" ] || continue
      awk -v dir="$(basename "$(dirname "$file")")" '
        NR == 1 { if ($0 != "---") exit; next }
        $0 == "---" { exit }
        /^name:/ { sub(/^name:[ \t]*/, ""); name = $0 }
        /^description:/ { sub(/^description:[ \t]*/, ""); description = $0 }
        function unquote(text) { return text ~ /^(".*"|\047.*\047)$/ ? substr(text, 2, length(text) - 2) : text }
        END { name = unquote(name); printf "%s\t%s\n", (name == "" ? dir : name), unquote(description) }' "$file"
    done
  done | awk -F '\t' '!seen[$1]++'
}

# The prompt it started on, from its transcript (reads up to it only)
# Usage: claude_first_prompt <transcript>
claude_first_prompt() {
  [ -f "$1" ] || return 0
  jq -nr 'first(inputs | select(.type == "user")
    | .message.content | if type == "array" then (.[0].text // "") else . end
    | select(length > 0))' "$1" 2>/dev/null
}

# Whether its turn ended on an interrupt (rejected question or permission,
# Esc), which fires no hook
# Usage: claude_interrupted <transcript>
claude_interrupted() {
  [ -f "$1" ] && tail -n 50 "$1" | jq -se '
    [.[] | select(.type == "user" or .type == "assistant")] | last | .message.content
    | (if type == "array" then .[0].text // "" else . end)
    | startswith("[Request interrupted by user")
  ' >/dev/null 2>&1
}

# Whether it continued in another session: backgrounding a session hands it
# over to a new one (in claude's daemon), while the original process lives
# on, showing the new session. Unless resumed since (claude --resume): its own
# messages then follow the handover
# Usage: claude_handed_over <transcript>
claude_handed_over() {
  [ -f "$1" ] && [ "$(tail -n 200 "$1" | grep -E '"type":"(user|assistant|continued-in)"' |
    jq -rs '[.[] | select(.type | IN("user", "assistant", "continued-in"))] | last | .type // empty' 2>/dev/null)" = continued-in ]
}

# The terminals showing background session <session> (see claude_background),
# one per line: <X window> <kitty socket> <kitty window> (- when unknown).
# Claude's agent view showing it, by its terminal's title (the session's,
# after a status glyph): a session in a kitty window, sent to the background
# (←) as it was (a view now, see agent-list), or before typing anything (it
# hands its first prompt over to a background session, then shows those; no
# transcript of its own). Then those attached to it (claude attach)
# Usage: claude_terminals <session> <transcript>
# shellcheck disable=SC2154 # state file fields, set by read_agent
claude_terminals() {
  local session=$1 title='' shown f client argv i found var window socket id
  local "${agent_fields[@]/#/view_}"
  for f in "$agents_dir"/*; do
    [ -f "$f" ] || continue
    read_agent "$f" view_
    [ "$view_harness" = claude ] || continue
    [ "$view_state" = view ] || [ ! -f "$view_transcript" ] || continue
    claude_alive "$view_pid" || continue
    case "$view_window" in "" | *[!0-9]*) continue ;; esac
    [ "$view_listen_on" != - ] && [ "$view_kitty_window" != - ] || continue
    shown=$(kitty @ --to "$view_listen_on" ls --match "id:$view_kitty_window" 2>/dev/null |
      jq -r '.[0].tabs[0].windows[0].title // empty' 2>/dev/null)
    [[ $shown == *' '* ]] || continue
    shown=${shown#* }
    [ -n "$title" ] || title=$(claude_title "$2")
    [ -n "$title" ] || break
    # (claude_title cuts it)
    [ "$shown" = "$title" ] || { [ ${#title} -ge 90 ] && [[ $shown == "$title"* ]]; } || continue
    echo "$view_window $view_listen_on $view_kitty_window"
  done
  local short=''
  for client in $(pgrep -x claude); do
    argv=() found=''
    mapfile -d '' argv 2>/dev/null <"/proc/$client/cmdline"
    for i in "${!argv[@]}"; do
      [ "${argv[$i]}" = attach ] || continue
      [ -n "$short" ] || short=$(claude_short_id "$session")
      [ "${argv[$((i + 1))]:0:8}" = "$short" ] && found=yes
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

# The id claude's daemon knows background session <session> by (attach
# takes it): the one it was started with, which a session resumed as a fork
# (--fork-session) no longer starts with, else its first 8 characters
# Usage: claude_short_id <session>
claude_short_id() {
  local id
  id=$(timeout 10 claude agents --json 2>/dev/null |
    jq -r --arg session "$1" 'first(.[] | select(.kind == "background" and .sessionId == $session) | .id) // empty' 2>/dev/null)
  echo "${id:-${1:0:8}}"
}

# The command showing background session <session> in a terminal
# Usage: claude_attach <session>
claude_attach() { echo "claude attach $(claude_short_id "$1")"; }

# The fish command running an agent in the current directory: on fish
# variable $prompt as its first prompt with --prompt (else interactive), with
# fish variable $context's instructions appended to its system prompt with
# --context. Through the claude fish function, which brings the settings from
# my dotfiles. "--" ends claude's options: a prompt may start with a dash
# Usage: claude_launch [--prompt] [--context]
claude_launch() {
  local command=claude arg
  for arg; do
    case $arg in
      --context) command+=" --append-system-prompt \$context" ;;
      --prompt) local prompt=yes ;;
    esac
  done
  [ -n "$prompt" ] && command+=" -- \$prompt"
  echo "$command"
}

# How an agent is to wait on something that takes a while (a CI job), for
# prompts: the tools of Claude's doing it in the background
# Usage: claude_watch
claude_watch() { echo "in the background (Monitor, or Bash with run_in_background and an until loop), not with sleep in the foreground"; }
