#!/bin/sh
filename="$HOME/Pictures/Screenshots/$(date +'%Y%m%d%H%M').png"
scrot $filename --select --exec 'feh $f -F' --quality 100
