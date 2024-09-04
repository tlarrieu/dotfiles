stty -ixon 2> /dev/null

set -x SUDO_ASKPASS ~/scripts/sudo-ask-pass

# FZF
set -l fzf_main_color '#268bd2' # blue
set -l fzf_secondary_color '#d33682' # magenta

set -l fzf_common_opts "
  --reverse
  --color=bw
  --color=query:$fzf_main_color:regular
  --color=fg+:$fzf_main_color:regular
  --color=pointer:$fzf_main_color:regular
  --color=hl:$fzf_secondary_color:underline
  --color=hl+:$fzf_secondary_color:underline
  --bind=ctrl-k:kill-line
  --border=none
  --no-scrollbar
"

set -x FZF_DEFAULT_COMMAND "fd --hidden --follow --exclude '.git'"
set -x FZF_DEFAULT_OPTS $fzf_common_opts

set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS $fzf_common_opts

# steam
set -x STEAM_FORCE_DESKTOPUI_SCALING 1.5

# ocaml
eval (opam env)

# rbenv
if type rbenv > /dev/null
  source (rbenv init - | psub)
end

# Postgres
set PGHOST localhost

# EDITOR
set -g -x EDITOR nvim
set -g -x BROWSER browser-kiosk

# Go
set -x -U GOPATH $HOME/go

# LUA
set -x LUA_PATH $LUA_PATH "$HOME/lua/?.lua;;"

# JAVA
set -x JAVA_HOME "/usr/lib/jvm/java-21-openjdk/"

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $HOME/apps $PATH
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
fundle init

# Load local configuration
if test -e ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end
