cnoreabbrev <expr> ag
  \ getcmdtype() == ":" && getcmdline() == 'ag' ? 'Ack!' : 'ag'
cnoreabbrev <expr> ack
  \ getcmdtype() == ":" && getcmdline() == 'ack' ? 'Ack!' : 'ack'
cnoreabbrev <expr> chmod
  \ getcmdtype() == ":" && getcmdline() == 'chmod' ? 'silent !chmod %<left><left>' : 'chmod'
cnoreabbrev <expr> rm
  \ getcmdtype() == ":" && getcmdline() == 'rm' ? 'DeleteFile' : 'rm'
cnoreabbrev <expr> mkdir
  \ getcmdtype() == ":" && getcmdline() == 'mkdir' ? '!mkdir' : 'mkdir'
cnoreabbrev <expr> gv
  \ getcmdtype() == ":" && getcmdline() == 'gv' ? 'GV' : 'gv'

" Always open help in a new tab
cnoreabbrev <expr> h
  \ getcmdtype() == ":" && getcmdline() == 'h' ? 'tab help' : 'h'

iabbrev xdate <c-r>=strftime("%d %b %Y")<cr>
iabbrev Xdate <c-r>=strftime("%d %b %Y")<cr>
