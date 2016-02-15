setlocal foldlevel=10
setlocal foldmethod=marker
setlocal foldminlines=1

noremap <buffer> <return> :so %<cr>
noremap <buffer> <leader><return> :so %<cr>:PlugClean<cr>:PlugInstall<cr>
