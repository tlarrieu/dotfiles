stty -ixon

set -x FZF_DEFAULT_OPTS '--color fg:240,bg:15,hl:33,fg+:241,bg+:7,hl+:33'
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

set -x ANDROID_HOME ~/android-sdk/

if type rbenv > /dev/null
  # set -gx RBENV_ROOT /usr/local/var/rbenv
  source (rbenv init - | psub)
end

set -g SSL_CERT_FILE /etc/openssl/cert.pem

# Load oh-my-fish configuration.
set -gx OMF_PATH "/home/tlarrieu/.local/share/omf"
source $OMF_PATH/init.fish

# Oh-my-fish theme
set -g theme_display_user yes
set -g default_user tlarrieu
omf theme 'clearance'
