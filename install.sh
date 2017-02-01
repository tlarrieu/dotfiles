#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true

platformlink() {
  target=$1
  link=$2

  ln -sfFT $target $link
}

safelink()
{
  target=$1
  link=$2

  if [ $FORCE ]; then
    DO_LINK=true
  else
    if [ -d $link -o -f $link ]; then
      DO_LINK=false

      echo -n "$(tput setaf 3)'$link' already exists, do you want to replace it? ([y]es/[n]o/[a]ll) $(tput sgr0)"

      read answer
      case $answer in
        "yes"|"y")
          DO_LINK=true
          ;;
        "all"|"a")
          FORCE=true
          DO_LINK=true
          ;;
        *)
          DO_LINK=false
          ;;
      esac
    else
      DO_LINK=true
    fi
  fi

  $DO_LINK && platformlink $target $link
}

safeinstall() {
  package=$1

  if type yaourt > /dev/null; then
    sudo yaourt -Sq --needed $package
  else
    sudo pacman -Sq --needed $package
  fi
}

BASEDIR=$(cd "$(dirname "$0")"; pwd)

git submodule init
git submodule update

# -- [[ Linking ]] -------------------------------------------------------------
echo "$(tput setaf 4)Linking configuration files...$(tput sgr0)"
# .config directories
[[ -d ~/.config ]] || mkdir ~/.config
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# .nvim
safelink $BASEDIR/nvim $HOME/.config/nvim

# Gnuplot
safelink $BASEDIR/gnuplot $HOME/gnuplot

# Bash
safelink $BASEDIR/bashrc $HOME/.bashrc

# .moc
safelink $BASEDIR/moc $HOME/.moc

# weechat
safelink $BASEDIR/weechat $HOME/.weechat

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore
git config --global core.excludesFile ~/.gitignore

# .tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

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

# asoundrc
safelink $BASEDIR/asoundrc $HOME/.asoundrc

# xprofile
safelink $BASEDIR/xprofile $HOME/.xprofile

# Xmodmap
safelink $BASEDIR/xmodmap.lavie-hz750c $HOME/.Xmodmap

# dircolors
safelink $BASEDIR/dir_colors $HOME/.dir_colors
echo "$(tput setaf 2)All files have been linked.$(tput sgr0)"

# -- [[ Package / plugins installation ]] --------------------------------------
# Core pacakages (maybe we should make a meta package or something)
echo
echo "$(tput setaf 4)Checking packages...$(tput sgr0)"
safeinstall yaourt
safeinstall awesome-git
safeinstall qutebrowser-git
safeinstall neovim
safeinstall ranger
safeinstall w3m

safeinstall rofi
safeinstall scrot
safeinstall feh

safeinstall zathura
safeinstall zathura-djvu
safeinstall zathura-pdf-mupdf
safeinstall zathura-ps

safeinstall mpc
safeinstall mpd
safeinstall mpv

safeinstall fish
safeinstall fundle-git
safeinstall termite

safeinstall nerd-fonts-complete
echo "$(tput setaf 2)All dependencies are up to date$(tput sgr0)"

echo

echo "$(tput setaf 4)Configuring fish...$(tput sgr0)"
# Oh My Fish!
if [[ -d ~/.local/share/omf ]]; then
  echo "$(tput setaf 2)Oh-My-Fish already installed. Nothing to do!$(tput sgr0)"
else
  curl -L https://github.com/oh-my-fish/oh-my-fish/raw/master/bin/install | fish
fi
fish -c 'fundle install' > /dev/null

OMF_PATH=$HOME/.local/share/omf
rm -rf $OMF_PATH/themes/clearance
cp -r $BASEDIR/fish_theme/clearance2 $OMF_PATH/themes/clearance
echo "$(tput setaf 2)Fish is fully configured, don't forget to set it as your shell$(tput sgr0)"

echo

echo "$(tput setaf 4)Configuring neovim...$(tput sgr0)"
# vim-plug
if [[ -f ~/.config/nvim/autoload/plug.vim ]]; then
  echo "$(tput setaf 2)vim-plug already installed, nothing to do.$(tput sgr0)"
else
  curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  nvim +PlugInstall +qall
fi
echo "$(tput setaf 2)Neovim is fully configured.$(tput sgr0)"
