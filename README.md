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

###About missing links
I do know I have broken links to other git projects that are included in this one.
I sincerly apologize for this. The reason behind that is that I'm quiet new to git
and could not find a way to include them properly. If you find this offensive
or want to help me achieve cross-references, I'd be glad too ;)

**Anyway, I will link all of theme soon enough so at least, they can get credit
for their respective work!**

Goals
-----

- Maintain a coherent config backup / bootstrap
- Provide support for bépo (french dvorak variant, more about it here : http://bepo.fr/wiki/Accueil)
- Provide uniformized solarized color scheme for various applications (more about this wonderful scheme 
here : http://ethanschoonover.com/solarized)
- Implement powerline wherever I can (as for now only in vim — with the real python plugin, and 
in zsh through presto — although this one is "emulated"). More to come, whenever I find some time ;)

####td;dr

**I need bépo / solarized / powerline everywhere!!**


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
- zathura
- Firefox : *userchrome is the only file that does not get
linked properly by install script. You have to manually copy it
in your profile repository (~/.mozilla/firefox/\<profile\>/chrome/)*

Some might be added, depending on my personnal needs.


Warning
-------
/!\ You will need powerline (https://github.com/Lokaltog/powerline) for
the vimrc file to be fully operationnal. (if you don't need it,
just tweak a bit the file in order to get the old status bar displayed).
