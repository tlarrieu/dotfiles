#!/bin/sh

expr=''
gtk_expr=''
fish_theme=''

set_dark() {
  expr='s/dawnfox/nordfox/'
  gtk_expr='s/Light/Dark/'
  fish_theme='nordfox'
}

set_light() {
  expr='s/nordfox/dawnfox/'
  gtk_expr='s/Dark/Light/'
  fish_theme='dawnfox'
}

if [ "$1" = "light" ]; then
  set_light
elif [ "$1" = "dark" ]; then
  set_dark
elif grep 'nordfox' ~/.Xresources.d/local > /dev/null; then
  set_light
else
  set_dark
fi

# Xresources
sed -e $expr -i ~/.Xresources.d/local
xrdb -merge ~/.Xresources

# nvim
pkill --signal USR1 nvim || /bin/true

# kitty
sed -e $expr -i ~/.config/kitty/theme.conf
pkill --signal USR1 kitty || /bin/true

# fish
echo 'y' | fish -c "fish_config theme save $fish_theme"

# rofi
sed -e $expr -i ~/.config/rofi/variant.rasi

# awesome
awesome-client > /dev/null 2>&1 <<- LUA
  require('theme').config()
  require('panel').reset()
LUA

# GTK
sed -e $gtk_expr -i ~/.xsettingsd
xsettingsd 1>/dev/null 2>&1 &

# wallpaper
[ -x ~/.fehbg ] && ~/.fehbg
