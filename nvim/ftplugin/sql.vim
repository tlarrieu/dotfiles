command! -range=% ExecuteSQL <line1>,<line2>call sql#execute()

nmap <silent> <buffer> <return> vip:ExecuteSQL<cr>
vmap <silent> <buffer> <return> :'<,'>ExecuteSQL<cr>
nmap <silent> <buffer> <leader><return> :call sql#identify('<c-r><c-w>')<cr>

" -- [[ Formatter ]] -----------------------------------------------------------
vmap <silent> <leader>i :!sqlformat - -r -k upper<cr>
