#!/bin/sh

[[ "$1" == "-f" ]] && FORCE=true

safelink()
{
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

BASEDIR=$(cd "$(dirname "$0")"; pwd)

git submodule init

# .vimrc
safelink $BASEDIR/vimrc $HOME/.vimrc
# Vundle package installation
vim +BundleInstall +qall
# YouCompleteMe installation
if [[ -d ~/.vim/bundle/YouCompleteMe ]]; then
  [[ -n $(brew list | grep cmake) ]] || brew install cmake
  cd ~/.vim/bundle/YouCompleteMe
  ./install.sh
fi

#.vim
safelink $BASEDIR/vim $HOME/.vim

# Fish
[[ -n $(brew list | grep fish) ]]  || brew install fish
# Oh My Fish!
[[ -d ~/.oh-my-fish ]] || curl -L https://github.com/bpinto/oh-my-fish/raw/master/tools/install.sh | sh
safelink $BASEDIR/fish_theme/smockey $HOME/.oh-my-fish/themes/smockey
# RVM
curl -sSL https://get.rvm.io | bash -s stable
# RVM fix for fish
curl --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish

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

# .tmux.conf
safelink $BASEDIR/tmux.conf $HOME/.tmux.conf

# iTerm2
safelink $BASEDIR/com.googlecode.iterm2.plist $HOME/Library/Preferences


# fonts
[[ -d $HOME/.fonts ]] || mkdir $HOME/.fonts
cp $BASEDIR/Inconsolata\ for\ Powerline.otf $HOME/.fonts/
