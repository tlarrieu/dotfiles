#!/bin/sh
filename="$HOME/Pictures/screenshots/$(date +'%Y%m%d%H%M%S').png"
maim -s | feh - --class screenshot --action "mv %F $filename"
