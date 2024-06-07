#!/bin/sh

expr=''
if grep 'light' ~/.Xresources.d/local > /dev/null; then
  expr='s/light/dark/'
else
  expr='s/dark/light/'
fi

# xresources
sed -e $expr -i ~/.Xresources.d/local
xrdb -merge ~/.Xresources

# nvim
pkill --signal USR1 nvim

# kitty
sed -e $expr -i ~/.config/kitty/theme.conf
pkill --signal USR1 kitty

# rofi
sed -e $expr -i ~/.config/rofi/variant.rasi

# awesome
awesome-client "awesome.restart()"

# wallpaper
./.fehbg
