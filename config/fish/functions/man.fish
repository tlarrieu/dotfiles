function man
  set PAGER /bin/sh\ -c\ \"unset\ PAGER\;col\ -b\ -x\ \|\ vim\ -c\ \'set\ ft=man\ nomod\ nolist\'\ -\"
  command man $argv | eval $PAGER
end
