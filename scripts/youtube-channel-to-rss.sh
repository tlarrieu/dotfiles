#!/bin/sh

curl -s https://www.youtube.com/"$1" |\
  grep -z -o 'https://www.youtube.com/feeds/videos.xml?channel_id=........................' |\
  head -z -n 1
echo " # $1"
