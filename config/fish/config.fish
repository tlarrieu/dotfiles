set PGHOST localhost

set GTK_IM_MODULE=xim
set -g -x GEDITOR mvim
set -g -x EDITOR vim
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
alias vip="vi -c AnsiEsc -"

alias rc="rails console"
alias rs="rails server"
alias rrs="rescue rails server"
alias rud="rvm use default"
alias rus="rvm use system"

alias gd="git diff"
alias gcl="git clone"
alias gs="git status"
alias gci="git commit"
alias gpl="git pull"
alias gps="git push"

alias hd="hg diff"
alias hdpr="hg diff -r \"ancestor(default,.)\""
function hdprc
  hg diff -r "ancestor($argv,.)"
end
alias hci="hg commit"
alias hcl="hg clone"
alias hlb="hg log --graph -b ."
alias hm="hg merge"
alias hpl="hg pull"
alias hplb="hg pull -b ."
alias hps="hg push"
alias hr="hg revert -C"
alias hrlu="hg resolve -l | grep U"
alias hs="hg status"
alias hu="hg update"

alias k="kill -9"
alias kbg="kill (jobs -p)"

alias epry="pry -r ./config/environment"
alias pspec="bundle exec rake parallel:spec"

alias shops="cd ~/mercurial/shopmium/shops"
alias serv="cd ~/mercurial/shopmium/server"
alias mob="cd ~/mercurial/shopmium/mobile"
alias dot="cd ~/git/dotfiles"
alias blog="cd ~/git/blog"
alias budget="cd ~/git/budget"

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
