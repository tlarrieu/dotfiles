# reset terminal
abbr cls " echo -ne \\033c"

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

# Zathura
abbr z "zathura"

# Various CLI utils
abbr tree "tree -C"
abbr less "less -R"

# fd
abbr fd "fd -I -H"

# atool
abbr atx "aunpack"
abbr atp "apack"

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
abbr ,d "cd ~/Documents"
abbr ,o "cd ~/Downloads"
abbr ,m "cd ~/Music"
abbr ,e "cd ~/Documents/management"
abbr ,i "cd ~/Documents/management/individual"
abbr ,p "cd ~/Pictures"
abbr ,ps "cd ~/.password-store"
abbr ,s "cd ~/scripts"
abbr ,v "cd ~/Videos"
abbr ,w "cd ~/Pictures/wallpapers"
abbr ,n "cd ~/.neorg"
abbr ,pf "cd ~/git/phantombuster/pb2-front"
abbr ,pb "cd ~/git/phantombuster/pb2-back"
abbr ,pd "cd ~/git/phantombuster/platform-docs"
abbr - "cd -"

abbr ,l "open (ls -1tc | head -n 1)"

# ls(d)
abbr l "lsd"
abbr la "lsd -A"
abbr ll "lsd -lAh"

# SSH
abbr sa "ssh-add"
abbr ssh-wtf "cat ~/.ssh/config | grep Host | grep -v Hostname | sort | sed 's/Host //'"

# Git
abbr g "git"
abbr gcd "cd (git rev-parse --show-toplevel)"
abbr ga "git add"
abbr ga. "git add ."
abbr gb "git branch"
abbr gd "git d"
abbr gds "git ds"
abbr gcl "git clone (xsel --clipboard -o)"
abbr gci "git commit"
abbr gco "git checkout"
abbr gi "git init"
abbr gl "git llg"
abbr glg "git lg"
abbr gllg "git llg"
abbr gpl "git pull"
abbr gpr "git pull --rebase"
abbr gps "git push"
abbr gr "git rebase"
abbr gri "git rebase -i"
abbr grc "git rebase --continue"
abbr gs "git status -s -b"
abbr gst "git stash"
abbr gstk "git stash --keep-index"
abbr gstp "git stash pop"

# Rails / Rake / Bundler
abbr r "rails"
abbr rc "rails console"
abbr rs "bundle exec rails server"
abbr be "bundle exec"
abbr bi "bundle install"
abbr bu "bundle update"
abbr rdm "bundle exec rake db:migrate db:test:prepare"
abbr rds "bundle exec rake db:migrate:status | tail"
abbr rpp "bundle exec rake parallel:prepare"
function rdd; bundle exec rake db:migrate:down VERSION=$argv; end
function rdu; bundle exec rake db:migrate:up VERSION=$argv; end

# Various languages
abbr py "python"
abbr py2 "python2"
abbr rb "ruby"

# Hoogle
abbr h "hoogle"
abbr b "bhoogle"

# Docker
abbr dc "docker-compose"
abbr dcu "docker-compose up -d"
abbr dcd "docker-compose down"
abbr d "docker"

# Kubernetes
abbr k "kubectl"
abbr krew "kubectl-krew"
function ksh; kubectl exec -it $argv -- /bin/bash; end
abbr kns "kubens"
abbr kctx "kubectx"

# stack (haskell)
abbr s "stack"

# fonts
abbr font "fc-list | grep -i"

# exercism
abbr ed "cd (echo (xsel --clipboard -o) | xargs -I{} /bin/sh -c '{}');
  git init;
  git add .;
  git commit -m 'First commit'"
abbr es "exercism submit"

# Taskwarrior
abbr t "task"
abbr t. "task annotate"
abbr ta "task add +inbox"
abbr td "task done"
abbr te "task edit"
abbr to "taskopen"
abbr tp "task planner"
abbr ts "task mod -inbox -someday sched:today"
abbr tS "task mod sched: +inbox"
abbr tt "task rm"
abbr tu "task undo"
abbr tw "task mod wait:"
abbr ty "task sync"
abbr start "task start"
abbr stop "task stop"

# Routines
abbr rt "routine"

# nmap
abbr nmap "sudo nmap"

# searchsploits
abbr spl "searchsploit"
