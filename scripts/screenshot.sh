#!/bin/sh
output=$(flameshot gui 2>&1 | grep -o '/home/tlarrieu/Pictures/screenshots/.*.jpg')

if [ -n "$output" ]; then
  copy-file-to-clipboard "$output"
fi
