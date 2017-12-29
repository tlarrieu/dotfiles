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

# Toggl
alias t="toggl"
alias tstop="toggl stop current"

# xsel
alias xsel="xsel --clipboard"

# aria2c
alias dl="aria2c --dir=$HOME/Downloads"

# youtube-dl
alias yt="youtube-dl"

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

# Yaourt
alias y="yaourt"
alias yqs="yaourt -Qs"
alias ys="yaourt -S"
function yss; yaourt -Ss $argv | vip +'set nofoldenable'; end
alias ysuy="yaourt -Suy"
alias yr="yaourt -Rs"
alias yrc="yaourt -Rsc"
alias list-packages="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
alias dot="cd ~/git/dotfiles"
alias ap="cd ~/git/jobteaser/appointments"
alias jt="cd ~/git/jobteaser/jobteaser"
alias jc="cd ~/git/jobteaser/jsonical"
alias ct="cd ~/git/jobteaser/cockpit"

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
function gf
  if count $argv > /dev/null
    git diff --name-only $argv..
  else
    git diff --name-only develop..
  end
end
alias gl="git log"
alias glg="git lg"
alias gllg="git llg"
alias gpl="git pull"
alias gps="git push"
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
alias dc="sudo docker-compose"
alias dcu="sudo docker-compose up -d"
alias dcd="sudo docker-compose down"
alias d="sudo docker"

# Exercism
alias e="exercism"
alias ef="exercism fetch"
alias es="exercism submit"

alias dsql="sudo docker exec -it jobteaser_sql-master_1 mysql -ujobteaser -pmijAwrethEE87 -Danon"
