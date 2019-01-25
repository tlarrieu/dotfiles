#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true
SKIP=false

safelink()
{
  $SKIP && return

  target=$1
  link=$2

  if [ $FORCE ]; then
    DO_LINK=true
  else
    if [ -d $link -o -f $link ]; then
      DO_LINK=false

      echo "$(tput setaf 3)'$link' already exists, do you want to replace" \
        "it?$(tput sgr0) ([y]es/[N]o/[a]ll/[s]kip)"
      echo -n "=> "

      read answer
      case $answer in
        "yes"|"y")
          DO_LINK=true
          ;;
        "all"|"a")
          FORCE=true
          DO_LINK=true
          ;;
        "skip"|"s")
          SKIP=true
          return
          ;;
        *)
          DO_LINK=false
          ;;
      esac
    else
      DO_LINK=true
    fi
  fi

  $DO_LINK && ln -sfFT $target $link
}

safeinstall() {
  package=$1

  if type yay > /dev/null; then
    yay -S --needed --noconfirm $package
  else
    sudo pacman -S --needed --noconfirm $package
  fi
}

BASEDIR=$(cd "$(dirname "$0")"; pwd)

# -- [[ Linking ]] -------------------------------------------------------------
echo "Linking configuration files..."
# .config directories
[[ -d ~/.config ]] || mkdir ~/.config
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# nvim
safelink $BASEDIR/nvim $HOME/.config/nvim

# vifm
safelink $BASEDIR/vifm $HOME/.vifm

# Gnuplot
safelink $BASEDIR/gnuplot $HOME/gnuplot

# Bash
safelink $BASEDIR/bashrc $HOME/.bashrc

# weechat
safelink $BASEDIR/weechat $HOME/.weechat

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore
git config --global core.excludesFile ~/.gitignore

# agignore
safelink $BASEDIR/agignore $HOME/.agignore

# irbrc
safelink $BASEDIR/irbrc $HOME/.irbrc

# rubocop
safelink $BASEDIR/rubocop.yml $HOME/.rubocop.yml

# scripts
mkdir -p $HOME/scripts
for file in `ls -d $BASEDIR/scripts/*`; do
  target=$BASEDIR/scripts/`basename $file`
  link=~/scripts/`basename $file`
  safelink $target $link
done

# apps
safelink $BASEDIR/apps $HOME/apps

# asoundrc
safelink $BASEDIR/asoundrc $HOME/.asoundrc

# xprofile
safelink $BASEDIR/xprofile $HOME/.xprofile

# xresources
safelink $BASEDIR/xresources $HOME/.Xresources
mkdir -p $HOME/.Xresources.d
for file in `ls -d $BASEDIR/xresources.d/*`; do
  target=$BASEDIR/xresources.d/`basename $file`
  link=~/.Xresources.d/`basename $file`
  safelink $target $link
done
[ -f ~/.Xresources.d/local ] || \
  cp ~/.Xresources.d/local.sample ~/.Xresources.d/local

# Xmodmap
safelink $BASEDIR/xmodmap.lavie-hz750c $HOME/.Xmodmap

# dircolors
safelink $BASEDIR/dir_colors $HOME/.dir_colors

# linopen
safelink $BASEDIR/linopenrc $HOME/.linopenrc

if [ ! $SKIP ]; then
  echo "$(tput setaf 2)Done.$(tput sgr0)"
fi

# -- [[ Package / plugins installation ]] --------------------------------------
# Core pacakages (maybe we should make a meta package or something)
echo
echo -n "Do you want to check packages? ([y]es/[N]o) "

read answer
case $answer in
  "yes"|"y")
    safeinstall yay

    safeinstall python
    safeinstall python-pip
    safeinstall neovim
    sudo pip install neovim

    safeinstall vifm
    safeinstall udiskie

    safeinstall xorg-server
    safeinstall xorg-xrdb
    safeinstall lightdm
    safeinstall awesome
    safeinstall unclutter
    safeinstall redshift

    safeinstall luakit
    safeinstall chromium

    safeinstall net-tools
    safeinstall dnsutils

    safeinstall fzf
    safeinstall the_silver_searcher
    safeinstall atool

    safeinstall i3lock-custom

    safeinstall linopen
    safeinstall xcape

    safeinstall rofi
    safeinstall maim
    safeinstall feh
    safeinstall sxiv

    safeinstall zathura
    safeinstall zathura-djvu
    safeinstall zathura-pdf-mupdf
    safeinstall zathura-ps

    safeinstall entr
    safeinstall pandoc
    safeinstall xdotools

    safeinstall imagemagick

    safeinstall mpc
    safeinstall mpd
    safeinstall mpv
    safeinstall youtube-dl

    safeinstall fish
    safeinstall kitty

    # desktop font
    safeinstall nerd-fonts-inconsolata
    # coding font
    safeinstall otf-fira-code
    # presentation font
    safeinstall ephifonts
    echo "$(tput setaf 2)All dependencies are up to date$(tput sgr0)"
    ;;
  *)
    echo "$(tput setaf 3)Packages update skipped$(tput sgr0)"
    ;;
esac

echo
echo "Configuring neovim..."

# vim-plug
if [[ -f ~/.config/nvim/autoload/plug.vim ]]; then
  echo "$(tput setaf 2)vim-plug already installed. Nothing to do!$(tput sgr0)"
else
  echo "$(tput setaf 3)Installing vim-plug...$(tput sgr0)"
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  echo "$(tput setaf 2)Done.$(tput sgr0)"
  echo "$(tput setaf 3)Installing plugins...$(tput sgr0)"
  nvim +PlugInstall +qall
  echo "$(tput setaf 2)Done.$(tput sgr0)"
fi

# Remote plugins
if [[ -f ~/.local/share/nvim/rplugin.vim ]]; then
  echo "$(tput setaf 2)Remote plugins up to date. Nothing to do!$(tput sgr0)"
else
  echo "$(tput setaf 3)Updating remote plugins...$(tput sgr0)"
  nvim +UpdateRemotePlugins +qall
  echo "$(tput setaf 2)Done.$(tput sgr0)"
fi
echo "$(tput setaf 2)Neovim is fully configured.$(tput sgr0)"
