function man
  set PAGER /bin/sh -c "unset PAGER;col -b -x | \
    nvim -c 'set ft=man nomodified nolist nomodifiable' -"
  command man $argv | eval $PAGER
end
