# shellcheck shell=bash
# Shared by the GitHub trackers (review-queue, merge-queue) and their picker
# (rofi-github). Source it: . "$assets/lib/github.sh"
#
# Tracker outputs are records (see records.sh): readers go by field name, so
# the tracker printing them is the only place their order lives.

# shellcheck source-path=SCRIPTDIR source=records.sh
. "$(dirname "${BASH_SOURCE[0]}")/records.sh"

github_config="${XDG_CONFIG_HOME:-$HOME/.config}/github/repos"

# The repositories to watch, as search qualifiers ("repo:owner/name …"), in
# $repos. Without any: complains on stderr, notifies once (until fixed, see
# <state dir>/.misconfigured) and exits 2.
# Usage: github_repos <script name> <app name> <notification title> <state dir>
github_repos() {
  local script=$1 app=$2 title=$3 dir=$4 reason message
  repos=$(grep -vE '^\s*(#|$)' "$github_config" 2>/dev/null | sed 's/^/repo:/' | tr '\n' ' ')
  if [ -n "$repos" ]; then
    rm -f "$dir/.misconfigured"
    return
  fi
  reason="$github_config is missing"
  [ -f "$github_config" ] && reason="$github_config lists no repository"
  message="$reason: list the repositories to watch there, one owner/repo per line"
  echo "$script: $message" >&2
  if [ ! -f "$dir/.misconfigured" ]; then
    touch "$dir/.misconfigured"
    notify-send --app-name="$app" --urgency=critical "$title" "$message"
  fi
  exit 2
}

# One refresh at a time, so that timer runs and clicked ones don't notify
# twice. One already running? Wait for it, a bounded time (gh calls time out):
# a stalled GitHub can't pile runs up, and a clicked refresh still reports
# what GitHub said. Past that, print the (stale) cache and exit 1, as when
# GitHub can't be reached. Holds fd 9 (see github_notify).
# Usage: github_lock <state dir> <cache>
github_lock() {
  exec 9>"$1/.lock"
  flock -w 90 9 || { cat "$2"; exit 1; }
}

# A notification which, clicked, opens <url>. Waiting for that click happens
# detached, so that we don't hold our caller's output open (nor our lock)
# Usage: github_notify <app name> <urgency> <title> <body> <url>
github_notify() {
  # shellcheck disable=SC2016 # $1..$5 belong to the inner sh
  setsid -f sh -c '[ "$(notify-send --app-name="$1" --urgency="$2" --action=default=Open --wait "$3" "$4")" = default ] && exec browser-kiosk "$5"' sh "$@" >/dev/null 2>&1 9>&-
}

# A pull request's CI, from its last commit's checks: FAILURE when one fails,
# else PENDING when one runs (or is expected), else SUCCESS (no check too).
# Of each workflow, only its latest run counts, as on GitHub's pull request
# page: a newer one (marking it ready for review, say) cancels and replaces
# it, its cancelled checks are no failure. Commit statuses, and checks from
# other apps, all count.
# The required reviewers check is left out: it fails until approvals come in,
# which the review state tells already.
# Reads the checks themselves, 100 from each end of the list (counting them
# by state per workflow run instead costs GitHub more: it then refuses a
# search for more than a few pull requests). Past 200, those in the middle
# are missed.
# github_ci_query: the GraphQL selection to put in a PullRequest's fields
# github_ci_jq: a jq definition, ci, reading it from such a PullRequest
github_ignored_check='Check required reviewers approvals'
github_ci_checks='nodes {
            ... on CheckRun { id name status conclusion checkSuite { workflowRun { createdAt workflow { databaseId } } } }
            ... on StatusContext { id state }
          }'
# shellcheck disable=SC2034 # for the scripts sourcing this
github_ci_query="commits(last: 1) { nodes { commit { statusCheckRollup {
          head: contexts(first: 100) { $github_ci_checks }
          tail: contexts(last: 100) { $github_ci_checks }
        } } } }"
