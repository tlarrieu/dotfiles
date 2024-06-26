#!/bin/sh

expr=''
gtk_expr=''
btop_theme=''
if grep 'light' ~/.Xresources.d/local > /dev/null; then
  expr='s/light/dark/'
  gtk_expr='s/Light/Dark/'
  btop_theme='dark'
else
  expr='s/dark/light/'
  gtk_expr='s/Dark/Light/'
  btop_theme='light'
fi

# Xresources
sed -e $expr -i ~/.Xresources.d/local
xrdb -merge ~/.Xresources

# gtk2
sed -e $gtk_expr -i ~/.gtkrc-2.0.mine

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
