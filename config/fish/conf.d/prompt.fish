set async_prompt_functions _git

function _git_branch_name
  set -l branch (command git symbolic-ref HEAD 2> /dev/null)
    and set -l branch (echo $branch | sed 's#refs/heads/##' | sed -E 's#(tl/[a-zA-Z]{3}-[0-9]+).*#\1#')
    and echo " $branch "
    and return

  set -l tag (command git describe --tags --exact-match 2> /dev/null)
    and echo "󰓽 $tag "
    and return

  set -l ref (command git show-ref --head -s --abbrev | head -n1)
    and echo " $ref "
    and return
end

function _git_ahead
  set -l ahead 0
  set -l behind 0

  for line in (command git rev-list --left-right '@{upstream}...HEAD' 2> /dev/null)
    switch "$line"
      case '>*'
        if [ $behind -eq 1 ]
          echo " "
          return
        end
        set ahead 1
      case '<*'
        if [ $ahead -eq 1 ]
          echo " "
          return
        end
        set behind 1
    end
  end

  if [ $ahead -eq 1 ]
    echo "󰧝 "
  else if [ $behind -eq 1 ]
    echo "󰧗 "
  end
end

function _git
  # Check if we are in a git repository
  [ (command git rev-parse --git-dir 2> /dev/null) ]
    or return

  [ (command git rev-parse --is-inside-git-dir 2> /dev/null) = "true" ]
    and return

  set -l stashed
  switch (command git stash list | wc -l)
    case 0
      set stashed ''
    case 1
      set stashed " 󰎤 "
    case 2
      set stashed " 󰎧 "
    case 3
      set stashed " 󰎪 "
    case '*'
      set stashed " 󰼑 "
  end

  set -l dirty \
    (command git diff --no-ext-diff --quiet --exit-code; or echo -n "󱦢 ")
  set -l staged \
    (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n "󱊖 ")
  set -l ahead \
    (_git_ahead)

  set -l new ''
  set -l show_untracked (command git config --bool bash.showUntrackedFiles)
  if [ "$show_untracked" != 'false' ]
    set -l untracked (command git ls-files --other --exclude-standard --directory --no-empty-directory)
    [ "$untracked" ]
      and set new " "
  end

  set -l flags "$stashed$dirty$staged$ahead$new"

  if [ "$dirty" ]
    set_color yellow
  else
    set_color green
  end

  echo -ns (_git_branch_name) $flags

  set_color normal
end

function _jobs
  set -l jobs_count (jobs | wc -l)

  [ $jobs_count -gt 0 ]
    or return

  echo -ns ' '(set_color brmagenta)
  switch $jobs_count
    case 0
    case 1
      echo -ns 󰎤
    case 2
      echo -ns 󰎧
    case 3
      echo -ns 󰎪
    case '*'
      echo -ns 󰼑
  end
  echo -ns (set_color normal)
end

function _pwd
  echo -ns ' '(set_color blue)(prompt_pwd)(set_color normal)' '
end

function fish_prompt
  set -l last_status $status

  _jobs
  _pwd
  _git

  [ $last_status = 0 ]
    and set_color normal
    or set_color red

  set -l count $SHLVL
  if set -q NVIM
    set count (math $count-1)
  end

  for x in (seq $count); echo -ns "❯"; end

  echo -ns ' '

  set_color normal
end
