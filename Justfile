alias boot := bootstrap

[doc("bootstrap the system: install packages, link configuration files, enable services...")]
@bootstrap: (green "boostrapping: running...") packages fonts links templates services X11 shell crontab root && (yellow "bootstrapping: done.")

alias ln := links

[group("config/links"), default, doc("link configuration files into ~/.config/")]
links: (green "configuration: linking files...") && (yellow "configuration: done.")
  #!/usr/bin/env bash
  shopt -s dotglob # include hidden files in globbing

  for name in home/*; do ln -rsfFT "$name" ~/"$(basename $name)"; done

  mkdir -p ~/.config
  for name in config/*; do ln -rsfFT "$name" ~/."$name"; done

  mkdir -p ~/.local/share/applications
  for name in local/share/applications/*; do ln -rsfFT "$name" ~/."$name"; done

  mkdir -p ~/scripts
  for name in scripts/*; do ln -rsfFT "$name" ~/"$name"; done

  mkdir -p ~/.Xresources.d
  for name in Xresources.d/*; do ln -rsfFT "$name" ~/."$name"; done

  git config --global core.excludesFile ~/.gitignore
  [ -f ~/.profile ] && rm ~/.profile || /bin/true

alias x11 := X11

[group("config/links")]
X11: (green "X11: linking files...") && (yellow "X11: done.")
  #!/usr/bin/env bash
  for name in xorg.conf.d/*; do sudo ln -rsfFT $name /etc/X11/$name; done

alias cp := templates

[group("config/templates"), doc("deploy templates")]
templates: (template ".Xresources.d/local") \
  (template ".xsettingsd") \
  (template ".config/kitty/theme.conf") \
  (template ".config/zathura/theme") \
  (template ".config/rofi/variant.rasi")

[group("config/templates"), doc("link root configuration into /root/")]
root: (green "root configuration: linking files...") && (yellow "root configuration: done.")
  sudo cp templates/root/.bashrc /root/.bashrc
  sudo mkdir -p /root/.config/nvim
  sudo cp templates/root/nvim.lua /root/.config/nvim/init.lua

[group("system/packages"), doc("install dependencies and single packages")]
packages: (green "packages: installing...") && (yellow "packages: done.")
  #!/usr/bin/env bash
  # Arch Linux
  if type -p pacman > /dev/null; then
    sudo pacman -S --color always --needed --noconfirm yay
    yay -S --color always --needed --noconfirm $(cat ./packages/arch.txt | grep -v "#")
  # Ubuntu
  elif type -p apt > /dev/null; then
    sudo cp ./packages/sources.list /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
    sudo apt install -y $(cat packages-ubuntu.txt | grep -v "#")
    mkdir -p ~/bin
    ln -sfFT /usr/bin/fdfind ~/bin/fd
    just neovim awesome picom kitty
  else
    echo "Unsupported distribution."
    exit 1
  fi

[group("system/packages"), doc("build neovim from sources")]
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

[group("system/packages"), doc("build awesome from sources")]
awesome: (green "awesome: building...") (clone "awesomewm/awesome" "~/git/awesome") && (yellow "awesome: done.")
  #!/usr/bin/env bash
  cd ~/git/awesome
  git clean -f
  git checkout .
  make package
  cd build
  sudo apt install -y ./*.deb
  sudo cp ~/git/awesome/awesome.desktop /usr/share/xsessions/awesome.desktop

[group("system/packages"), doc("build picom from sources")]
picom: (green "picom: building...") (clone "yshui/picom" "~/git/picom") && (yellow "picom: done.")
  #!/usr/bin/env bash
  cd ~/git/picom
  meson setup --buildtype=release build
  ninja -C build
  sudo ninja -C build install

[group("system/packages"), doc("build kitty from sources")]
kitty: (green "kitty: building...") (clone "kovidgoyal/kitty" "~/git/kitty") && (yellow "kitty: done.")
  #!/usr/bin/env bash
  cd ~/git/kitty
  ./dev.sh build
  ln -sf ~/git/kitty/kitty/launcher/kitty ~/bin/kitty
  ln -sf ~/git/kitty/kitty/launcher/kitten ~/bin/kitten

[group("system/assets"), doc("install fonts (Caskaydia Cove)")]
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
  [ "$SHELL" = "{{bin}}" ] && exit 0
  [ ! -x "{{bin}}" ] && echo "{{RED}}Error: \`{{bin}}\` is not executable"{{NORMAL}} && exit 1
  chsh -s {{bin}}

[group("system"), doc("install crontab")]
crontab:
  #!/usr/bin/env sh
  crontab > /dev/null <<-CRONTAB
  DISPLAY=:0
  DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus

  0 19 * * * ~/scripts/toggle-light-and-dark.sh dark
  0 9 * * * ~/scripts/toggle-light-and-dark.sh light
  CRONTAB

[group("other/repos"), doc("clone personal wiki")]
neorg: (clone "tlarrieu/notes" "~/.neorg")

[group("other/repos"), doc("clone RSS streams")]
rss: (clone "tlarrieu/rss" "~/.rss")

[group("other/repos"), doc("clone accounting ledgers")]
accounting: (clone "tlarrieu/accounting" "~/.accounting")

# ------------------------------------------------------------------------------
# helpers
# ------------------------------------------------------------------------------

[private]
template name:
  @cp --update=none templates/{{name}} ~/{{name}}

[private]
clone repo target:
  #!/usr/bin/env bash
  [ ! -d {{target}} ] && just do_clone {{repo}} {{target}} || /bin/true

[private]
@do_clone repo target: (green repo + ": cloning...") && (yellow repo + ": done.")
  -git clone https://github.com/{{repo}} {{target}}

[private]
@green label:
  echo {{GREEN + ITALIC + label + NORMAL}}

[private]
@yellow label:
  echo {{YELLOW + ITALIC + label + NORMAL}}
