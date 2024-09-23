#!/bin/sh

expr=''
btop_theme=''
gtk_expr=''

set_dark() {
  expr='s/light/dark/'
  btop_theme='dark'
  gtk_expr='s/Light/Dark/'
}

set_light() {
  expr='s/dark/light/'
  btop_theme='light'
  gtk_expr='s/Dark/Light/'
}

if [ "$1" = "light" ]; then
  set_light
elif [ "$1" = "dark" ]; then
  set_dark
elif grep 'dark' ~/.Xresources.d/local > /dev/null; then
  set_light
else
  set_dark
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

# GTK
sed -e $gtk_expr -i ~/.xsettingsd
xsettingsd 1>/dev/null 2>&1 &

# wallpaper
~/.fehbg
