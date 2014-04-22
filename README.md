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
- Provide uniformized solarized color scheme for various applications (more about this wonderful scheme 
here : http://ethanschoonover.com/solarized)
- Implement powerline style wherever I can
####td;dr

**I need bépo / solarized / powerline everywhere!!**


Supported applications
----------------------
- tmux
- vim
- fish
- Oh My Fish!
- awesome
- ranger
- sakura
- mplayer
- moc
- git
- mercurial
- Firefox : userchrome.css does not get linked properly by install script. You have to manually copy it in your profile directory (~/.mozilla/firefox/<profile>/chrome/)

Some might be added, depending on my personnal needs.
