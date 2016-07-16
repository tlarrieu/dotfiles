setlocal foldlevel=10
setlocal foldmethod=marker
setlocal foldminlines=1

nnoremap <silent> <buffer> <return> :so %<cr>
nnoremap <silent> <buffer> <leader><return> :so %<cr>:PlugClean<cr>:PlugInstall<cr>
