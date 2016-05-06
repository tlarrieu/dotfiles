setlocal foldlevel=10
setlocal foldmethod=marker
setlocal foldminlines=1

nnoremap <buffer> <return> :so %<cr>
nnoremap <buffer> <leader><return> :so %<cr>:PlugClean<cr>:PlugInstall<cr>
