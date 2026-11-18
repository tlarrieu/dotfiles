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

# The clone of <owner/repo>: the one in ~/dev or ~/git whose origin it is
# (any remote URL form: git@github.com:owner/repo(.git),
# https://github.com/owner/repo(.git)). Prints its path, or fails.
# Usage: github_clone <owner/repo>
github_clone() {
  local dir origin
  for dir in ~/dev/*/ ~/git/*/; do
    origin=$(git -C "$dir" remote get-url origin 2>/dev/null) || continue
    origin=${origin%.git} origin=${origin%/}
    if [[ ${origin,,} == *[:/]"${1,,}" ]]; then
      echo "${dir%/}"
      return 0
    fi
  done
  return 1
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

# A notification which, clicked, opens <url>. Given one of my pull requests
# needing a fix, a second action: Fix with Claude (see claude-agent-pr: back
# to the agent already on it, else one fixing it). Waiting for that click
# happens detached, so that we don't hold our caller's output open (nor our
# lock)
# Usage: github_notify <app name> <urgency> <title> <body> <url> [<owner/repo> <number>]
github_notify() {
  local fix=()
  [ -n "$7" ] && fix=(--action=fix="Fix with Claude")
  # shellcheck disable=SC2016 # $1..$8 belong to the inner sh
  setsid -f sh -c 'app=$1 urgency=$2 title=$3 body=$4 url=$5 repo=$6 number=$7 assets=$8; shift 8
    case "$(notify-send --app-name="$app" --urgency="$urgency" --action=default=Open "$@" --wait "$title" "$body")" in
      default) exec browser-kiosk "$url" ;;
      fix) exec "$assets/claude-agent-pr" fix "$repo" "$number" ;;
    esac' sh "$1" "$2" "$3" "$4" "$5" "${6:--}" "${7:--}" "$(dirname "${BASH_SOURCE[0]}")/.." "${fix[@]}" >/dev/null 2>&1 9>&-
}

# A pull request's CI, from its last commit's checks: FAILURE when one fails,
# else PENDING when one runs (or is expected), else SUCCESS (no check too).
# Of each workflow, only its latest run counts, as on GitHub's pull request
# page: a newer one (marking it ready for review, say) cancels and replaces
# it, its cancelled checks are no failure. Commit statuses, and checks from
# other apps, all count.
# Some checks are left out (github_ignored_checks): the required reviewers
# one, failing until approvals come in, which the review state tells already;
# and the optional ones, whose failure doesn't block merging. So are the
# review workflows' (github_review_workflows, prefixes of their names): a bot
# reviewing the pull request is no CI, bot_reviewing tells it instead.
# Reads the checks themselves, 100 from each end of the list (counting them
# by state per workflow run instead costs GitHub more: it then refuses a
# search for more than a few pull requests). Past 200, those in the middle
# are missed.
# github_ci_query: the GraphQL selection to put in a PullRequest's fields
# github_ci_jq: jq definitions reading it from such a PullRequest: ci, and
# bot_reviewing (true while a review workflow's check runs), bot_review_failed
# (true when one failed, none running)
github_ignored_checks=(
  'Check required reviewers approvals'
  'Check CI breaking changes'
)
github_review_workflows=(
  'Claude Code Review'
)
github_ci_checks='nodes {
            ... on CheckRun { id name status conclusion checkSuite { workflowRun { createdAt workflow { databaseId name } } } }
            ... on StatusContext { id state }
          }'
# github_ci_rollup: the same, in a Commit's fields (a merge queue entry's
# merge group commit, say: ci reads it from {commits: {nodes: [{commit: …}]}})
# shellcheck disable=SC2034 # for the scripts sourcing this
github_ci_rollup="statusCheckRollup {
          head: contexts(first: 100) { $github_ci_checks }
          tail: contexts(last: 100) { $github_ci_checks }
        }"
