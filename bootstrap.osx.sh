#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true

safelink() {
  target=$1
  link=$2
  if [ $FORCE ]; then
    rm -rf $link
    ln -sfF $target $link
  else
    if [ -d $target ]; then
      echo -n "$link already exists, do you want to replace it? "
      read answer
      case $answer in
        "yes"|"y")
          rm -rf $link
          ;;
      esac
    fi
    ln -s -i $target $link
  fi
}

safebrew() {
  [[ -n $(brew list | grep $1) ]] || brew install $1
}

BASEDIR=$(cd "$(dirname "$0")"; pwd)

git submodule init
git submodule update

# .vimrc
safelink $BASEDIR/vimrc $HOME/.vimrc
#.vim
safelink $BASEDIR/vim $HOME/.vim
# Vundle package installation
vim +BundleInstall +qall
# YouCompleteMe installation
if [[ -d ~/.vim/bundle/YouCompleteMe ]]; then
  safebrew cmake
  cd ~/.vim/bundle/YouCompleteMe
  ./install.sh
fi

# Ponysay
safebrew ponysay

# Fish
safebrew fish

# Oh My Fish!
[[ -d ~/.oh-my-fish ]] || curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh
safelink $BASEDIR/fish_theme/smockey $HOME/.oh-my-fish/themes/smockey
safelink $BASEDIR/fish_theme/clearance2 $HOME/.oh-my-fish/themes/clearance2

# RVM and fix for fish
if [[ -d ~/.rvm ]]; then
  echo "RVM already installed. Nothing to do!"
else
  curl -sSL https://get.rvm.io | bash -s stable
  curl --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
fi

# .config directories
[[ -d ~/.config ]] || mkdir ~/.config
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# .gitconfig & .gitignore
safelink $BASEDIR/gitconfig $HOME/.gitconfig
safelink $BASEDIR/gitignore $HOME/.gitignore

# install fix for vim clipboard
safebrew reattach-to-user-namespace

# .tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

# agignore
safelink $BASEDIR/agignore $HOME/.aginore

# irbrc
safelink $BASEDIR/irbrc $HOME/.irbrc
