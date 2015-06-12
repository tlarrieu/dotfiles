fzf_key_bindings

function fkill
  echo '' > /tmp/fzf.kill
  ps ux | sed 1d | fzf -m | awk '{print $2}' > /tmp/fzf.kill

  kill -9 (cat /tmp/fzf.kill) 2> /dev/null
end

bind \et 'fkill'

if bind -M insert > /dev/null 2>&1
  bind -M insert \et 'fkill'
end
