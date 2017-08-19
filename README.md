# dotfiles

My personnal config files.

## Disclaimer

This repository contains my personnal config files for various applications.
This is first and foremost designed for my own needs (backup / bootstrapping
from various places).
If you want to try it out, just clone this repo and run install.sh.
This will not override your previous configuration : the script will
ask you if you want to keep your own file for every items.

That being said, I greatly recommand to save any previous work though if you
just intend to test my configuration.

## Goals

- Maintain a coherent config backup / bootstrap
- Provide support for bépo (french dvorak variant, more about it [here](http://bepo.fr/wiki/Accueil))
- Provide uniformized color scheme for various applications

## TODO

- [ ] properly apply xrdb on the fly for URxvt (mostly functional but colors are dimmed reloading)
- [ ] find a way to automatically apply theme in vim upon changing xrdb theme (we have to manually — althrough through a helper function — apply it)
