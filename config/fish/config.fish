stty -ixon

# FZF
set -x FZF_DEFAULT_COMMAND "ag -g '' --hidden --ignore .git"
set -x FZF_DEFAULT_OPTS '--reverse'

# Postgres
set PGHOST localhost

# EDITOR
set -g -x EDITOR nvim

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH $HOME/bin

# rbenv
if type rbenv > /dev/null
  source (rbenv init - | psub)
end

# # Oh-my-fish theme
set -g default_user tlarrieu
set -g theme_color_scheme terminal-light
set -g theme_display_date no
set -g theme_nerd_fonts yes

fundle plugin 'tuvistavie/fish-ssh-agent'
fundle plugin 'oh-my-fish/theme-bobthefish'
fundle init

function fish_greeting; end
