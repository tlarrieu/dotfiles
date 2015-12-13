function fkill
  echo '' > /tmp/fzf.kill
  ps ux | sed 1d | fzf -m | awk '{print $2}' > /tmp/fzf.kill

  kill -9 (cat /tmp/fzf.kill) 2> /dev/null
end

bind \et 'fkill'
bind þ 'fkill'

bind \eg 'sh ~/scripts/fshow.sh'
bind † 'sh ~/scripts/fshow.sh'

if bind -M insert > /dev/null 2>&1
  bind -M insert \et 'fkill'
  bind -M insert þ 'fkill'
  bind -M insert \eg 'sh ~/scripts/fshow.sh'
  bind -M insert † 'sh ~/scripts/fshow.sh'
end
