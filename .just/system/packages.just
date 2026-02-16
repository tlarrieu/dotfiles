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
