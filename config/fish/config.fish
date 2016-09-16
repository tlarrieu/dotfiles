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
set -x PATH $PATH ~/bin

if type rbenv > /dev/null
  # set -gx RBENV_ROOT /usr/local/var/rbenv
  source (rbenv init - | psub)
end

# Load oh-my-fish configuration.
set -gx OMF_PATH "/home/tlarrieu/.local/share/omf"
source $OMF_PATH/init.fish

# Oh-my-fish theme
set -g theme_display_user yes
set -g default_user tlarrieu
omf theme 'clearance'
