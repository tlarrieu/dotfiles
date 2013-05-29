dotfiles
========

My personnal config files.

Disclaimer
----------
This repository contains my personnal config files for various applications.
This is first and foremost designed for my own needs (backup / bootstrapping
from various places).
If you want to try it out, just clone this repo and run bootstrap.sh.
This will not override your previous configuration : the script will
ask you if you want to keep your own file for every items. I greatly
recommand to save any previous work though if you just intend to test my
configuration.

I might integrate a backup handler to automatize the process (backup / restore).
This is not a priority however, and this has great chance not to come
any time soon.

Goals
-----

- Maintain a coherent config backup / bootstrap
- Provide support for bépo (french dvorak variant, more about it here : http://bepo.fr/wiki/Accueil)
- Provide uniformized solarized color scheme for various applications (more about this awesome scheme here : http://ethanschoonover.com/solarized)

Supported applications
----------------------
- awesome
- ranger
- vim
- moc
- mplayer
- vimperator (firefox plugin)
- luakit
- zsh / prezto
- xfce4-terminal (Terminal)

Some might be added, depending on my personnal needs.


Warning
-------
/!\ You will need powerline (https://github.com/Lokaltog/powerline) for
the vimrc file to be fully operationnal. (if you don't need it,
just tweak a bit the file in order to get the old status bar displayed).
