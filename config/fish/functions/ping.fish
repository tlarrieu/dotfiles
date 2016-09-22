function ping
  if count $argv > 0
    command ping $argv
  else
    # Most of the time, I just want to check for internet connection
    command ping www.google.com
  end
end
