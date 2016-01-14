setlocal nonumber

nnoremap <silent> <buffer>   <c-w><cr><c-w>T
nnoremap <silent> <buffer> t <c-w><cr><c-w>TgT<c-w>p
nnoremap <silent> <buffer> o <cr><c-w>p<c-w>=
nnoremap <silent> <buffer> v <c-w>p<c-w>v<c-w>b<cr><c-w>=
nnoremap <silent> <buffer> s <c-w>p<c-w>s<c-w>b<cr><c-w>=

call AdjustWindowHeight(5, 20)
