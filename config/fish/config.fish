stty -ixon

# dark
# set -x FZF_DEFAULT_OPTS '--reverse --color fg:242,fg+:7,hl:33,hl+:33,bg:8,bg+:8'

# light
set -x FZF_DEFAULT_OPTS '--reverse --color fg:242,fg+:8,hl:33,hl+:33,bg:15,bg+:15'

set -x FZF_DEFAULT_COMMAND "ag -g '' --hidden --ignore .git"

# Postgres
set PGHOST localhost

# EDITOR + TERM
set -g -x GEDITOR gvim
set -g -x EDITOR nvim
set -g -x TERM xterm-256color

# Gopath
set -x GOPATH ~/go

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
