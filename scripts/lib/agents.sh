# shellcheck shell=bash
# Shared by the agent scripts. Source it: . "$assets/lib/agents.sh"
#
# Agents are coding assistant sessions, run by a harness (Claude Code
# today, others side by side), which the rest knows only through the state
# files below: the panel (config/awesome/widgets/agents.lua, through
# agent-list), rofi-github, the GitHub notifications' Fix action, agent-jump,
# agent-sweep, local-work.
# Each harness has an adapter, lib/harness/<name>.sh (all sourced below),
# filling this contract with functions named <name>_<what>, and variables
# <name>_label, <name>_icon, <name>_sound (its branding: notifications,
# their sound). lib/harness/fake.sh is the smallest one (required parts and
# transcript readers only), harness/fake-test checking the agent scripts
# through it. Called through harness_do:
#   required
#     launch [--prompt] [--context]  the fish command running an agent in the
#                 current directory (agent-spawn): its first prompt in fish
#                 variable $prompt with --prompt (else interactive), more
#                 instructions in $context with --context; it exits non-zero
#                 on failure
#     alive <pid>  whether a pid is one of its sessions (agent-list, sweep)
#     state       telling each session's state as it changes, through
#                 agent-state (its usage tells how), from its hooks (Claude:
#                 harness/claude-hook); without hooks, agent-list would have to
#                 guess from the process
#   optional (what goes without it, in parentheses)
#     title <transcript>  a session's title (rofi-github's rows, notifications)
#     last_words <transcript>  what it said last (the "Done" notifications'
#                 body, when agent-state isn't told)
#     first_prompt <transcript>  the prompt it started on (agent-pr's agents
#                 tell their pull request by it; else by branch only)
#     interrupted <transcript>  whether its turn ended on an interrupt (it
#                 shows as busy until its next state)
#     handed_over <transcript>  whether it continued in another session it
#                 shows (it lists as an agent of its own)
#     background <pid>  whether it runs without a terminal; terminals <session>
#                 <transcript>: those showing it, one per line, <X window>
#                 <kitty socket> <kitty window>; attach <session>: the command
#                 showing it in a new one (agent-jump can't reach them)
#     busy <pid>  whether its turn left something running (no monitoring
#                 state: done at once)
#     tools <pid>  the tools it runs, one pid a line (a permission granted
#                 shows as attention until the tool is over: see the tools
#                 field)
#     watch       how an agent is to wait on something that takes a while (a
#                 CI job), in words, for prompts (agent-pr's; else: in the
#                 background, not by sleeping in the foreground)

# Live sessions, one state file each, named after the session id (see
# agent-state, which writes them; dot files are temporary)
agents_dir="${XDG_RUNTIME_DIR:-/tmp}/agents"

# A state file holds one line: these fields, space separated
#   state         running, done, idle or attention (agent-list
#                 tells monitoring too, see monitoring); view: continued in
#                 another session, which it shows (agent-list marks
#                 them, and leaves them out)
#   pid           the agent's process (the harness's)
#   started       when the session started (epoch)
#   window        its terminal's X window id
#   listen_on     its kitty's remote control socket
#   kitty_window  its kitty window id
#   project       the git repository (or directory) it runs in
#   transcript    its transcript path
#   since         when the current turn started (epoch)
#   pr            the pull request it works on, as <owner/repo>#<number>
#                 (see session_pr), as of its last hook
#   root          the top of its worktree (- when it holds a space)
#   untold        yes: done, its turn over on something left running (see
#                 monitoring), its "Done" not told yet (see agent-state)
#   harness       the harness running it (see above); missing in older files:
#                 $default_harness
#   tools         attention: the tools it ran as it asked (see tools in the
#                 contract), comma separated: a new one tells it got what it
#                 asked for (a permission: no hook tells, until the tool is
#                 over), see agent-list
# Missing values are written as -.
agent_fields=(state pid started window listen_on kitty_window project transcript since pr root untold harness tools)

# The harness of agents told no other: the one spawning them, and the one of
# state files older than the harness field
default_harness=${AGENT_HARNESS:-claude}

# The scripts' directory (adapters find their assets there), and the adapters
agent_scripts=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
harnesses=()
for adapter in "$agent_scripts"/lib/harness/*.sh; do
  # shellcheck source=lib/harness/claude.sh
  . "$adapter"
  adapter=${adapter##*/}
  harnesses+=("${adapter%.sh}")
