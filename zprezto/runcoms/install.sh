#!/bin/zsh

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s -i "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

