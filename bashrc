# rbenv
if type rbenv > /dev/null; then
  set RBENV_ROOT /usr/local/var/rbenv
  eval "$(rbenv init -)"
fi

export PATH="$HOME/.rbenv/bin:$PATH"

# FZF
export FZF_DEFAULT_OPTS='--color fg:240,bg:15,hl:33,fg+:241,bg+:7,hl+:33'
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# Yaourt
export YAOURT_COLORS="nb=1:pkg=1:ver=1;32:lver=1;45:installed=1;42:grp=1;34:od=1;41;5:votes=1;44:dsc=0:other=1;35"

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------

# Vim + ranger
alias python2="python2.7"
alias v="nvim"
alias vimrc="nvim ~/.vimrc"
alias vir="nvim -R"
alias vip="nvim -c 'setlocal nomod | setlocal ro' -"
alias r="ranger"

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

# Kill
alias k="kill -9"
alias kbg="kill (jobs -p)"

# cd
alias shops="cd ~/mercurial/shopmium/shops"
alias serv="cd ~/mercurial/shopmium/server"
alias mob="cd ~/Dev/shopmium-mobile/Shopmium"
alias dot="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"
alias budget="cd ~/git/budget"
alias dand="cd ~/git/dand.io"

# ls
alias l="ls"
alias ls="ls --color"

# SSH agent
alias kc="keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa"

# Git
alias g="git"
alias gcd="cd (git rev-parse --show-toplevel)"
alias ga="git add"
alias gb="git branch"
alias gbs="git branches"
alias gd="git difftool"
alias gcl="git clone"
alias gci="git commit"
alias gcia="git commit --amend"
alias gco="git checkout"
alias gf="git fetch"
alias gl="git log"
alias glg="git lg"
alias glgs="git lgs"
alias gpl="git pull"
alias gps="git push"
alias gs="git status"
alias gspr="git diff --name-status master..HEAD"
alias gdpr="git difftool master..HEAD"

# Heroku console
alias hrc="heroku run console -a $*"

# Rails
alias rc="bin/rails console"
alias rs="bin/rails server"
alias rrs="rescue rails server"
alias rud="rvm use default"
alias rus="rvm use system"
alias be="bin/bundle exec"
alias bi="bin/bundle install"
alias bu="bin/bundle update"
alias bspec="bin/bundle exec rspec"
alias bguard="bin/bundle exec guard"
alias mig="rails generate migration $*"

# Rake / Bundler
alias raklette="bin/bundle exec rake parallel:spec"
alias be="bin/bundle exec"
alias bspec="bin/bundle exec rspec"
alias rdm="bin/bundle exec rake db:migrate"
alias rds="bin/bundle exec rake db:migrate:status"
alias rpp="bin/bundle exec rake parallel:prepare"
alias rdtp="bin/bundle exec rake db:test:prepare"
alias rdr="bin/rake db:migrate:redo"
alias rdd="rake db:migrate:down VERSION=$*"
alias rdu="rake db:migrate:up VERSION=$*"
