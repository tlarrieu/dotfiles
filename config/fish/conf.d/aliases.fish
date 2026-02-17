abbr --erase (abbr --list)

function resource
  source ~/.config/fish/config.fish
  source ~/.config/fish/conf.d/aliases.fish
end

# kittens
alias icat="kitten icat"

# xdg-open
abbr . "open"

# systemctl
abbr ctl "systemctl"

# bluetoothctl
abbr bctl "bluetoothctl"

# journalctl
abbr jctl "journalctl -xe"

# nmcli
abbr nmcli "nmcli --color yes"

# Pass
abbr j "just"

# Pass
abbr p "pass"

# NVIM
alias ep "nvim -R -"
abbr e "nvim"
abbr se "sudo nvim"
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
  or echo -ne 'i#!/bin/sh\n\nbrowser-kiosk $1 "https://"i' \
    | nvim -c 'setf sh' -s - -- $file

  chmod 700 $file ^ /dev/null
end

# vifm
abbr v vifm

# hledger
abbr h hledger

# xsel
abbr xo "xsel --clipboard -o"
abbr xi "xsel --clipboard -i"

# aria2c
abbr dl "aria2c (xsel --clipboard -o) --dir=."

# curl
abbr c "curl"
abbr co "curl -O"
abbr cc "curl (xsel --clipboard -o)"
abbr cco "curl -O (xsel --clipboard -o)"

# youtube-dl
abbr yv "yt-dlp --no-playlist (xsel --clipboard -o)"
abbr ym "yt-dlp -fbestaudio --no-playlist (xsel --clipboard -o)"

# Various CLI utils
abbr less "less -R"

# fd
abbr fd "fd -I -H"

# skim
abbr lg "sk -i -c 'rg --color=always --line-number "{}"'"

# atool
abbr dec "aunpack"
abbr comp "apack"

# apt
abbr a "sudo apt"
abbr aar "sudo apt autoremove"
abbr ai "sudo apt install"
abbr al "apt list --installed"
abbr ar "sudo apt remove"
abbr as "apt search"

# YAY
abbr y "yay"
abbr yqs "yay -Qs --color always"
abbr yqi "yay -Qi --color always"
abbr ys "yay -S --color always"
abbr yss "yay -Ss --color always"
abbr ysuy "yay -Suy"
abbr ysc "yay -Sc"
abbr yr "yay -Rs"
abbr yrc "yay -Rsc"
alias lspkg "awk 'BEGIN{while ((\"pacman -Qi\" |getline) > 0){ if (\$0 ~ /Name/) {name=\$3};{if (\$0 ~ /Size/) {size=\$4/1024;print name\": \",size,\"Mb\"|\"sort -k2 -n|column -t\"}}}}'"

# cd
abbr ,a "cd ~/apps"
abbr ,b "cd ~/sandbox"
abbr ,c "cd ~/git/dotfiles"
abbr ,g "cd ~/git"
abbr ,. "cd ~/dev"
abbr ,d "cd ~/Documents"
abbr ,m "cd ~/Music"
abbr ,n "cd ~/.neorg/"
abbr ,o "cd ~/Downloads"
abbr ,p "cd ~/Pictures"
abbr ,ps "cd ~/.password-store"
abbr ,r "cd ~/git/rss"
abbr ,s "cd ~/Pictures/screenshots"
abbr ,v "cd ~/Videos"
abbr ,w "cd ~/Pictures/wallpapers"
abbr - "cd -"

# eza (ls)
abbr l "eza"
abbr ls "eza"
abbr la "eza --icons -A"
abbr ll "eza --icons -lAh"
abbr tree "eza --tree --icons"

# SSH
abbr sa "ssh-add"
abbr ssh-wtf "cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
abbr g "git"
abbr gcd "cd (git rev-parse --show-toplevel)"
abbr ga "git add"
abbr ga. "git add ."
abbr gb "git branch"
abbr gbd "git branch -d"
abbr gd "git d"
abbr gds "git ds"
abbr gcl "git clone (xsel --clipboard -o)"
abbr gci "git commit"
abbr gco "git checkout"
abbr gcb "git checkout -b"
abbr gi "git init"
abbr gl "git lg"
abbr gll "git llg"
abbr glo "git lg origin.."
abbr gu "git pull --rebase"
abbr gp "git push --force-with-lease"
abbr gr "git rebase"
abbr gri "git rebase -i"
abbr grc "git rebase --continue"
abbr gs "git status -s -b"
abbr gst "git stash"
abbr gstk "git stash --keep-index"
abbr gstp "git stash pop"
abbr gstd "git stash drop"

# Rails / Rake / Bundler
abbr r "bin/rails"
abbr rc "bin/rails console"
abbr rs "bin/rails server"
abbr be "bundle exec"
abbr bi "bundle install"
abbr bu "bundle update"
abbr rdm "bin/rails db:migrate"
abbr rdr "bin/rails db:rollback"
abbr rds "bin/rails db:migrate:status | tail"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Various languages
abbr py "python"
abbr py2 "python2"
abbr rb "ruby"

# Docker
abbr d "docker"
abbr dc "docker compose"
abbr dcu "docker compose up -d"
abbr dcd "docker compose down"

# Kubernetes
abbr k "kubectl"
abbr krew "kubectl-krew"
function ksh; kubectl exec -it $argv -- /bin/bash; end
abbr kns "kubens"
abbr kctx "kubectx"

# fonts
abbr font "fc-list | grep -i"

# nmap
abbr nmap "sudo nmap"

# searchsploits
abbr spl "searchsploit"

# tealdeer
abbr tl "tldr"

# rustormy
abbr st "rustormy"
