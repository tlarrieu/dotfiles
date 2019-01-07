# rbenv
if type rbenv > /dev/null; then
  set RBENV_ROOT /usr/local/var/rbenv
  eval "$(rbenv init -)"
fi

export PATH="$HOME/.rbenv/bin:$PATH"

# FZF
[ -f ~/.fzf.bash ] && source ~/.fzf.bash

eval $(ssh-agent) > /dev/null

export NVM_DIR="$HOME/.nvm"
# Load nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# Load nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
