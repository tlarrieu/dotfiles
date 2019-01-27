function _git_branch_name
  set -l branch (command git symbolic-ref HEAD ^/dev/null)
    and string replace 'refs/heads/' " " $branch " "
    and return

  set -l tag (command git describe --tags --exact-match ^/dev/null)
    and echo " $tag"
    and return

  set -l ref (command git show-ref --head -s --abbrev | head -n1 ^/dev/null)
    and echo "➦ $ref"
    and return
end

function _git_ahead
  set -l ahead 0
  set -l behind 0

  for line in (command git rev-list --left-right '@{upstream}...HEAD' ^/dev/null)
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
    echo " "
  else if [ $behind -eq 1 ]
    echo " "
  end
end

function _git_prompt
  # Check if we are in a git repository
  [ (command git rev-parse --git-dir 2> /dev/null) ]
    or return

  [ (command git rev-parse --is-inside-git-dir 2> /dev/null) = "true" ]
    and return

  set -l stashed \
    (command git rev-parse --verify --quiet refs/stash >/dev/null; and echo -n ' ')

  set -l dirty \
    (command git diff --no-ext-diff --quiet --exit-code ^/dev/null; or echo -n " ")
  set -l staged \
    (command git diff --cached --no-ext-diff --quiet --exit-code ^/dev/null; or echo -n " ")
  set -l ahead \
    (_git_ahead)

  set -l new ''
  set -l show_untracked (command git config --bool bash.showUntrackedFiles ^/dev/null)
  if [ "$show_untracked" != 'false' ]
    set -l untracked (command git ls-files --other --exclude-standard --directory --no-empty-directory ^/dev/null)
    [ "$untracked" ]
      and set new " "
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

function fish_prompt
  set -l last_status $status

  set -l blue (set_color blue)
  set -l cwd $blue(basename (pwd | sed "s:^$HOME:~:"))

  echo -ns ' '

  # Show background job if any
  [ (jobs | wc -l) -gt 0 ]
    and echo -ns " "

  # Print pwd or full path
  echo -n -s $cwd $normal " "

  # Show git branch and status
  _git_prompt

  if test $last_status = 0
    set_color normal
  else
    set_color red
  end

  echo -ns '❯ '

  set_color normal
end
