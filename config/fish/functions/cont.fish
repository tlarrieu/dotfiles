function cont
  echo "CONTEXT=\"$argv\"" > ~/.context.env
  task context $argv
end
