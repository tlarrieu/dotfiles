set PATH $PATH $HOME/.rvm/bin
set PATH $PATH /usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games
set PATH $PATH /home/smockey/bin:.:/home/smockey/scripts
set PATH $PATH /usr/local/heroku/bin
set PATH $PATH /opt/local/bin
set PATH /Library/PostgreSQL/9.2/bin $PATH

set PGHOST localhost

set GTK_IM_MODULE=xim
set GEDITOR=gvim
set EDITOR=vim
set TERM="xterm-256color"
stty -ixon

alias python2="python2.7"
alias vi="vim"
alias vimrc="vim ~/.vimrc"
alias zshrc="vim ~/.zshrc"
alias preztorc="vim ~/.zpreztorc"
alias todo="cat ~/.todo 2>/dev/null"
alias vitodo="vi ~/todo.md"
alias vir="vi -R"

alias ccat="pygmentize -g"
alias tree="tree -C"
alias less="less -r"
alias wee="weechat-curses"
alias a="atool"
alias atx="atool -x"
alias g="git"
alias vip="vim -MR -"

alias shops="cd ~/mercurial/shopmium/shops"
alias server="cd ~/mercurial/shopmium/server"

function fish_prompt
    ~/git/powerline-shell/powerline-shell.py $status --shell bare ^/dev/null
end

