# reset terminal
alias cls="echo -e \\033c"

# systemctl
alias ctl="systemctl"

# nginx
alias nginx="sudo nginx"

# NVIM
alias vip="nvim -c 'setlocal nomod | setlocal ro' -"
alias v="nvim"
alias ren="nvim +Renamer"
alias s="nvim ~/postgres.sql"

# Qutebrowser
alias q="qutebrowser --backend webengine"

# xsel
alias xsel="xsel --clipboard"

# aria2c
alias dl="aria2c --dir=$HOME/Downloads"

# youtube-dl
alias yt="youtube-dl"
function yta; mpc add (youtube-dl -g $argv); mpc play ; end

# Feh
alias feh="feh -dF"

# Zathura
alias z="zathura"

# weechat
alias wee="weechat"

# Various CLI utils
alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias atx="atool -x"

# YAY
alias y="yay"
alias yqs="yay -Qs"
alias ys="yay -S"
function yss; yay -Ss $argv | vip +'set nofoldenable'; end
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

# ls
alias l="ls"

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
function rc
  if count $argv > /dev/null
    heroku run rails console -a $argv
  else
    bundle exec rails console
  end
end
alias r="rails"
alias rs="bundle exec rails server"
alias be="bundle exec"
alias rdm="bundle exec rake db:migrate db:test:prepare"
alias rds="bundle exec rake db:migrate:status | tail"
alias rpp="bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Heroku
alias h="heroku"
alias hps="heroku ps"

# Docker
alias dc="docker-compose"
alias dcu="docker-compose up -d"
alias dcd="docker-compose down"
alias d="docker"

# Kubernetes
alias k="kubectl"

# Exercism
alias e="exercism"
alias ef="exercism fetch"
alias es="exercism submit"

alias dsql="sudo docker exec -it jobteaser_sql-master_1 mysql -ujobteaser -pmijAwrethEE87 -Danon"
