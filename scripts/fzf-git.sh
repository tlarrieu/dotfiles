#!/usr/bin/bash

function heading {
  echo -e "---- $1 --------------------------------------------------------------------------------------------------------------------\n"
}

SHA=$(echo $1 | grep -o '[a-f0-9]\{7\}' | head -1)

if [ -z "$SHA" ]; then
  echo "Nothing to preview"
  exit
fi

COMMON=$(
  diff -u <(git rev-list --first-parent master) <(git rev-list --first-parent $SHA) |\
    sed -ne 's/^ //p' |\
    head -1
)

heading 'git lg'

git lg -n 20 --right-only $COMMON..$SHA

echo -e "\n\n"
heading "git show"

git sh --color -p --name-only $SHA
