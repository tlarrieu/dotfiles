[group("system/assets")]
fonts:
  #!/usr/bin/env bash
  ZIPNAME="CascadiaCode.zip"
  TMP="/tmp/$ZIPNAME"
  DIR="$HOME/.fonts/CaskaydiaCove"
  VERSION="3.4.0"
  wget --quiet https://github.com/ryanoasis/nerd-fonts/releases/download/v$VERSION/$ZIPNAME -O $TMP
  rm -rf $DIR
  mkdir -p $DIR
  cd $DIR
  unzip $TMP
  fc-cache -fr
