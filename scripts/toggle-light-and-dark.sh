#!/bin/sh

expr=''
btop_theme=''
if grep 'light' ~/.Xresources.d/local > /dev/null; then
  expr='s/light/dark/'
  btop_theme='dark'
else
  expr='s/dark/light/'
  btop_theme='light'
fi

# Xresources
sed -e $expr -i ~/.Xresources.d/local
xrdb -merge ~/.Xresources

# nvim
pkill --signal USR1 nvim

# kitty
sed -e $expr -i ~/.config/kitty/theme.conf
pkill --signal USR1 kitty

# rofi
sed -e $expr -i ~/.config/rofi/variant.rasi

# btop
cp ~/.config/btop/themes/"$btop_theme".theme ~/.config/btop/themes/current.theme

# awesome
awesome-client <<- LUA
  require('theme').config()
  for s in screen do require('panel').init(s) end
LUA

# wallpaper
~/.fehbg
