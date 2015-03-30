 # name: clearance2
# ---------------
# Based on clearance. Display the following bits on the left:
# - Current directory name
# - Git branch and dirty state (if inside a git repo)
# - Hg branch and dirty state (if inside hg repo)

set branch_glyph \uE0A0
set superuser_glyph '⌬ '
set bg_job_glyph '⚑ '

function _git_branch_name
  echo (command git symbolic-ref HEAD ^/dev/null | sed -e 's|^refs/heads/||')
end

function _git_is_dirty
  echo (command git status -s --ignore-submodules=dirty ^/dev/null)
end

function _hg_branch_name
  echo (command hg branch ^/dev/null)
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

  set vcs_info ''
  set vcs_color $normal
  # Show git branch and status
  if [ (_git_branch_name) ]
    set vcs_branch (_git_branch_name)

    if [ (_git_is_dirty) ]
      set vcs_color $yellow
    else
      set vcs_color $green
    end
  else
    # Show hg branch and status
    if [ (_hg_branch_name) ]
      set vcs_branch (_hg_branch_name)

      if [ (_hg_is_dirty) ]
        set vcs_color $yellow
      else
        set vcs_color $green
      end
    end
  end

  # Output the prompt, left to right

  # Add a newline before new prompts
  echo -e ''

  # Print pwd or full path
  echo -n -s $blue(pwd | sed "s:^$HOME:~:") $normal

  if test (echo $vcs_branch)
    echo -n -s ' · ' $vcs_color $branch_glyph ' ' $vcs_branch $normal
  end

  # Ruby version
  echo -n -s ' @ ' $RUBY_VERSION

  echo -e -n -s $vcs_color ' ><(((°> ' $normal

  echo -e ''

  # if superuser (uid == 0)
  set -l uid (id -u $USER)
  if [ $uid -eq 0 ]
    echo -n $superuser_glyph
  end

  # Jobs display
  if [ (jobs -l | wc -l) -gt 0 ]
    echo -n $bg_job_glyph
  end

  # Terminate with a nice prompt char
  # echo -e -n -s 'λ ' $normal
  echo -e -n -s '∫ ' $normal
end

set -x fish_color_command green
