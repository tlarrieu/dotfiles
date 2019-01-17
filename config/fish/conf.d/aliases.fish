# reset terminal
abbr cls=" echo -ne \\033c"

# systemctl
abbr ctl="systemctl"

# NVIM
alias ep="nvim -R -"
abbr e="nvim"
abbr se="sudo nvim"
function scr
  set -l file "$HOME/git/dotfiles/scripts/$argv"

  test -e $file
  and nvim $file
  or echo -e 'i#!/bin/sh\n' | nvim -c 'setf sh' -s - -- $file

  chmod 700 $file ^ /dev/null
end

function app
  set -l file "$HOME/git/dotfiles/apps/$argv"

  test -e $file
  and nvim $file
  or echo -ne 'i#!/bin/sh\n\nchromium --app="https://"i' \
    | nvim -c 'setf sh' -s - -- $file

  chmod 700 $file ^ /dev/null
end

# xsel
abbr xsel="xsel --clipboard"
abbr xso="xsel --clipboard -o"
abbr xsi="xsel --clipboard -i"

# aria2c
abbr dl="aria2c --dir=$HOME/Downloads"

# curl
abbr c="curl"
abbr co="curl -O"

# youtube-dl
abbr yv="youtube-dl -fbest"
abbr yvv="youtube-dl -fbest (xsel --clipboard -o)"
abbr ym="youtube-dl -fbestaudio"
abbr ymm="youtube-dl -fbestaudio (xsel --clipboard -o)"

# Zathura
abbr z="zathura"

# Various CLI utils
abbr tree="tree -C"
abbr less="less -R"

# atool
abbr atx="aunpack"
abbr atp="apack"

# YAY
abbr y="yay"
abbr yqs="yay -Qs"
abbr ys="yay -S"
abbr yss="yay -Ss --color=always"
abbr ysuy="yay -Suy"
abbr yr="yay -Rs"
abbr yrc="yay -Rsc"
alias lspkg="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
abbr dot="cd ~/git/dotfiles"
abbr jt="cd ~/git/jobteaser/jobteaser"
abbr ct="cd ~/git/jobteaser/cockpit"
abbr sand="cd ~/sandbox"

# SSH
abbr ssh-wtf="cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
abbr g="git"
abbr gcd="cd (git rev-parse --show-toplevel)"
abbr ga="git add"
abbr gb="git branch"
abbr gd="git d"
abbr gds="git ds"
abbr gcl="git clone"
abbr gci="git commit"
abbr gco="git checkout"
abbr gl="git log"
abbr glg="git lg"
abbr gllg="git llg"
abbr gpl="git pull"
abbr gps="git push"
abbr gr="git rebase"
abbr grc="git rebase --continue"
abbr gs="git status -s -b"

# Rails / Rake / Bundler
abbr r="rails"
abbr rc="rails console"
abbr rs="bundle exec rails server"
abbr be="bundle exec"
abbr rdm="bundle exec rake db:migrate db:test:prepare"
abbr rds="bundle exec rake db:migrate:status | tail"
abbr rpp="bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Docker
abbr dc="docker-compose"
abbr dcu="docker-compose up -d"
abbr dcd="docker-compose down"
abbr d="docker"

# Kubernetes
abbr k="kubectl"
