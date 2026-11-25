# shellcheck shell=bash
# A fake harness (see the contract in lib/agents.sh, which sources us): its
# agent, harness/fake-agent, answers each prompt by echoing it. To check that
# the agent scripts need nothing Claude's (harness/fake-test drives it through
# them), and as the smallest adapter to start a real one from: only what the
# contract requires, and the transcript readers. No background sessions,
# interrupts, handovers, busy turns, nor branding: what needs them goes
# without. Tools, for its permissions (see fake-agent).
# Its transcripts: JSON lines, {"kind": "prompt", "said" or "title", "text"}.

# shellcheck disable=SC2034 # read through harness_brand
fake_label=Fake

# Whether <pid> is a fake agent: bash running harness/fake-agent (by its
# command line: its process goes by bash's name)
# Usage: fake_alive <pid>
fake_alive() {
  case "$1" in "" | *[!0-9]*) return 1 ;; esac
  local argv=()
  mapfile -d '' -n 2 argv 2>/dev/null <"/proc/$1/cmdline"
  [[ ${argv[0]} == *bash && ${argv[1]} == */harness/fake-agent ]]
}

# The tools fake agent <pid> runs: its sleeps (see fake-agent), one pid a
# line
# Usage: fake_tools <pid>
fake_tools() {
  local child children=() more comm
  for child in /proc/"$1"/task/*/children; do
    more=()
    read -ra more 2>/dev/null <"$child"
    children+=("${more[@]}")
  done
  for child in "${children[@]}"; do
    read -r comm 2>/dev/null <"/proc/$child/comm" && [ "$comm" = sleep ] && echo "$child"
  done
  return 0
}

# The fish command running a fake agent (see launch in lib/agents.sh)
# Usage: fake_launch [--prompt] [--context]
fake_launch() {
  # shellcheck disable=SC2154 # agent_scripts: lib/agents.sh's
  local command="$agent_scripts/harness/fake-agent" arg prompt=''
  for arg; do
    case $arg in
      --context) command+=" --context \$context" ;;
      --prompt) prompt=yes ;;
    esac
  done
  [ -n "$prompt" ] && command+=" -- \$prompt"
  echo "$command"
}

# The last of <kind>'s texts in transcript <transcript> (one line each:
# titles and words said hold no line break)
# Usage: fake_read <transcript> <kind>
fake_read() {
  [ -f "$1" ] || return 0
  jq -r --arg kind "$2" 'select(.kind == $kind) | .text' "$1" 2>/dev/null | tail -n 1
}

# Usage: fake_title <transcript>
fake_title() { fake_read "$1" title; }
# Usage: fake_last_words <transcript>
fake_last_words() { fake_read "$1" said; }
# Usage: fake_first_prompt <transcript>
fake_first_prompt() {
  [ -f "$1" ] || return 0
  jq -nr 'first(inputs | select(.kind == "prompt") | .text)' "$1" 2>/dev/null
}
