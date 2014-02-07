set PGHOST localhost

set GTK_IM_MODULE=xim
set GEDITOR=gvim
set -g -x EDITOR=vim
set TERM="xterm-256color"
stty -ixon

alias python2="python2.7"
alias vi="vim"
alias vimrc="vi ~/.vimrc"
alias vir="vi -R"

alias gcd="cd (git rev-parse --show-toplevel)"

alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias wee="weechat-curses"
alias a="atool"
alias atx="atool -x"
alias g="git"
alias vip="vi -MR -c AnsiEsc -"

alias rc="rails console"
alias rs="rails server"
alias rud="rvm use default"
alias rus="rvm use system"

alias shops="cd ~/mercurial/shopmium/shops"
alias server="cd ~/mercurial/shopmium/server"
alias mobile="cd ~/mercurial/shopmium/mobile"
alias dotfiles="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"
alias budget="cd ~/git/budget"

alias ec2="ssh -i ~/.ssh/shopmium-deploy.pem ec2-user@ec2-176-34-102-3.eu-west-1.compute.amazonaws.com"

# Theme
set -g fish_theme smockey
set -g theme_display_user yes
set -g default_user thomaslarrieu

# Path to your oh-my-fish.
set fish_path $HOME/.oh-my-fish
# Oh-my-fish plugins
set fish_plugins rvm brew bundler git rails rake
# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $PATH /Library/PostgreSQL/9.2/bin
set -x PATH $PATH /usr/local/heroku/bin
# Load oh-my-fish configuration.
. $fish_path/oh-my-fish.fish
