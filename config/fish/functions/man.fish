function man
  /bin/sh -c "
    man $argv 1>/dev/null &&
    man $argv |
    nvim -p -c 'set ft=man nomodified nolist nomodifiable' -
    "
end
