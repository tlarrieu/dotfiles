#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true
[[ `uname -s` == "Darwin" ]] && OSX=true

platformlink() {
  target=$1
  link=$2
  if [ $OSX ]; then
    ln -s -i $target $link
  else
    ln -sfF $target $link
  fi
}

safelink()
{
  target=$1
  link=$2

  echo
  echo $link "->" $target

  if [ $FORCE ]; then
    rm -rf $link
    platformlink $target $link
  else
    DO_LINK=true

    if [ -d $link -o -f $link ]; then
      DO_LINK=false

      echo -n "File already exists, do you want to replace it? ([y]es/[N]o/[a]ll) "

      read answer
      case $answer in
        "yes"|"y")
          DO_LINK=true
          ;;
        "all"|"a")
          FORCE=true
          DO_LINK=true
          ;;
      esac

      [ $DO_LINK ] && rm -rf $link
    fi

    [ $DO_LINK ] && platformlink $target $link
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
safelink $BASEDIR/markdown.css $HOME/markdown.css
# vim-plug
if [[ -f ~/.vim/autoload/plug.vim ]]; then
  echo "vim-plug already installed, nothing to do."
else
  curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
fi
#.vim
safelink $BASEDIR/vim $HOME/.vim
# vim-plug
vim +PlugInstall +qall

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
