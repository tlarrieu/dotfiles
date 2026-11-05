# shellcheck shell=bash
# Records: what the GitHub trackers and claude-agent-list print. Tab
# separated lines under a header naming their fields: "#<field>\t<field>…".
# Readers go by name, so adding a field only touches the script printing them.
# Source it: . "$assets/lib/records.sh" (see config/awesome/records.lua for
# the panel's reader)

# Runs <function> for each record read on stdin, with its fields set as
# variables named after the header. Lines before the header and lines with
# no tab (failure messages) are skipped.
# Usage: each_record <function> <<<"$output"
each_record() {
  local header line
  local -a fields
  while IFS= read -r header; do [[ $header == '#'* ]] && break; done
  [[ $header == '#'* ]] || return 0
  IFS=$'\t' read -r -a fields <<<"${header#\#}"
  while IFS= read -r line; do
    [[ $line == *$'\t'* ]] || continue
    IFS=$'\t' read -r "${fields[@]}" <<<"$line"
    "$1"
  done
}
