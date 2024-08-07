abbr --erase (abbr --list)

function resource
  source ~/.config/fish/config.fish
  source ~/.config/fish/conf.d/aliases.fish
end

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

# hledger
abbr h hledger
function ft
  set -l flags --strict
  switch $argv[1]
  case edit
    nvim -p (readlink -f ~/.hledger/current.journal)
    return
  case bal bs bse is cf roi
    set flags $flags --pretty --auto
    if [ $argv[1] != roi ]
      set flags $flags --layout=tall
    end
    if [ $argv[1] = bse ]
      # resolve accounting equation
      set flags $flags --alias '/^(income|expenses)/=equity:\1'
    end
  case now
    ft bal --empty -p today -H assets:cash assets:check assets:savings
    ft bal --empty -p thismonth expenses:groceries
    ft bal --empty -p thisyear expenses:clothing expenses:gifts
    return
  case up upcoming
    ft bal --fore=tomorrow..nextmonth tag:generated-transaction
    return
  case weeks
    ft bs --fore=tomorrow.. -W -b today -p 1month not:tag:miriam
    return
  case fut future
    ft bs --fore=tomorrow.. -M -b 1 -e 6months not:tag:miriam
    return
  end

  echo -n -e "\e[1;38m"
  echo hledger $argv $flags
  echo -n -e "\e[0m"

  hledger $argv 1> /dev/null; and hledger -f ~/.hledger.journal $argv $flags
end

# xsel
abbr xo "xsel --clipboard -o"
abbr xi "xsel --clipboard -i"

# newsboat
abbr nb newsboat

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
abbr ,m "cd ~/Music"
abbr ,n "cd ~/.neorg/"
abbr ,o "cd ~/Downloads"
abbr ,p "cd ~/Pictures"
abbr ,ps "cd ~/.password-store"
abbr ,r "cd ~/git/rss"
abbr ,s "cd ~/scripts"
abbr ,v "cd ~/Videos"
abbr ,w "cd ~/Pictures/wallpapers"
abbr - "cd -"

# eza (ls)
abbr l "eza"
abbr la "eza --icons -A"
abbr ll "eza --icons -lAh"

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
abbr gl "git lg"
abbr glo "git lg origin.."
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

# fonts
abbr font "fc-list | grep -i"

# exercism
abbr ed "cd (echo (xsel --clipboard -o) | xargs -I{} /bin/sh -c '{}');
  git init;
  git add .;
  git commit -m 'First commit'"
abbr es "exercism submit"

# Routines
abbr rt "routine"

# nmap
abbr nmap "sudo nmap"

# searchsploits
abbr spl "searchsploit"
