#!/bin/sh
filename="$HOME/Pictures/screenshots/$(date +'%Y%m%d%H%M').png"
scrot $filename --select --exec 'feh $f -F' --quality 100
