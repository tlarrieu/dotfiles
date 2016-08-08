setlocal foldlevel=10
setlocal foldmethod=marker
setlocal foldminlines=1

nnoremap <silent> <buffer> <return> :so %<cr>:echom expand('%') . ' sourced'<cr>
nnoremap <silent> <buffer> <leader><cr> :so %<cr>:PlugClean<cr>:PlugInstall<cr>

nnoremap <silent> K :help <c-r><c-w><cr>
