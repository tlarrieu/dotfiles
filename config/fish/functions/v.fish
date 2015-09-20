function v
  if test -z $argv
    nvim .
    return
  end
  nvim $argv
end
