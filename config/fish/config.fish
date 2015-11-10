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
alias release="cd ~/mercurial/shopmium/server-release"
alias etl="cd ~/git/shopmium-etl"
alias mob="cd ~/Dev/shopmium-mobile/Shopmium"
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

# Mercurial
alias hcd="cd (hg root)"
alias hb="hg branch"
alias hbs="hg branches"
alias hci="hg commit"
alias hcia="hg commit --amend"
alias hcl="hg clone"
alias hd="hg diff"
alias hdpr="hg diff -r \"ancestor(default,.)\""
alias hspr="hg status --rev \"::. - ::default\""
function hdprc
  hg diff -r "ancestor($argv,.)"
end
function hsprc
  hg status --rev "::. - ::$argv"
end
alias hlb="hg log --graph -b"
alias hm="hg merge"
alias hpl="hg pull"
alias hplb="hg pull -b ."
alias hps="hg push"
alias hr="hg revert -C"
alias hrlu="hg resolve -l | grep U"
alias hrm="hg resolve -m"
alias hs="hg status (hg root)"
alias hsh="hg shelve"
alias hsl="hg shelve -l"
alias hu="hg update"
alias hus="hg unshelve"
alias rstruct="hg revert -C db/structure.sql"
alias hout="hg outgoing"
alias hin="hg incoming"
function htag
  set -l last_tag (tail -n 1 (hg root)/.hgtags | cut -c 42-)
  set -l release (echo $last_tag | cut -c -18)
  set -l date (date -jnu "+%Y.%m.%d")
  set -l tag

  if test "release-$date" = $release
    set -l iteration (echo $last_tag | cut -c 20-)

    if test -n $iteration
      set -l tag "release-$date-($iteration+1)"
    else
      set -l tag "release-$date-2"
    end
  else
    set -l tag "release-$date"
  end

  echo $tag
  # hg tag $tag
end

# Heroku console
function hrc
  heroku run console -a $argv
end

# pgbackup
alias ddump="curl (heroku pg:backups public-url -a shopmium) > ~/Downloads/last.dump"

# Zeus
alias zc="zeus console"
alias zg="zeus generate"
alias zs="zeus server"
alias zst="zeus start"

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

# Rake / Bundler
alias raklette="bin/bundle exec rake parallel:spec"
alias be="bin/bundle exec"
alias bspec="bin/bundle exec rspec"
alias rdm="bin/bundle exec rake db:migrate"
alias rds="bin/bundle exec rake db:migrate:status"
alias rpp="bin/bundle exec rake parallel:prepare"
alias rdtp="bin/bundle exec rake db:test:prepare"
alias rdr="bin/rake db:rollback"
alias rdre="bin/rake db:migrate:redo"
function rdd; bin/rake db:migrate:down VERSION=$argv; end
function rdu; bin/rake db:migrate:up VERSION=$argv; end

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
set -g -x NVIM_TUI_ENABLE_TRUE_COLOR 1

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

if type rbenv > /dev/null
  set -gx RBENV_ROOT /usr/local/var/rbenv
  source (rbenv init - | psub)
end

set -g theme_display_user yes
set -g default_user tlarrieu

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish

set -g SSL_CERT_FILE /etc/openssl/cert.pem

# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish

# Oh-my-fish theme
Theme 'clearance'
. $fish_path/themes/clearance/fish_prompt.fish

# Oh-my-fish plugins
Plugin 'rails'
Plugin 'brew'
Plugin 'bundler'
Plugin 'tmux'
Plugin 'theme'
