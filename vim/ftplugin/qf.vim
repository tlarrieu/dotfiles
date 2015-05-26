setlocal nonumber

nnoremap <silent> <buffer>   <c-w><cr><c-w>T
nnoremap <silent> <buffer> t <C-w><CR><C-w>TgT<C-w>p
nnoremap <silent> <buffer> o <CR><C-w>p<C-w>=
nnoremap <silent> <buffer> v <C-w>p<C-w>v<C-w>b<CR><C-w>=
nnoremap <silent> <buffer> s <C-w>p<C-w>s<C-w>b<CR><C-w>=

call AdjustWindowHeight(5, 20)