done
unset adapter

# Calls harness <harness>'s <what> (see the contract above); fails when it
# has none (an optional one: what needs it goes without)
# Usage: harness_do <harness> <what> [args...]
harness_do() {
  declare -F "$1_$2" >/dev/null || return 1
  "$1_$2" "${@:3}"
}

# Harness <harness>'s <label|icon|sound> (see the contract above): empty when
# it has none
# Usage: harness_brand <harness> <label|icon|sound>
harness_brand() {
  local var="$1_$2"
  [[ $var =~ ^[a-z0-9_]+$ ]] && echo "${!var}"
}

# Sets the fields of state file <file> as variables, each name prefixed with
# [prefix] (all empty when the file is missing)
# Usage: read_agent <file> [prefix]
read_agent() {
  local -a names=("${agent_fields[@]/#/$2}")
  local name
  for name in "${names[@]}"; do printf -v "$name" ''; done
  local harness_field="$2harness" # (not harness: with no prefix, that is a field)
  [ -f "$1" ] && read -r "${names[@]}" <"$1"
  [ -f "$1" ] && { [ -n "${!harness_field}" ] || printf -v "$harness_field" '%s' "$default_harness"; }
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

# The pull request an agent works on, by the prompt it started on (see
# first_prompt): agent-pr's agents open with "Fix <its URL>" or "Review <its
# URL>" (an agent merely mentioning one doesn't count). Prints
# <owner/repo>#<number>, or nothing
# Usage: agent_pr <harness> <transcript>
agent_pr() {
  local prompt
  prompt=$(harness_do "$1" first_prompt "$2") || return 0
  [[ $prompt =~ ^(Fix|Review)\ https://github\.com/([^/[:space:]]+/[^/[:space:]]+)/pull/([0-9]+) ]] &&
    echo "${BASH_REMATCH[2]}#${BASH_REMATCH[3]}"
  return 0
}

# The pull request agent-pr spawned the agent working in the worktree at
# <root> on (see AGENT_PR in agent-spawn), from the mark it leaves in its git
# dir. Prints <owner/repo>#<number>, or nothing
# Usage: worktree_pr <root>
worktree_pr() {
  local dir
  [ -n "$1" ] && [ "$1" != - ] || return 0
  dir=$(git -C "$1" rev-parse --absolute-git-dir 2>/dev/null) || return 0
  [ -f "$dir/agent-pr" ] && head -n 1 "$dir/agent-pr"
  return 0
}

# The pull request a session works on: the one its first prompt names (see
# agent_pr), else the one agent-pr spawned it on (see worktree_pr: with no
# prompt, or another), else the one of mine its branch is (see branch_pr).
# Prints <owner/repo>#<number>, or nothing
# Usage: session_pr <harness> <transcript> <root>
session_pr() {
  local pr
  pr=$(agent_pr "$1" "$2")
  [ -n "$pr" ] || pr=$(worktree_pr "$3")
  [ -n "$pr" ] || pr=$(branch_pr "$3")
  echo "$pr"
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

# A session's title (see title), cut to 90 characters; nothing when its
# harness tells none
# Usage: agent_title <harness> <transcript>
agent_title() { harness_do "$1" title "$2"; return 0; }

# An agent's name, for notifications: its project, then its pull request
# (<owner/repo>#<number>: #<number>) or its session's title
# Usage: agent_name <project> <pr or -> <harness> <transcript>
agent_name() {
  local name=$1 title
  if [ -n "$2" ] && [ "$2" != - ]; then
    name+=" #${2##*#}"
  else
    title=$(agent_title "$3" "$4")
    [ -n "$title" ] && name+=" · $title"
  fi
  echo "$name"
}

# A notification about an agent which, clicked, jumps to it (see
# agent-jump). One per agent: a newer one replaces it (its id kept in
# agent_notification <session>). Waiting for the click happens detached, so
# that hooks return at once, under its harness's icon. Needs $assets (the
# scripts' directory).
# Usage: agent_notify <session> <harness> <urgency> <title> <body>
agent_notification() { echo "$agents_dir/.$1.notification"; } # a dot file: no session's
agent_notify() {
  local id file
  file=$(agent_notification "$1")
  id=$(cat "$file" 2>/dev/null)
  # shellcheck disable=SC2016,SC2154 # $1..$8 belong to the inner sh; $assets: the caller's
  setsid -f sh -c '
    notify-send --app-name=agents ${8:+--icon="$8"} --urgency="$3" ${6:+--replace-id="$6"} \
      --action=default=Jump --print-id --wait "$4" "$5" | {
      read -r id && echo "$id" >"$7"
      read -r action && [ "$action" = default ] && exec "$1/agent-jump" "$2"
    }' sh "$assets" "$1" "$3" "$4" "$5" "$id" "$file" "$(harness_brand "$2" icon)" >/dev/null 2>&1
}

# A notification about agents in general (no session's), under the default
# harness's branding
# Usage: agents_notify <body>
agents_notify() {
  local icon
  icon=$(harness_brand "$default_harness" icon)
  notify-send --app-name=agents ${icon:+--icon="$icon"} "$(harness_brand "$default_harness" label)" "$1"
}

# A spawn's progress (see agent-pr and agent-spawn), in one
# notification shown at once, before the slow parts: each call replaces the
# previous one, its id kept in AGENT_NOTIFICATION (exported: a spawn
# started by agent-pr carries on with its notification). Its app name
# tells its state, which awesome colors (see its theme): blue when started,
# green when launched, red when failed (critical: it stays). Under the
# default harness's branding (the one spawning).
# Usage: spawn_notify <started|launched|failed> <body>
spawn_notify() {
  local id urgency=normal icon
  [ "$1" = failed ] && urgency=critical
  icon=$(harness_brand "$default_harness" icon)
  id=$(notify-send --app-name="agents.spawn.$1" ${icon:+--icon="$icon"} --urgency="$urgency" --print-id \
    ${AGENT_NOTIFICATION:+--replace-id="$AGENT_NOTIFICATION"} "$(harness_brand "$default_harness" label)" "$2" 2>/dev/null)
  [ -n "$id" ] && export AGENT_NOTIFICATION=$id
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

# Whether <pid> is a live session of harness <harness> (of any, without
# one; not a dead one's reused pid)
# Usage: alive <pid> [harness]
alive() {
  local harness
  if [ -n "$2" ]; then harness_do "$2" alive "$1"; return; fi
  for harness in "${harnesses[@]}"; do harness_do "$harness" alive "$1" && return 0; done
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

# Whether an agent's terminal is on screen (see agent-displayed); a
# background one's (no window of its own): one showing it (see terminals in
# the contract). Needs $assets
# Usage: agent_displayed <harness> <session> <transcript> <X window> <kitty socket> <kitty window>
agent_displayed() {
  local window socket id
  [ "$4" != - ] && { "$assets/agent-displayed" "$4" "$5" "$6"; return; }
  while read -r window socket id; do
    "$assets/agent-displayed" "$window" "$socket" "$id" && return 0
  done < <(harness_do "$1" terminals "$2" "$3")
  return 1
}

# How much an agent in each state wants me: attention, then done (to read),
# running and monitoring (working, its turn over, on what it left running),
# idle. For when several qualify (see pr_agent)
# shellcheck disable=SC2034 # for the scripts sourcing us
declare -A agent_wants=([attention]=4 [done]=3 [running]=2 [monitoring]=2 [idle]=1)

# The session of the agent working on pull request <owner/repo>#<number>
# (see agent-pr), the one wanting me the most when there are several;
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
  each_record pick < <("$assets/agent-list")
  echo "$best"
}

# Marks a pull request's spawn under way (see agent-pr), for another to tell
# it starting already, from its going ahead until its agent first tells its
# state on it (agent-state then drops the mark), its spawn fails, or 15
# minutes pass (a harness failing in its window, before any state). A dot
# file: no session's
# Usage: pr_spawning <owner/repo>#<number>  (prints the mark's path)
pr_spawning() { echo "$agents_dir/.spawning.${1/\//:}"; }

# Whether pull request <owner/repo>#<number>'s spawn is under way (see
# pr_spawning)
# Usage: pr_spawning_now <owner/repo>#<number>
pr_spawning_now() { [ -n "$(find "$(pr_spawning "$1")" -mmin -15 2>/dev/null)" ]; }

# The face of each state (mirrored in config/awesome/widgets/agents.lua)
# shellcheck disable=SC2034 # for the scripts sourcing us
declare -A agent_faces=([running]='󱚣' [monitoring]='󱚣' [done]='󱜙' [idle]='󱜙' [attention]='󱚟')
