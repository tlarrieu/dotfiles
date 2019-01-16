# reset terminal
alias cls="echo -e \\033c"

# systemctl
alias ctl="systemctl"

# NVIM
alias ep="nvim -c 'setlocal nomod | setlocal ro' -"
alias e="nvim"
alias es="sudo nvim"

# xsel
alias xsel="xsel --clipboard"
alias xso="xsel --clipboard -o"
alias xsi="xsel --clipboard -i"

# aria2c
alias dl="aria2c --dir=$HOME/Downloads"

# curl
alias c="curl"
alias co="curl -O"

# youtube-dl
alias yv="youtube-dl -fbest"
alias yvv="youtube-dl -fbest (xsel -o)"
alias ym="youtube-dl -fbestaudio"
alias ymm="youtube-dl -fbestaudio (xsel -o)"
function ya; mpc add (youtube-dl -g $argv); mpc play ; end

# Zathura
alias z="zathura"

# Various CLI utils
alias tree="tree -C"
alias less="less -R"

# atool
alias atx="aunpack"
alias atp="apack"

# YAY
alias y="yay"
alias yqs="yay -Qs"
alias ys="yay -S"
alias yss="yay -Ss --color=always"
alias ysuy="yay -Suy"
alias yr="yay -Rs"
alias yrc="yay -Rsc"
alias list-packages="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
alias dot="cd ~/git/dotfiles"
alias ap="cd ~/git/jobteaser/appointments"
alias jt="cd ~/git/jobteaser/jobteaser"
alias jc="cd ~/git/jobteaser/jsonical"
alias ct="cd ~/git/jobteaser/cockpit"
alias iam="cd ~/git/jobteaser/iam"
alias sand="cd ~/sandbox"

# SSH
alias ssh-wtf="cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
alias g="git"
alias gcd="cd (git rev-parse --show-toplevel)"
alias ga="git add"
alias gb="git branch"
alias gd="git d"
alias gds="git ds"
alias gcl="git clone"
alias gci="git commit"
alias gco="git checkout"
alias gl="git log"
alias glg="git lg"
alias gllg="git llg"
alias gpl="git pull"
alias gps="git push"
alias gr="git rebase"
alias grc="git rebase --continue"
alias gs="git status -s -b"

# Rails / Rake / Bundler
alias r="rails"
alias rc="rails console"
alias rs="bundle exec rails server"
alias be="bundle exec"
alias rdm="bundle exec rake db:migrate db:test:prepare"
alias rds="bundle exec rake db:migrate:status | tail"
alias rpp="bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Docker
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias d="docker"

# Kubernetes
alias k="kubectl"
