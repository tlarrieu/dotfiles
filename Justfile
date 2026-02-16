BASEDIR := `pwd`

[group("meta")]
@bootstrap list="packages fonts dotfiles templates services X11 shell crontab root":
  just green "Bootstrapping system..."
  just {{list}}
  just yellow "Done."

[group("assets")]
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

[group("config"), default]
dotfiles: (green "Linking configuration files") && (yellow "Done.")
  #!/usr/bin/env bash
  mkdir -p ~/.config
  for name in config/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  mkdir -p ~/.local/share/applications
  for name in local/share/applications/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  mkdir -p ~/scripts
  for name in scripts/*; do ln -sfFT {{BASEDIR}}/"$name" ~/"$name"; done

  mkdir -p ~/.Xresources.d
  for name in Xresources.d/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  ln -sfFT {{BASEDIR}}/xresources ~/.Xresources
  ln -sfFT {{BASEDIR}}/projections.json ~/.projections.json
  ln -sfFT {{BASEDIR}}/lua ~/lua
  ln -sfFT {{BASEDIR}}/gtkrc-2.0 ~/.gtkrc-2.0
  ln -sfFT {{BASEDIR}}/nvim ~/.config/nvim
  ln -sfFT {{BASEDIR}}/vifm ~/.vifm
  ln -sfFT {{BASEDIR}}/hledger.conf ~/.hledger.conf
  ln -sfFT {{BASEDIR}}/bashrc ~/.bashrc
  ln -sfFT {{BASEDIR}}/browser-config ~/.browser-config
  ln -sfFT {{BASEDIR}}/gitconfig ~/.gitconfig
  ln -sfFT {{BASEDIR}}/gitignore ~/.gitignore
  ln -sfFT {{BASEDIR}}/psqlrc ~/.psqlrc
  ln -sfFT {{BASEDIR}}/irbrc ~/.irbrc
  ln -sfFT {{BASEDIR}}/pryrc ~/.pryrc
  ln -sfFT {{BASEDIR}}/rubocop.yml ~/.rubocop.yml
  ln -sfFT {{BASEDIR}}/tslint.json ~/tslint.json
  ln -sfFT {{BASEDIR}}/newsboat ~/.newsboat
  ln -sfFT {{BASEDIR}}/apps ~/apps
  ln -sfFT {{BASEDIR}}/ncpamixer.conf ~/.ncpamixer.conf
  ln -sfFT {{BASEDIR}}/xprofile ~/.xprofile
  ln -sfFT {{BASEDIR}}/dir_colors ~/.dir_colors
  ln -sfFT {{BASEDIR}}/lesskey ~/.lesskey
  ln -sfFT {{BASEDIR}}/ghci ~/.ghci

  git config --global core.excludesFile ~/.gitignore
  [ -f ~/.profile ] && rm ~/.profile || /bin/true

[group("templates")]
templates: (template ".Xresources.d/local") \
  (template ".xsettingsd") \
  (template ".config/kitty/theme.conf") \
  (template ".config/zathura/theme") \
  (template ".config/rofi/variant.rasi")

[group("templates")]
root: (green "Linking root configuration files...") && (yellow "Done.")
  sudo cp {{BASEDIR}}/templates/root/.bashrc /root/.bashrc
  sudo mkdir -p /root/.config/nvim
  sudo cp {{BASEDIR}}/templates/root/nvim.lua /root/.config/nvim/init.lua

[group("config")]
X11: (green "X11: linking configuration files...") && (yellow "X11: done.")
  #!/usr/bin/env bash
  for name in xorg.conf.d/*; do sudo ln -sfFT {{BASEDIR}}/$name /etc/X11/$name; done

[group("packages"), doc("install dependencies and single packages")]
packages: (green "packages: installing...") && (yellow "packages: done.")
  #!/usr/bin/env bash
  # Arch Linux
  if type -p pacman > /dev/null; then
    sudo pacman -S --color always --needed --noconfirm yay
    yay -S --color always --needed --noconfirm $(cat packages-arch.txt | grep -v "#")
  # Ubuntu
  elif type -p apt > /dev/null; then
    sudo cp ./ubuntu-sources.list /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
    sudo apt install -y $(cat packages-ubuntu.txt | grep -v "#")
    mkdir -p ~/bin
    ln -sfFT /usr/bin/fdfind ~/bin/fd
    just neovim awesome picom kitty
  else
    echo "Unsupported distribution."
    exit 1
  fi

[group("packages"), doc("build neovim from sources")]
neovim: (green "neovim: building...") (clone "neovim/neovim" "~/git/neovim") && (yellow "neovim: done.")
  #!/usr/bin/env bash
  cd ~/git/neovim
  git fetch
  git checkout nightly
  rm -r build
  make CMAKE_BUILD_TYPE=Release
  cd build
  cpack -G DEB
  sudo dpkg -i nvim-linux-x86_64.deb

[group("packages"), doc("build awesome from sources")]
awesome: (green "awesome: building...") (clone "awesomewm/awesome" "~/git/awesome") && (yellow "awesome: done.")
  #!/usr/bin/env bash
  cd ~/git/awesome
  git clean -f
  git checkout .
  make package
  cd build
  sudo apt install -y ./*.deb
  sudo cp ~/git/awesome/awesome.desktop /usr/share/xsessions/awesome.desktop

[group("packages"), doc("build picom from sources")]
picom: (green "picom: building...") (clone "yshui/picom" "~/git/picom") && (yellow "picom: done.")
  #!/usr/bin/env bash
  cd ~/git/picom
  meson setup --buildtype=release build
  ninja -C build
  sudo ninja -C build install

[group("packages"), doc("build kitty from sources")]
kitty: (green "kitty: building...") (clone "kovidgoyal/kitty" "~/git/kitty") && (yellow "kitty: done.")
  #!/usr/bin/env bash
  cd ~/git/kitty
  ./dev.sh build
  ln -sf ~/git/kitty/kitty/launcher/kitty ~/bin/kitty
  ln -sf ~/git/kitty/kitty/launcher/kitten ~/bin/kitten

[group("system")]
crontab:
  #!/usr/bin/env sh
  crontab > /dev/null <<-CRONTAB
  DISPLAY=:0
  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

  0 19 * * * ~/scripts/toggle-light-and-dark.sh dark
  0 9 * * * ~/scripts/toggle-light-and-dark.sh light
  CRONTAB

[group("system"), doc("lightdm, NetworkManager, mpd, timedatectl")]
services: (green "services: enabling...") && (yellow "services: done.")
  -sudo systemctl enable lightdm
  -sudo systemctl enable NetworkManager
  @mkdir -p ~/.local/share/mpd
  -sudo systemctl --user enable mpd
  -sudo timedatectl set-ntp true

[group("system"), doc("set default shell (fish by default)")]
shell bin="/usr/bin/fish":
  #!/usr/bin/env bash
  if [ ! "$SHELL" = "{{bin}}" ]; then chsh -s {{bin}}; fi

[group("repos")]
neorg: (clone "tlarrieu/notes" "~/.neorg")
[group("repos")]
rss: (clone "tlarrieu/rss" "~/.rss")
[group("repos")]
accounting: (clone "tlarrieu/accounting" "~/.accounting")

# ------------------------------------------------------------------------------
# helpers
# ------------------------------------------------------------------------------

[private]
template name:
  @cp --update=none {{BASEDIR}}/templates/{{name}} ~/{{name}}

[private]
clone repo target:
  #!/usr/bin/env bash
  [ ! -d {{target}} ] && just do_clone {{repo}} {{target}} || /bin/true

[private]
@do_clone repo target:
  echo Getting {{repo}}...
  -git clone https://github.com/{{repo}} {{target}}
  echo Done.

[private]
@green label:
  echo {{GREEN + ITALIC + label + NORMAL}}

[private]
@yellow label:
  echo {{YELLOW + ITALIC + label + NORMAL}}
