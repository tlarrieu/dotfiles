#!/bin/sh

envfile="$HOME/.chromium.env"
[ -f "$envfile" ] && source "$envfile"

profile=${CHROMIUM_PERSONAL:-"Default"}

chromium --app="https://www.exercism.io" --profile-directory="$profile"
