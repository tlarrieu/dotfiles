stty -ixon 2> /dev/null

# FZF
set -l color00 '#fdf6e3'
set -l color01 '#eee8d5'
set -l color02 '#93a1a1'
set -l color03 '#839496'
set -l color04 '#657b83'
set -l color05 '#586e75'
set -l color06 '#073642'
set -l color07 '#002b36'
set -l color08 '#dc322f'
set -l color09 '#cb4b16'
set -l color0A '#b58900'
set -l color0B '#859900'
set -l color0C '#2aa198'
set -l color0D '#268bd2'
set -l color0E '#6c71c4'
set -l color0F '#d33682'

set -l fzf_common_opts "
  --reverse
  --color=bg+:$color01,bg:$color00,spinner:$color0C,hl:$color0D
  --color=fg:$color04,header:$color0D,info:$color0A,pointer:$color0C
  --color=marker:$color0C,fg+:$color06,prompt:$color0A,hl+:$color0D
  --bind=ctrl-k:kill-line
  --no-scrollbar
"

set -x FZF_DEFAULT_COMMAND "rg -g '' --hidden --ignore .git"
set -x FZF_DEFAULT_OPTS $fzf_common_opts "--border=thinblock"

set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
set -x FZF_CTRL_T_OPTS $fzf_common_opts "--border=none"
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

# PATH
set -x PATH $PATH $HOME/scripts
set -x PATH $HOME/apps $PATH
set -x PATH $PATH $HOME/apps/ignore
set -x PATH $PATH $HOME/bin
set -x PATH $PATH $HOME/.local/bin
set -x PATH $PATH $HOME/.ghcup/bin

set -x PATH $HOME/.yarn/bin $PATH
set -x PATH $HOME/.ghcup/bin $PATH
set -x PATH $HOME/bin/helm $PATH
set -x PATH $PATH $HOME/.krew/bin

# JAVA
set -x JAVA_HOME "/usr/lib/jvm/java-21-openjdk/"

eval (dircolors -c ~/.dir_colors)

# Tab completions
if test -e /usr/share/doc/task/scripts/fish/task.fish
  source /usr/share/doc/task/scripts/fish/task.fish
end

set -x SUDO_ASKPASS ~/scripts/sudo-ask-pass

# TERM
set -gx TERM xterm-kitty

eval (ssh-agent -c) > /dev/null
trap 'kill -9 $SSH_AGENT_PID' EXIT

fundle plugin 'edc/bass'
fundle init

# Load local configuration

if test -e ~/.config/fish/local.fish
  source ~/.config/fish/local.fish
end
