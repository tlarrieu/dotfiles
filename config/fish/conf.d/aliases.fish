# Vim
alias vip="nvim -c 'setlocal nomod | setlocal ro' -"
alias v="nvim"

# python
alias python2="python2.7"

# aria2c
alias dl="aria2c"

# mplayer
alias mp="mplayer"

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
alias ys="yaourt -S"
alias yss="yaourt -Ss"
alias ysuy="yaourt -Suy"
alias yr="yaourt -R"
alias list-packages="awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

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
alias gco="git checkout"
alias gf="git diff --name-only develop.."
alias gl="git log"
alias glg="git lg"
alias glgs="git lgs"
alias gpl="git pull"
alias gps="git push"
alias gs="git status -s -b"
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

# Rails / Rake / Bundler
alias rs="bin/rails server"
alias raklette="bin/bundle exec rake parallel:spec"
alias be="bin/bundle exec"
alias rdm="bin/bundle exec rake db:migrate"
alias rds="bin/bundle exec rake db:migrate:status | tail"
alias rpp="bin/bundle exec rake parallel:prepare"
alias rdtp="bin/bundle exec rake db:test:prepare"
alias rdr="bin/rake db:rollback"
alias rdre="bin/rake db:migrate:redo"
alias rr="bin/rake routes > routes"
function rdd; bin/rake db:migrate:down VERSION=$argv; end
function rdu; bin/rake db:migrate:up VERSION=$argv; end

# Exercism
alias e="exercism"
alias ef="exercism fetch"
alias es="exercism submit"
