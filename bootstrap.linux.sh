#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true
[[ `uname -s` == "Darwin" ]] && OSX=true

safelink()
{
  target=$1
  link=$2
  echo $link "->" $target
  if [ $FORCE ]; then
    rm -rf $link
    if [ $OSX ]; then
      ln -s -i $target $link
    else
      ln -sfF $target $link
    fi
  else
    link=true
    if [ -d $target -o -f $target ]; then
      link=false
      echo -n "$link already exists, do you want to replace it? (y/N/a) "
      read answer
      case $answer in
        "yes"|"y")
          rm -rf $link
          link=true
          ;;
        "all"|"a")
          rm -rf $link
          FORCE=true
          link=true
          ;;
      esac
    fi
    if [ $link ]; then
      if [ $OSX ]; then
        ln -s -i $target $link
      else
        ln -s -P -i $target $link
      fi
    fi
  fi
}

safeinstall() {
  if [ $OSX ]; then
    [[ -n $(brew list | grep $1) ]] || brew install $1
  else
    [[ -n $(yaourt -Q $1) ]] || yaourt -Ss $1
  fi
}

BASEDIR=$(cd "$(dirname "$0")"; pwd)

git submodule init
git submodule update

# .config directories
[[ -d ~/.config ]] || mkdir ~/.config
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# .vimrc
safelink $BASEDIR/vimrc $HOME/.vimrc
# Vundle
if [[ -d ~/.vim/bundle/Vundle.vim ]]; then
  echo "Vundle already installed, nothing to do."
else
  git clone https://github.com/gmarik/Vundle.vim.git ~/.vim/bundle/Vundle.vim
fi
#.vim
safelink $BASEDIR/vim $HOME/.vim
# Bundler
vim +BundleInstall +qall
# Fix for Vim buffer within tmux on OSX
if [ $OSX ]; then
  safeinstall reattach-to-user-namespace
fi
# Fish
safeinstall fish
# Oh My Fish!
if [[ -d ~/.oh-my-fish ]]; then
  echo "Oh-My-Fish already installed. Nothing to do!"
else
  curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh
fi
safelink $BASEDIR/fish_theme/smockey $HOME/.oh-my-fish/themes/smockey
safelink $BASEDIR/fish_theme/clearance2 $HOME/.oh-my-fish/themes/clearance2
echo "Fish fully configured, don't forget to set it as your shell"

# RVM and fix for fish
if [[ -d ~/.rvm ]]; then
  echo "RVM already installed. Nothing to do!"
else
  curl -sSL https://get.rvm.io | bash -s stable
  curl --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
fi

# .moc & mplayer
safelink $BASEDIR/moc $HOME/.moc
safelink $BASEDIR/mplayer $HOME/.mplayer

# .vimperatorrc
safelink $BASEDIR/vimperatorrc $HOME/.vimperatorrc

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore

# .tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

# agignore
safelink $BASEDIR/agignore $HOME/.agignore

# irbrc
safelink $BASEDIR/irbrc $HOME/.irbrc

# rubocop
safelink $BASEDIR/rubocop.yml $HOME/.rubocop.yml

# pmux
mkdir $HOME/scripts
safelink $BASEDIR/pmux $HOME/scripts/pmux

# Custom shutdown script
safelink $BASEDIR/shutdown_dialog.sh $HOME/scripts/shutdown_dialog.sh

# asoundrc
safelink $BASEDIR/asoundrc $HOME/.asoundrc

# fonts
[[ -d $HOME/.fonts ]] || mkdir $HOME/.fonts
cp $BASEDIR/Inconsolata\ for\ Powerline.otf $HOME/.fonts/
