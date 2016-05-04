#!/bin/sh

fshow() {
  [ -d .git ] || exit
  local out shas sha q k
  while out=$(
      git log --color=always --graph \
          --format="%C(auto)%h%d %s %C(green)%C(bold)%cr" "$@" |
      fzf --ansi --exact --exit-0 --expect=ctrl-d --multi --no-sort \
          --print-query --prompt="glog: " --query="$q" --reverse
    ); do

    q=$(head -1 <<< "$out")
    k=$(head -2 <<< "$out" | tail -1)
    shas=$(sed '1,2d;s/^[^a-z0-9]*//;/^$/d' <<< "$out" | awk '{print $1}')

    [ -z "$shas" ] && continue

    if [ "$k" = ctrl-d ]; then
      git diff --color=always $shas.. | less -R
    else
      for sha in $shas; do
        git show --color=always $sha | less -R
      done
    fi
  done
}

fshow
