# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# Zathura
alias z="zathura"

# Vim + ranger
alias python2="python2.7"
alias vimrc="nvim ~/.vimrc"
alias vir="nvim -R"
alias vip="nvim -c 'setlocal nomod | setlocal ro' -"

# Exercism
alias e="exercism"

# Various CLI utils
alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias wee="weechat-curses"
alias a="atool"
alias atx="atool -x"

# Yaourt
alias y="yaourt"
alias ys="yaourt -S"
alias yss="yaourt -Ss"
alias ysuy="yaourt -Suy"
alias yr="yaourt -R"
alias list-packages="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# Kill
alias k="kill -9"
alias kbg="kill (jobs -p)"

# cd
alias shops="cd ~/mercurial/shopmium/shops"
alias serv="cd ~/git/shopmium/server"
alias etl="cd ~/git/shopmium/etl"
alias dot="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"
alias budget="cd ~/git/budget"
alias dand="cd ~/git/dand.io"

# ls
alias l="ls"

# SSH agent
alias kc="keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa"

# Git
alias g="git"
alias gcd="cd (git rev-parse --show-toplevel)"
alias ga="git add"
alias gb="git branch"
alias gd="git difftool"
alias gcl="git clone"
alias gci="git commit"
alias gcia="git commit --amend"
alias gco="git checkout"
alias gf="git diff --name-only develop.."
alias gl="git log"
alias glg="git lg"
alias glgs="git lgs"
alias gpl="git pull"
alias gps="git push"
alias gs="git status"
alias gspr="git diff --name-status master..HEAD"
alias gdpr="git difftool master..HEAD"

# Git flow
alias f="git flow feature"
alias h="git flow hotfix"
alias r="git flow release"

function rc
  if count $argv > /dev/null
    heroku run console -a $argv
  else
    bin/rails console
  end
end

# pgbackup
alias ddump="curl (heroku pg:backups public-url -a shopmium) > ~/Downloads/last.dump"

# Zeus
alias zc="zeus console"
alias zg="zeus generate"
alias zs="zeus server"
alias zst="zeus start"

# Rails
alias rs="bin/rails server"
alias rrs="rescue rails server"
alias be="bin/bundle exec"
alias bi="bin/bundle install"
alias bu="bin/bundle update"
alias bspec="bin/bundle exec rspec"
alias bguard="bin/bundle exec guard"

# Rake / Bundler
alias raklette="bin/bundle exec rake parallel:spec"
alias be="bin/bundle exec"
alias bspec="bin/bundle exec rspec"
alias rdm="bin/bundle exec rake db:migrate"
alias rds="bin/bundle exec rake db:migrate:status | tail"
alias rpp="bin/bundle exec rake parallel:prepare"
alias rdtp="bin/bundle exec rake db:test:prepare"
alias rdr="bin/rake db:rollback"
alias rdre="bin/rake db:migrate:redo"
alias rr="bin/rake routes > routes"
function rdd; bin/rake db:migrate:down VERSION=$argv; end
function rdu; bin/rake db:migrate:up VERSION=$argv; end

# emulation
alias pokemon="gvbam '/home/tlarrieu/roms/gba/Pokemon - Fire Red Version (U) (V1.1).gba'"

# Stuff
alias expose=~/git/Expose/expose.sh

# ------------------------------------------------------------------------------
# Settings
# ------------------------------------------------------------------------------

stty -ixon

# Postgres
set PGHOST localhost

# EDITOR + TERM
set -g -x GEDITOR gvim
set -g -x EDITOR nvim
set -g -x TERM xterm-256color
# Enable cursor change when neovim enters insert mode
set -g -x NVIM_TUI_ENABLE_CURSOR_SHAPE 1
# set -g -x NVIM_TUI_ENABLE_TRUE_COLOR 1

# Gopath
set -x GOPATH ~/go

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH /Library/PostgreSQL/9.4/bin
set -x PATH $PATH /usr/local/heroku/bin
set -x PATH $PATH ~/bin
set -x PATH $PATH ~/.cabal/bin
set -x PATH $PATH ~/Elm-Platform/0.15/bin
set -x PATH $PATH ~/go/bin
set -x PATH $PATH ~/git/pls

set -x ANDROID_HOME ~/android-sdk/

if type rbenv > /dev/null
  # set -gx RBENV_ROOT /usr/local/var/rbenv
  source (rbenv init - | psub)
end

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

set -g SSL_CERT_FILE /etc/openssl/cert.pem

# Load oh-my-fish configuration.
set -gx OMF_PATH "/home/tlarrieu/.local/share/omf"
source $OMF_PATH/init.fish

# Oh-my-fish theme
set -g theme_display_user yes
set -g default_user tlarrieu
omf theme 'clearance'
