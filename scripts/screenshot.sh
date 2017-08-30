#!/bin/sh
filename="$HOME/Pictures/screenshots/$(date +'%Y%m%d%H%M').png"
maim -s | feh - --fullscreen --action "mv %F $filename"
