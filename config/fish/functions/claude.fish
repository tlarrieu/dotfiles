function claude --wraps claude --description 'Claude Code with the settings from my dotfiles'
  command claude --settings ~/.config/claude/settings.json $argv
end
