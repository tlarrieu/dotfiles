#!/bin/sh

current=$(gsettings get org.gnome.desktop.interface color-scheme | sed -E "s/'prefer-(\w+)'/\1/")

set_dark() {
  expr='s/dawnfox/nordfox/'
  gtk_expr='s/Nightfox-Light/Nordic/'
  fish_theme='nordfox'
  mode='dark'
  chrome_colors='46,52,64'
}

set_light() {
  expr='s/nordfox/dawnfox/'
  gtk_expr='s/Nordic/Nightfox-Light/'
  fish_theme='dawnfox'
  mode='light'
  chrome_colors='250,244,237'
}

if [ "$1" = "light" ]; then
  set_light
elif [ "$1" = "dark" ]; then
  set_dark
elif [ "$current" = "dark" ]; then
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
gsettings set org.gnome.desktop.interface color-scheme prefer-$mode

# chromium
chromium --no-startup-window --set-color-scheme=$mode --set-theme-color="$chrome_colors"

# wallpaper
[ -f ~/Pictures/wallpapers/wallpaper-$mode ] \
  && feh --bg-scale ~/Pictures/wallpapers/wallpaper-$mode \
  || [ -x ~/.fehbg ] && ~/.fehbg
