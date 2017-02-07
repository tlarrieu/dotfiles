# reset terminal
alias cls="echo -e \\033c"

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

# xclip
alias xclip="xclip -selection clipboard"

# python
alias python2="python2.7"

# aria2c
alias dl="aria2c --dir=$HOME/Downloads"

# youtube-dl
alias yt="youtube-dl"

# mplayer
alias mp="mplayer"

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
alias list-packages="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
alias jt="cd ~/git/jobteaser/jobteaser"
alias cockpit="cd ~/git/jobteaser/cockpit"
alias dot="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"

# ls
alias l="ls"

# SSH
alias kc="keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa"
alias ssh-wtf="cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
alias g="git"
alias gcd="cd (git rev-parse --show-toplevel)"
alias ga="git add"
alias gb="git branch"
alias gd="git difftool"
alias gcl="git clone"
alias gci="git commit"
# Make "master" the default branch
alias gco="git checkout"
alias gf="git diff --name-only develop.."
alias gl="git log"
alias glg="git lg"
alias glgs="git lgs"
alias gpl="git pull"
alias gps="git push"
alias gs="git status -s -b"
alias gspr="git diff --name-status develop..HEAD"
alias gdpr="git difftool develop..HEAD"

# Git flow
alias f="git flow feature"
alias h="git flow hotfix"
alias r="git flow release"

# Rails / Rake / Bundler
function rc
  if count $argv > /dev/null
    heroku run console -a $argv
  else
    bundle exec rails console
  end
end
alias rs="bundle exec rails server"
alias raklette="bundle exec rake parallel:spec"
alias be="bundle exec"
alias rdm="bundle exec rake db:migrate"
alias rds="bundle exec rake db:migrate:status | tail"
alias rpp="bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Docker
alias dc="sudo docker-compose"
alias d="sudo docker"

# Exercism
alias e="exercism"
alias ef="exercism fetch"
alias es="exercism submit"

alias dsql="sudo docker exec -it jobteaser_sql-master_1 mysql -ujobteaser -pmijAwrethEE87 -Danon"
