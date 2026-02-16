# rbenv
if type rbenv > /dev/null 2>&1; then
  set RBENV_ROOT /usr/local/var/rbenv
  eval "$(rbenv init -)"
fi

export PATH="$HOME/.rbenv/bin:$PATH"
export PATH="$HOME/scripts:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval $(ssh-agent) > /dev/null
trap 'kill -9 $SSH_AGENT_PID' EXIT

export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# Load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

function refresh {
  tput clear || exit 2; # Clear screen. Almost same as echo -en '\033[2J';
  bash -ic "$@";
}

# Like watch, but with color
function cwatch {
  while true; do
    CMD="$@";
    # Cache output to prevent flicker. Assigning to variable
    # also removes trailing newline.
    output=`refresh "$CMD"`;
    # Exit if ^C was pressed while command was executing or there was an error.
    exitcode=$?; [ $exitcode -ne 0 ] && exit $exitcode
    printf '%s' "$output";  # Almost the same as echo $output
    sleep 1;
  done;
}
