[group("config/links"), default]
links: (green "Linking configuration files") && (yellow "Done.")
  #!/usr/bin/env bash
  shopt -s dotglob # include hidden files in globbing

  for name in home/*; do ln -sfFT {{BASEDIR}}/"$name" ~/"$(basename $name)"; done

  mkdir -p ~/.config
  for name in config/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  mkdir -p ~/.local/share/applications
  for name in local/share/applications/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  mkdir -p ~/scripts
  for name in scripts/*; do ln -sfFT {{BASEDIR}}/"$name" ~/"$name"; done

  mkdir -p ~/.Xresources.d
  for name in Xresources.d/*; do ln -sfFT {{BASEDIR}}/"$name" ~/."$name"; done

  git config --global core.excludesFile ~/.gitignore
  [ -f ~/.profile ] && rm ~/.profile || /bin/true

[group("config/links")]
X11: (green "X11: linking configuration files...") && (yellow "X11: done.")
  #!/usr/bin/env bash
  for name in xorg.conf.d/*; do sudo ln -sfFT {{BASEDIR}}/$name /etc/X11/$name; done
