function fish_user_key_bindings
  fzf_key_bindings

  function fkill
    echo '' > /tmp/fzf.kill
    ps ux | sed 1d | fzf -m -e | awk '{print $2}' > /tmp/fzf.kill

    kill -9 (cat /tmp/fzf.kill) 2> /dev/null
  end

  function fzf-gitbranch
    set -q FZF_CTRL_B_COMMAND; or set -l FZF_CTRL_B_COMMAND "git branch -a"
    eval "$FZF_CTRL_B_COMMAND | fzf --extended --nth=2.. -d ' ' -m -e > /tmp/fzf.result"
    and commandline -i (
      cat /tmp/fzf.result | \
      cut -c3- | \
      sed 's#remotes/origin/##' | \
      tr '\n' ' ' | \
      sed 's# +##'
    )
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  function fzf-gitfiles
    set -q FZF_CTRL_X_COMMAND
    or  set -l FZF_CTRL_X_COMMAND "git -c color.status=always status --short"
    set -l fzf_command "fzf --extended --ansi --nth=2.. -d ' ' -m -e"
    eval "$FZF_CTRL_X_COMMAND | $fzf_command > /tmp/fzf.result"
    and commandline -i (
      cat /tmp/fzf.result \
        | awk '{$1=""} {print}' \
        | cut -d' ' -f2- \
        | sed -E "s/.*/'\0'/g" \
        | sed -E 's/"//g' \
        | paste -d' ' -s -
    )
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  function fzf-gitsha
    set -q FZF_GIT_LOG_COMMAND; or set -l FZF_GIT_LOG_COMMAND "git llga"
    eval "$FZF_GIT_LOG_COMMAND |\
      fzf --ansi --no-sort --reverse --tiebreak=index -e\
      --preview '~/scripts/fzf-git.sh {}'\
      > /tmp/fzf.result"
    and commandline -i (cat /tmp/fzf.result | grep -o '[a-f0-9]\{7\}' | head -1)
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  function enforce-git
    [ (command git rev-parse --git-dir 2> /dev/null) ]
      and return 0

    tput setaf 1
    echo "Not a git repository"
    tput sgr0

    commandline -f repaint
    return 1
  end

  function fzf-tw
    eval "task fzf \
        rc._forcecolor:yes \
        rc.row.padding:0 \
        rc.defaultwidth:240 \
        rc.detection:off \
        rc.verbose:nothing | \
      tail -n +4 | \
      fzf --ansi --multi --exact --prompt 'task?> ' \
      > /tmp/fzf.tw.result"
    and commandline -i (
      cat /tmp/fzf.tw.result \
      | awk '{print $1}' \
      | xargs echo -n
    )
    commandline -f repaint
    rm -f /tmp/fzf.result
  end

  bind þ 'fkill'
  bind æ 'enforce-git; and fzf-gitsha'
  bind ù 'fzf-tw'
  bind \cb 'enforce-git; and fzf-gitbranch'
  bind \cx 'enforce-git; and fzf-gitfiles'
end