# shellcheck disable=SC2016,SC2034 # jq variables; for the scripts sourcing this
github_ci_jq='
  def ci:
    .commits.nodes[0].commit.statusCheckRollup as $rollup
    | ["FAILURE", "CANCELLED", "TIMED_OUT", "ACTION_REQUIRED", "STARTUP_FAILURE"] as $failing
    | ([$rollup.head.nodes[]?, $rollup.tail.nodes[]?] | unique_by(.id)) as $all
    | [$all[] | select(.status != null)] as $checks
    | [$all[] | select(.state != null)] as $statuses
    | ($checks | map(.checkSuite.workflowRun | select(.)) | group_by(.workflow.databaseId)
       | map({key: (.[0].workflow.databaseId | tostring), value: (map(.createdAt) | max)})
       | from_entries) as $newest
    | [$checks[]
       | select(.name != "'"$github_ignored_check"'")
       | .checkSuite.workflowRun as $run
       | select($run == null or $run.createdAt == $newest[$run.workflow.databaseId | tostring])] as $counted
    | (([$counted[] | select(.status == "COMPLETED" and (.conclusion | IN($failing[])))] | length)
       + ([$statuses[] | select(.state | IN("FAILURE", "ERROR"))] | length)) as $failed
    | (([$counted[] | select(.status != "COMPLETED")] | length)
       + ([$statuses[] | select(.state | IN("PENDING", "EXPECTED"))] | length)) as $pending
    | if $failed > 0 then "FAILURE" elif $pending > 0 then "PENDING" else "SUCCESS" end;
'

# Searches pull requests (<query>: as in GitHub's search box), then fetches
# <selection> (a PullRequest's fields) for them, github_search_batch at a
# time: in one search, a heavy selection (the CI's checks) runs into GitHub's
# resource limits past 15 pull requests or so. Prints what one search would
# have, {data: {viewer: {login}, search: {nodes}}}, in the search's order
# (the first 100). Fails when GitHub does (or can't be reached).
# Usage: github_search_prs <query> <selection>
github_search_batch=10
github_search_prs() {
  local found answer i batch
  local -a ids answers=()
  # shellcheck disable=SC2016 # GraphQL variables
  found=$(timeout 60 gh api graphql -f q="$1" -f query='query($q: String!) {
    viewer { login }
    search(type: ISSUE, first: 100, query: $q) { nodes { ... on PullRequest { id } } }
  }' 2>/dev/null) || return 1
  mapfile -t ids < <(jq -r '.data.search.nodes[].id // empty' <<<"$found")
  for ((i = 0; i < ${#ids[@]}; i += github_search_batch)); do
    batch=$(printf '"%s", ' "${ids[@]:i:github_search_batch}")
    answer=$(timeout 60 gh api graphql -f query="query { nodes(ids: [${batch%, }]) { ... on PullRequest { $2 } } }" 2>/dev/null) || return 1
    answers+=("$answer")
  done
  printf '%s\n' "$found" "${answers[@]}" |
    jq -sc '{data: {viewer: .[0].data.viewer, search: {nodes: [.[1:][].data.nodes[]]}}}'
}

# Time since something: 42m, 5h, 1d3h (see config/awesome/github.lua, which
# mirrors it)
ago() {
  if [ "$1" -lt 3600 ]; then echo "$(($1 / 60))m"
  elif [ "$1" -lt 86400 ]; then echo "$(($1 / 3600))h"
  else echo "$(($1 / 86400))d$(($1 % 86400 / 3600))h"; fi
}

# Time left: 4m, 1h26 (minutes rounded up, never "60m"; mirrored in
# config/awesome/github.lua too)
eta() {
  local minutes=$((($1 + 59) / 60))
  if [ "$minutes" -lt 60 ]; then echo "${minutes}m"
  else printf '%dh%02d\n' $((minutes / 60)) $((minutes % 60)); fi
}
