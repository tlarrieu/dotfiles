#!/bin/sh
filename="$HOME/Pictures/screenshots/$(date +'%Y%m%d%H%M%S').jpg"
maim -s | feh - --class screenshot --action "mv %F $filename"
