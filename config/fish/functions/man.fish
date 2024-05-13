function man
  command man $argv 1>/dev/null 2>/dev/null
  and command man $argv | nvim -c 'setf man'
end
