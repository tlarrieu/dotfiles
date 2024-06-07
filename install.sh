#!/bin/sh

safeinstall() {
  package=$*

  if type yay > /dev/null; then
    # shellcheck disable=SC2086 # we actually went to use word splitting here
    yay -S --color always --needed --noconfirm $package
  else
    # shellcheck disable=SC2086 # we actually went to use word splitting here
    sudo pacman -S --color always --needed --noconfirm $package
  fi
}

BASEDIR=$(cd "$(dirname "$0")" || exit; pwd)

# -- [[ Linking ]] -------------------------------------------------------------
echo "Linking configuration files..."
# .config directories
mkdir -p ~/.config
for file in "$BASEDIR"/config/*; do
  target=$BASEDIR/config/$(basename "$file")
  link=~/.config/$(basename "$file")
  ln -sfFT "$target" "$link"
done

# .local directories
mkdir -p ~/.local/share/applications
for file in "$BASEDIR"/local/share/applications/*; do
  target=$BASEDIR/local/share/applications/$(basename "$file")
  link=~/.local/share/applications/$(basename "$file")
  ln -sfFT "$target" "$link"
done

# gtk2
ln -sfFT "$BASEDIR"/gtkrc-2.0 "$HOME"/.gtkrc-2.0

# nvim
ln -sfFT "$BASEDIR"/nvim "$HOME"/.config/nvim

# vifm
ln -sfFT "$BASEDIR"/vifm "$HOME"/.vifm

# Bash
ln -sfFT "$BASEDIR"/bashrc "$HOME"/.bashrc

# browser-profile
ln -sfFT "$BASEDIR"/browser-config "$HOME"/.browser-config

# .gitconfig & .gitignore
ln -sfFT "$BASEDIR"/gitconfig "$HOME"/.gitconfig
ln -sfFT "$BASEDIR"/gitignore "$HOME"/.gitignore
git config --global core.excludesFile ~/.gitignore

# agignore
ln -sfFT "$BASEDIR"/agignore "$HOME"/.agignore

# irbrc
ln -sfFT "$BASEDIR"/irbrc "$HOME"/.irbrc

# rubocop
ln -sfFT "$BASEDIR"/rubocop.yml "$HOME"/.rubocop.yml

# tslint
ln -sfFT "$BASEDIR"/tslint.json "$HOME"/tslint.json

# newboat
ln -sfFT "$BASEDIR"/newsboat "$HOME"/.newsboat

# scripts
mkdir -p "$HOME"/scripts
for file in "$BASEDIR"/scripts/*; do
  target="$BASEDIR"/scripts/$(basename "$file")
  link=~/scripts/$(basename "$file")
  ln -sfFT "$target" "$link"
done

# apps
ln -sfFT "$BASEDIR"/apps "$HOME"/apps

# ncpamixer
ln -sfFT "$BASEDIR"/ncpamixer.conf "$HOME"/.ncpamixer.conf

# xprofile
ln -sfFT "$BASEDIR"/xprofile "$HOME"/.xprofile

# xresources
ln -sfFT "$BASEDIR"/xresources "$HOME"/.Xresources
mkdir -p "$HOME"/.Xresources.d
for file in "$BASEDIR"/xresources.d/*; do
  target="$BASEDIR"/xresources.d/$(basename "$file")
  link=~/.Xresources.d/$(basename "$file")
  ln -sfFT "$target" "$link"
done
[ -f ~/.Xresources.d/local ] || \
  cp ~/.Xresources.d/local.sample ~/.Xresources.d/local

# kitty colors
[ -f ~/.config/kitty/theme.conf ] || \
  cp "$BASEDIR"/config/kitty/theme.conf.sample ~/.config/kitty/theme.conf

# rofi colors
[ -f ~/.config/rofi/variant.rasi ] || \
  cp "$BASEDIR"/config/rofi/variant.rasi.sample ~/.config/rofi/variant.rasi

# Xmodmap
ln -sfFT "$BASEDIR"/xmodmap.lavie-hz750c "$HOME"/.Xmodmap

# dircolors
ln -sfFT "$BASEDIR"/dir_colors "$HOME"/.dir_colors

# less
ln -sfFT "$BASEDIR"/lesskey "$HOME"/.lesskey

# GHCi
ln -sfFT "$BASEDIR"/ghci "$HOME"/.ghci

# Taskwarrior
ln -sfFT "$BASEDIR"/taskrc "$HOME"/.taskrc

# Routines
ln -sfFT "$BASEDIR"/routines "$HOME"/.routines

# X11
for file in "$BASEDIR"/xorg.conf.d/*; do
  target="$BASEDIR"/xorg.conf.d/$(basename "$file")
  link=/etc/X11/xorg.conf.d/$(basename "$file")
  sudo ln -sfFT "$target" "$link"
done

echo "$(tput setaf 2)Done.$(tput sgr0)"

# -- [[ Package / plugins installation ]] --------------------------------------
# Core pacakages (maybe we should make a meta package or something)
printf "Do you want to check packages? ([y]es/[N]o) "

read -r answer
case $answer in
  "yes"|"y")
    safeinstall yay

    build_tools="fakeroot binutils base-devel"

    nvim="neovim-git"

    languages="luarocks rbenv ruby-build go go-tools gofumpt opam"

    terminal="kitty fish"

    admin="htop-vim net-tools dnsutils ncdu"

    utils="xdotool entr xsel"

    search="ripgrep mlocate"

    files="vifm
      xdg-utils
      udiskie
      nemo
      atool
      eza
      tumbler
      tumbler-extra-thumbnailers
      ffmpegthumbnailer
      "

    essential="git fzf rofi pass ruby"

    taskwarrior="task taskopen"

    xorg="xorg-xrdb
      xorg-server-xephyr
      xorg-xwininfo
      xorg-xrandr
      xorg-xinput
      xorg-xmodmap"

    display_manager="lightdm"

    window_manager="awesome
      i3lock-color
      picom
      wmctrl
      maim
      unclutter
      redshift
      "

    gtk="lxappearance-gtk3
      xcursor-breeze
      gtk-theme-numix-solarized
      "

    multimedia="
      manjaro-pulse pulsemixer
      mpc mpd mpv
      yt-dlp
      sxiv feh
      viewnior
      imagemagick
      aria2
      "

    gaming="
    nvidia-utils
    libglvnd
    opencl-nvidia
    lib32-nvidia-utils
    lib32-libglvnd
    lib32-opencl-nvidia
    "

    internet="networkmanager chromium openssh"

    keyboard="xcape"

    writing="zathura zathura-djvu zathura-pdf-mupdf zathura-ps pandoc"

    bluetooth="bluez bluez-utils pulseaudio-bluetooth"

    fonts="ttf-firacode-nerd
      ttf-consolas-ligaturized
      terminus-font
      "

    safeinstall "$build_tools" \
      "$nvim" \
      "$languages" \
      "$terminal" \
      "$admin" \
      "$utils" \
      "$search" \
      "$files" \
      "$essential" \
      "$taskwarrior" \
      "$xorg" \
      "$display_manager" \
      "$window_manager" \
      "$gtk" \
      "$multimedia" \
      "$gaming" \
      "$internet" \
      "$keyboard" \
      "$writing" \
      "$bluetooth" \
      "$fonts"

    gem install dotenv
    echo "$(tput setaf 2)All dependencies are up to date$(tput sgr0)"
    ;;
  *)
    echo "$(tput setaf 3)Packages update skipped$(tput sgr0)"
    ;;
esac

printf "Do you want to configure services? ([y]es/[N]o) "

read -r answer
case $answer in
  "yes"|"y")
    echo "$(tput setaf 3)Enabling lightdm...$(tput sgr0)"
    sudo systemctl enable lightdm
    echo "$(tput setaf 2)Done.$(tput sgr0)"
    echo "$(tput setaf 3)Enabling NetworkManager$(tput sgr0)"
    sudo systemctl enable NetworkManager
    echo "$(tput setaf 2)Done.$(tput sgr0)"
    echo "$(tput setaf 3)Enabling mpd (for current user)$(tput sgr0)"
    mkdir ~/.local/share/mpd 2> /dev/null
    systemctl enable mpd --user
    echo "$(tput setaf 2)Done.$(tput sgr0)"
    echo "$(tput setaf 3)Activating NTP server$(tput sgr0)"
    sudo timedatectl set-ntp true
    echo "$(tput setaf 2)Done.$(tput sgr0)"
    echo "$(tput setaf 2)Services successfully configured !$(tput sgr0)"
    ;;
  *)
    echo "$(tput setaf 3)Services configuration skipped$(tput sgr0)"
    ;;
esac

# LightDM
printf "Do you want to set your shell to fish? ([y]es/[N]o) "

read -r answer
case $answer in
  "yes"|"y")
    chsh -s /usr/bin/fish
    echo "$(tput setaf 2)shell configured!$(tput sgr0)"
    ;;
  *)
    echo "$(tput setaf 3)shell configuration skipped$(tput sgr0)"
    ;;
esac

echo
echo "Configuring neovim..."

echo "$(tput setaf 3)Syncing plugins...$(tput sgr0)"
nvim --headless "+Lazy! sync" +qa
echo "$(tput setaf 2)Done.$(tput sgr0)"

# Neorg notes
if [ -d ~/.neorg ]; then
  echo "$(tput setaf 2)Notes already cloned. Nothing to do!$(tput sgr0)"
else
  echo "$(tput setaf 3)Getting notes...$(tput sgr0)"
  git clone git@github.com:tlarrieu/notes.git ~/.neorg
  echo "$(tput setaf 2)Done.$(tput sgr0)"
fi
