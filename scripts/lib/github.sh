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
# The required reviewers check is left out: it fails until approvals come in,
# which the review state tells already.
# github_ci_query: the GraphQL selection to put in a PullRequest's fields
# github_ci_jq: a jq definition, ci, reading it from such a PullRequest
github_ignored_check='Check required reviewers approvals'
# shellcheck disable=SC2034 # for the scripts sourcing this
github_ci_query="commits(last: 1) { nodes { commit {
          statusCheckRollup { contexts { checkRunCountsByState { state count } statusContextCountsByState { state count } } }
          checkSuites(first: 50) { nodes { checkRuns(first: 5, filterBy: {checkName: \"$github_ignored_check\"}) { nodes { status conclusion } } } }
        } } }"
# shellcheck disable=SC2016,SC2034 # jq variables; for the scripts sourcing this
github_ci_jq='
  def ci:
    .commits.nodes[0].commit as $commit
    | ["FAILURE", "ERROR", "CANCELLED", "TIMED_OUT", "ACTION_REQUIRED", "STARTUP_FAILURE"] as $failing
    | ["PENDING", "EXPECTED", "QUEUED", "IN_PROGRESS", "WAITING", "REQUESTED"] as $running
    | ($commit.statusCheckRollup.contexts // {}) as $contexts
    | [$contexts.checkRunCountsByState[]?, $contexts.statusContextCountsByState[]?] as $counts
    | [$commit.checkSuites.nodes[]?.checkRuns.nodes[]] as $ignored
    | (([$counts[] | select(.state | IN($failing[])) | .count] | add // 0)
       - ([$ignored[] | select(.status == "COMPLETED" and (.conclusion | IN($failing[])))] | length)) as $failed
    | (([$counts[] | select(.state | IN($running[])) | .count] | add // 0)
       - ([$ignored[] | select(.status != "COMPLETED")] | length)) as $pending
    | if $failed > 0 then "FAILURE" elif $pending > 0 then "PENDING" else "SUCCESS" end;
'

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
