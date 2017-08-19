stty -ixon

# FZF
set -x FZF_DEFAULT_COMMAND "ag -g '' --hidden --ignore .git"
set -x FZF_DEFAULT_OPTS '--reverse'

# Postgres
set PGHOST localhost

# EDITOR
set -g -x EDITOR nvim
set -g -x BROWSER luakit

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH $HOME/bin

fundle plugin 'tuvistavie/fish-ssh-agent'
fundle plugin 'fisherman/rbenv'
fundle init
