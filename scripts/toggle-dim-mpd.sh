#!/bin/sh
target_app="Music Player Daemon"
dim_level="30%"
normal_level="75%"

function toggle_dim_volume {
  if [ "$2" = "$normal_level" ]; then
    pactl set-sink-input-volume "$1" "$dim_level"
  else
    pactl set-sink-input-volume "$1" "$normal_level"
  fi
}

pactl list sink-inputs | while read line; do
  _sink=$(echo "$line" | sed -rn 's/^Sink Input #(.*)/\1/p')
  if [ "$_sink" != '' ]; then sink=$_sink; fi

  _app=$(echo "$line" | sed -rn 's/application.name = "([^"]*)"/\1/p')
  if [ "$_app" != '' ]; then app=$_app; fi

  _volume=$(echo "$line" | sed -rn 's#Volume: front-left: .* / +([0-9]+%) / .* dB,.*front-right: .*#\1#p')
  if [ "$_volume" != '' ]; then volume=$_volume; fi

  if [ "$sink" != '' ] && [ "$app" = "$target_app" ] && [ "$volume" != '' ]; then
    toggle_dim_volume "$sink" "$volume"
    exit 0
  fi
done

exit 1
