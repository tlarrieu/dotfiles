#!/bin/sh
output=$(flameshot "$1" 2>&1 | grep -o '/home/tlarrieu/Pictures/screenshots/.*.jpg')

# Flameshot's overlay grabs the input focus, which then sometimes falls back to
# the root window once it closes, while awesome still deems the client under it
# focused. Focusing it anew hands it the input focus back.
awesome-client "
  local awful = require('awful')
  local c = client.focus or awful.client.focus.history.get(awful.screen.focused(), 0)
  if c and c.valid then
    client.focus = nil
    client.focus = c
  end
" >/dev/null 2>&1

if [ -n "$output" ]; then
  copy-file-to-clipboard "$output"
fi
