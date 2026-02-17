@_usage:
  just -l

alias boot := bootstrap
[doc("bootstrap the system: install packages, link configuration files, enable services...")]
@bootstrap: (pending "boostrapping: running...") packages fonts links templates services X11 shell crontab root && (success "bootstrapping: done.")

alias ln := links
[group("config/links"), doc("link configuration files into ~/.config/ (and override)")]
links: (pending "configuration: linking files...") && (success "configuration: done.")
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

[group("config/links"), doc("link X11 configuration files into /etc/X11/ (and override)")]
@X11: (pending "X11: linking files...") && (success "X11: done.")
  for name in xorg.conf.d/*; do sudo ln -rsfFT $name /etc/X11/$name; done

alias cp := templates
[group("config/templates"), doc("deploy templates (but don't override)")]
templates: (template ".Xresources.d/local") \
  (template ".xsettingsd") \
  (template ".config/kitty/theme.conf") \
  (template ".config/zathura/theme") \
  (template ".config/rofi/variant.rasi")

[group("config/templates"), doc("link root configuration into /root/ (and override)")]
root: (pending "root configuration: linking files...") && (success "root configuration: done.")
  sudo cp templates/root/.bashrc /root/.bashrc
  sudo mkdir -p /root/.config/nvim
  sudo cp templates/root/nvim.lua /root/.config/nvim/init.lua

alias pkg := packages
[group("system"), doc("install dependencies and single packages")]
packages: (pending "packages: installing...") && (success "packages: done.")
  #!/usr/bin/env bash
  if builtin type -P pacman > /dev/null; then # Arch Linux
    just success "Arch Linux detected, installing packages with yay..."
    sudo pacman -S --color always --needed --noconfirm yay
    yay -S --color always --needed --noconfirm $(cat ./packages/arch.txt | grep -v "#")
  elif builtin type -P apt > /dev/null; then # Ubuntu
    just success "Ubuntu detected, installing packages with apt..."
    sudo cp ./packages/sources.list /etc/apt/sources.list.d/ubuntu.sources
    sudo apt update
    sudo apt install -y $(cat packages-ubuntu.txt | grep -v "#")
    mkdir -p ~/bin
    ln -sfFT /usr/bin/fdfind ~/bin/fd
    just neovim awesome picom kitty
  else
    echo "{{RED}}Unsupported distribution.{{NORMAL}}"
    exit 1
  fi

[group("deps/sources"), doc("build neovim from sources")]
neovim: (pending "neovim: building...") (clone "neovim/neovim" "~/git/neovim") && (success "neovim: done.")
  #!/usr/bin/env bash
  cd ~/git/neovim
  git fetch
  git checkout nightly
  rm -r build
  make CMAKE_BUILD_TYPE=Release
  cd build
  cpack -G DEB
  sudo dpkg -i nvim-linux-x86_64.deb

[group("deps/sources"), doc("build awesome from sources")]
awesome: (pending "awesome: building...") (clone "awesomewm/awesome" "~/git/awesome") && (success "awesome: done.")
  #!/usr/bin/env bash
  cd ~/git/awesome
  git clean -f
  git checkout .
  make package
  cd build
  sudo apt install -y ./*.deb
  sudo cp ~/git/awesome/awesome.desktop /usr/share/xsessions/awesome.desktop

[group("deps/sources"), doc("build picom from sources")]
picom: (pending "picom: building...") (clone "yshui/picom" "~/git/picom") && (success "picom: done.")
  #!/usr/bin/env bash
  cd ~/git/picom
  meson setup --buildtype=release build
  ninja -C build
  sudo ninja -C build install

[group("deps/sources"), doc("build kitty from sources")]
kitty: (pending "kitty: building...") (clone "kovidgoyal/kitty" "~/git/kitty") && (success "kitty: done.")
  #!/usr/bin/env bash
  cd ~/git/kitty
  ./dev.sh build
  ln -sf ~/git/kitty/kitty/launcher/kitty ~/bin/kitty
  ln -sf ~/git/kitty/kitty/launcher/kitten ~/bin/kitten

[group("system"), doc("install fonts (Caskaydia Cove)")]
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

[group("system"), doc("enable lightdm, NetworkManager, mpd & active timedatectl's ntp")]
services: (pending "services: enabling...") && (success "services: done.")
  -sudo systemctl enable lightdm
  -sudo systemctl enable NetworkManager
  @mkdir -p ~/.local/share/mpd
  -sudo systemctl --user enable mpd
  -sudo timedatectl set-ntp true

alias sh := shell
[group("system"), doc("set user shell")]
shell bin="/usr/bin/fish":
  #!/usr/bin/env bash
  [ "$SHELL" = "{{bin}}" ] && exit 0
  [ ! -x "{{bin}}" ] && just error "Error: \'{{bin}}\' is not executable" && exit 1
  chsh -s {{bin}}

[group("system"), doc("install crontab (override existing ones)")]
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
rss: (clone "tlarrieu/rss" "~/git/rss")

[group("other/repos"), doc("clone accounting ledgers")]
accounting: (clone "tlarrieu/accounting" "~/git/accounting")

# ------------------------------------------------------------------------------
# helpers
# ------------------------------------------------------------------------------

[private]
template name:
  @cp --update=none templates/{{name}} ~/{{name}}

[private]
@clone repo target:
  [ -d {{target}} ] || just do_clone {{repo}} {{target}}

[private]
@do_clone repo target: (pending repo + ": cloning...") && (success repo + ": done.")
  -git clone git://github.com/{{repo}}.git {{target}}

[private]
@pending label: (say YELLOW "󰔟 " + label)

[private]
@success label: (say GREEN " " + label)

[private]
@error label: (say RED " " + label)

[private]
say color label:
  @echo {{color + ITALIC + label + NORMAL}}
