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

function _git_merge_head
  echo -ne (set_color -d red)
  if test (command git rev-parse -q --verify MERGE_HEAD 2> /dev/null)
    echo -n " "
  else if test (command git rev-parse -q --verify REBASE_HEAD 2> /dev/null)
    echo -n " "
  end
  echo -ne (set_color normal)
end

function _git_bisect
  echo -ne "\e[0;35m"
  if git bisect log &> /dev/null
    echo -n "󰩫 "
  end
  echo -ne "\e[0m"
end

function _git_ahead
  switch (command git rev-list @{u}...HEAD --left-right 2> /dev/null | cut -c1 | paste -sd '')
  case '*><*'
    echo '󰆖 '
  case '*<'
    echo '󰧖 '
  case '*>'
    echo '󰧜 '
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
      set stashed " 󰎤 "
    case 2
      set stashed " 󰎧 "
    case 3
      set stashed " 󰎪 "
    case '*'
      set stashed " 󰼑 "
  end

  set -l dirty (command git diff --no-ext-diff --quiet --exit-code; or echo -n "󱦢 ")
  set -l staged (command git diff --cached --no-ext-diff --quiet --exit-code; or echo -n "󱊖 ")
  set -l ahead (_git_ahead)

  set -l new ''
  set -l show_untracked (command git config --bool bash.showUntrackedFiles)
  if [ "$show_untracked" != 'false' ]
    set -l untracked (command git ls-files --other --exclude-standard --directory --no-empty-directory)
    [ "$untracked" ]
      and set new " "
  end

  set -l flags "$stashed$dirty$staged$ahead$new"

  set -l color
  if [ "$dirty" ]
    set color "yellow"
  else
    set color "green"
  end

  echo -nes (set_color -d $color)(_git_branch_name)(set_color normal)(_git_merge_head)(set_color -d $color)$flags(_git_bisect)(set_color normal)
end

function _git_loading_indicator
  if git -C (pwd) rev-parse 2> /dev/null
    echo -nes (set_color brblack)'󱫤 '(set_color normal)
  end
end

function _jobs
  set -l jobs_count (jobs | wc -l)

  [ $jobs_count -gt 0 ]
    or return

  echo -ns (set_color -d magenta)
  switch $jobs_count
    case 0
    case 1
      echo -ns 󰼏
    case 2
      echo -ns 󰼐
    case 3
      echo -ns 󰼑
    case '*'
      echo -ns 󰌴
  end
  echo -ns ' '(set_color normal)
end

function _pwd
  echo -ns (set_color -d)' '(set_color normal)(set_color -d blue)(prompt_pwd)(set_color normal)' '
end

function print_blank_line --on-event fish_postexec
  echo
end

function fish_prompt
  set -l last_status $status

  _pwd
  _git

  echo
  _jobs

  [ $last_status = 0 ]
    and set_color normal
    or set_color red

  set -l count $SHLVL
  if set -q NVIM
    set count (math $count-1)
    set count (math "max($count, 1)")
  end

  for x in (seq $count); echo -ns ""; end

  set_color normal

  echo -ns ' '
end
