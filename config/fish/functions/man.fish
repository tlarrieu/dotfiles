function man
  set PAGER /bin/sh\ -c\ \"unset\ PAGER\;col\ -b\ -x\ \|\ nvim\ -c\ \'set\ ft=man\ nomod\ nolist\'\ -\"
  command man $argv | eval $PAGER
end
