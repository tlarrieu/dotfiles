# name: clearance2
# ---------------
# Based on clearance. Display the following bits on the left:
# - Current directory name
# - Git branch and dirty state (if inside a git repo)
# - Hg branch and dirty state (if inside hg repo)

set branch_glyph \uE0A0

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _hg_branch_name
  echo (command hg prompt "{$branch_glyph {branch} }" ^/dev/null)
end

function _hg_is_dirty
  echo (command hg status -m -n ^/dev/null)
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l yellow (set_color yellow)
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l green (set_color green)
  set -l normal (set_color normal)

  set -l cwd $blue(pwd | sed "s:^$HOME:~:")

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Print pwd or full path
  echo -n -s $cwd $normal

  # Show git branch and status
  if [ (_git_branch_name) ]
    set -l git_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set git_info $yellow $branch_glyph ' ' $git_branch
    else
      set git_info $green $branch_glyph ' ' $git_branch $normal
    end
    echo -n -s ' · ' $git_info $normal
  else
    # Show hg branch and status
    if [ (_hg_branch_name) ]
      set -l hg_branch (_hg_branch_name)
      if [ (_hg_is_dirty) ]
        set hg_info $yellow $hg_branch $normal
      else
        set hg_info $green $hg_branch $normal
      end
      echo -n -s ' · ' $hg_info $normal
    end
  end

  # Terminate with a nice prompt char
  echo -e ''
  echo -e -n -s '⟩ ' $normal
end