# shellcheck disable=SC2034 # for the scripts sourcing this
github_ci_query="commits(last: 1) { nodes { commit { $github_ci_rollup } } }"
# shellcheck disable=SC2016,SC2034 # jq variables; for the scripts sourcing this
github_ci_jq='
  def latest_checks:
    ['"$(printf '"%s",' "${github_review_workflows[@]}" | sed 's/,$//')"'] as $reviewing
    | .commits.nodes[0].commit.statusCheckRollup as $rollup
    | ([$rollup.head.nodes[]?, $rollup.tail.nodes[]?] | unique_by(.id)) as $all
    | [$all[] | select(.status != null)] as $checks
    | ($checks | map(.checkSuite.workflowRun | select(.)) | group_by(.workflow.databaseId)
       | map({key: (.[0].workflow.databaseId | tostring), value: (map(.createdAt) | max)})
       | from_entries) as $newest
    | {checks: [$checks[]
               | .checkSuite.workflowRun as $run
               | select($run == null or $run.createdAt == $newest[$run.workflow.databaseId | tostring])
               | . + {review: ($run != null and ($run.workflow.name as $name
                                                 | any($reviewing[]; . as $prefix | $name | startswith($prefix))))}],
       statuses: [$all[] | select(.state != null)]};
  def failing_conclusions: ["FAILURE", "CANCELLED", "TIMED_OUT", "ACTION_REQUIRED", "STARTUP_FAILURE"];
  def bot_reviewing:
    any(latest_checks.checks[]; .review and .status != "COMPLETED");
  def bot_review_failed:
    failing_conclusions as $failing
    | latest_checks.checks as $checks
    | (any($checks[]; .review and .status != "COMPLETED") | not)
      and any($checks[]; .review and .status == "COMPLETED" and (.conclusion | IN($failing[])));
  def ci:
    failing_conclusions as $failing
    | ['"$(printf '"%s",' "${github_ignored_checks[@]}" | sed 's/,$//')"'] as $ignored
    | latest_checks as $latest
    | [$latest.checks[] | select((.review | not) and (.name | IN($ignored[]) | not))] as $counted
    | $latest.statuses as $statuses
    | (([$counted[] | select(.status == "COMPLETED" and (.conclusion | IN($failing[])))] | length)
       + ([$statuses[] | select(.state | IN("FAILURE", "ERROR"))] | length)) as $failed
    | (([$counted[] | select(.status != "COMPLETED")] | length)
       + ([$statuses[] | select(.state | IN("PENDING", "EXPECTED"))] | length)) as $pending
    | if $failed > 0 then "FAILURE" elif $pending > 0 then "PENDING" else "SUCCESS" end;
'

# Searches pull requests (<query>: as in GitHub's search box), fetching
# <selection> (a PullRequest's fields) for them, github_search_batch at a
# time: in one search, a heavy selection (the CI's checks) runs into GitHub's
# resource limits past 15 pull requests or so. The first batch comes with the
# search itself (the usual handful: one call); past it, the others are found
# by id, then fetched by batch. Prints what one search would have,
# {data: {viewer: {login}, search: {nodes}}}, in the search's order (the
# first 100). Fails when GitHub does (or can't be reached).
# Usage: github_search_prs <query> <selection>
github_search_batch=10
github_search_prs() {
  local first found answer i batch
  local -a ids answers=()
  # shellcheck disable=SC2016 # GraphQL variables
  first=$(timeout 60 gh api graphql -f q="$1" -f query='query($q: String!) {
    viewer { login }
    search(type: ISSUE, first: '"$github_search_batch"', query: $q) {
      issueCount
      nodes { ... on PullRequest { id '"$2"' } }
    }
  }' 2>/dev/null) || return 1
  if [ "$(jq '.data.search.issueCount' <<<"$first")" -gt "$github_search_batch" ]; then
    # shellcheck disable=SC2016 # GraphQL variables
    found=$(timeout 60 gh api graphql -f q="$1" -f query='query($q: String!) {
      search(type: ISSUE, first: 100, query: $q) { nodes { ... on PullRequest { id } } }
    }' 2>/dev/null) || return 1
    mapfile -t ids < <(jq -r --argjson skip "$github_search_batch" '.data.search.nodes[$skip:][].id // empty' <<<"$found")
    for ((i = 0; i < ${#ids[@]}; i += github_search_batch)); do
      batch=$(printf '"%s", ' "${ids[@]:i:github_search_batch}")
      answer=$(timeout 60 gh api graphql -f query="query { nodes(ids: [${batch%, }]) { ... on PullRequest { id $2 } } }" 2>/dev/null) || return 1
      answers+=("$answer")
    done
  fi
  # Each once, should the search have changed in between
  printf '%s\n' "$first" "${answers[@]}" | jq -sc '
    {data: {viewer: .[0].data.viewer,
            search: {nodes: ([.[0].data.search.nodes[], (.[1:][].data.nodes[])]
                             | reduce .[] as $n ([]; if any(.[]; .id == $n.id) then . else . + [$n] end))}}}'
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
