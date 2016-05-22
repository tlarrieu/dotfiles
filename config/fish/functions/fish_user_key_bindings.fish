fzf_key_bindings

function fkill
  echo '' > /tmp/fzf.kill
  ps ux | sed 1d | fzf -m | awk '{print $2}' > /tmp/fzf.kill

  kill -9 (cat /tmp/fzf.kill) 2> /dev/null
end

function fzf-gitbranch
  set -q FZF_CTRL_B_COMMAND; or set -l FZF_CTRL_B_COMMAND "git branch -a"
  eval "git branch -a | fzf --extended --nth=2.. -d ' ' -m > $TMPDIR/fzf.result"
  and commandline -i (cat $TMPDIR/fzf.result | cut -c3- | sed 's#remotes/origin/##')
  commandline -f repaint
  rm -f $TMPDIR/fzf.result
end

bind \et 'fkill'
bind þ 'fkill'

bind \ea 'sh ~/scripts/fshow.sh'
bind æ 'sh ~/scripts/fshow.sh'

bind \cb 'fzf-gitbranch'

if bind -M insert > /dev/null 2>&1
  bind -M insert \et 'fkill'
  bind -M insert þ 'fkill'
  bind -M insert \ea 'sh ~/scripts/fshow.sh'
  bind -M insert æ 'sh ~/scripts/fshow.sh'
  bind -M insert \cb 'fzf-gitbranch'
end
