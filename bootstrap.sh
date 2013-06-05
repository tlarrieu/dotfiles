#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true

safelink()
{
  target=$1
  link=$2
  if [ $FORCE ]; then
    echo "test"
    rm $link -rf
    ln -s -P $target $link
  else
    if [ -d $target ]; then
      echo -n "$link already exists, do you want to replace it? "
      read answer
      case $answer in
        "yes"|"y")
          rm $link -rf
          ;;
      esac
    fi
    ln -s -P -i $target $link
  fi
}

[[ -d ~/.config ]] || mkdir ~/.config
BASEDIR=$(cd "$(dirname "$0")"; pwd)

# .config directories
for file in `ls -d $BASEDIR/config/*`; do
  target=$BASEDIR/config/`basename $file`
  link=~/.config/`basename $file`
  safelink $target $link
done

# .vimrc
safelink $BASEDIR/vimrc $HOME/.vimrc

#.vim
safelink $BASEDIR/vim $HOME/.vim

# .zprezto
safelink $BASEDIR/zprezto $HOME/.zprezto

# zsh / zprezto dotfiles
for file in `ls $BASEDIR/zprezto/runcoms/z*`; do
  target=$BASEDIR/zprezto/runcoms/`basename $file`
  link=~/.`basename $file`
  safelink $target $link;
done

# .moc
safelink $BASEDIR/moc $HOME/.moc

# .mplayer
safelink $BASEDIR/mplayer $HOME/.mplayer

# .vimperatorrc
safelink $BASEDIR/vimperatorrc $HOME/.vimperatorrc

# .gitconfig
safelink $BASEDIR/gitconfig $HOME/.gitconfig

# .zsh (utility functions for prezto theme
safelink $BASEDIR/zsh $HOME/.zsh

# fonts
[[ -d $HOME/.fonts ]] || mkdir $HOME/.fonts
cp $BASEDIR/Inconsolata\ for\ Powerline.otf $HOME/.fonts/
