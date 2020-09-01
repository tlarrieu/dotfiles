cabbrev ag Ack!
cabbrev ack Ack!
cabbrev chmod silent !chmod %<left><left>
cabbrev rm !rm
cabbrev mkdir !mkdir
cabbrev gv GV
cabbrev xsel r!xsel --clipboard -o

" Always open help in a new tab
cnoreabbrev <expr> h
  \ getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

iabbrev xdate <c-r>=strftime("%d %b %Y")<cr>
iabbrev Xdate <c-r>=strftime("%d %b %Y")<cr>
