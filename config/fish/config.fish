stty -ixon 2> /dev/null

set -x SUDO_ASKPASS ~/scripts/sudo-ask-pass

set -l fzf_common_opts '
  --reverse
  --color=bw
  --bind=ctrl-k:kill-line
  --border=none
  --no-scrollbar
'

set -x FZF_DEFAULT_COMMAND "fd --hidden --follow --exclude '.git'"
set -x FZF_DEFAULT_OPTS $fzf_common_opts

set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS $fzf_common_opts

# steam
set -x STEAM_FORCE_DESKTOPUI_SCALING 1.5

# ocaml
if type opam > /dev/null 2>&1
  eval (opam env)
end

# rbenv
if type rbenv > /dev/null 2>&1
  source (rbenv init - | psub)
end

# Postgres
set PGHOST localhost

# EDITOR
set -g -x EDITOR nvim

# BROWSER
set -g -x BROWSER browser-kiosk

# MANPAGER
set -g -x MANPAGER 'nvim +Man!'

# Go
set -x -U GOPATH $HOME/go

# LUA
if [ -z (echo $LUA_PATH | grep "$HOME/lua") ]
  set -x LUA_PATH $LUA_PATH "$HOME/lua/?.lua;;"
end

# JAVA
set -x JAVA_HOME "/usr/lib/jvm/java-21-openjdk/"

# PATH
if [ -z (echo $PATH | grep "$HOME/scripts") ]
  set -x PATH $PATH "$HOME/scripts"
end
if [ -z (echo $PATH | grep "$HOME/apps") ]
  set -x PATH $PATH "$HOME/apps"
end
set -x PATH $PATH $HOME/apps/ignore
set -x PATH $PATH $HOME/bin
set -x PATH $PATH $HOME/.local/bin
set -x PATH $HOME/.fly/bin $PATH
set -x PATH $HOME/.yarn/bin $PATH
set -x PATH $HOME/bin/helm $PATH
set -x PATH $PATH $HOME/.krew/bin
set -x PATH $PATH $GOPATH/bin

# dircolors
eval (dircolors -c ~/.dir_colors)

# TERM
set -gx TERM xterm-kitty

# ssh-agent
eval (ssh-agent -c) > /dev/null
trap 'kill -9 $SSH_AGENT_PID' EXIT

# fundle
fundle plugin 'edc/bass'
fundle plugin 'acomagu/fish-async-prompt'
fundle init

if [ -f ~/.env ]
  source ~/.env
end
