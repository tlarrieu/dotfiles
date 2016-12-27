setlocal nonumber
setlocal norelativenumber
setlocal nobuflisted

nnoremap <silent> <buffer> <leader><cr> :Qfreplace tabedit<cr>

" Preview
nnoremap <silent> <buffer> o <cr><c-w>p

" Open in new tab / vsplit / split and focus quickfix
nnoremap <silent> <buffer> <nowait> <leader>t <c-w><cr><c-w>TgT<c-w>p:call AdjustWindowHeight(5, 20)<cr>gt
nnoremap <silent> <buffer> <nowait> <leader>v <c-w><cr><c-w>L<c-w>p<c-w>J:call AdjustWindowHeight(5, 20)<cr><c-w>p
nnoremap <silent> <buffer> <nowait> <leader>s <c-w><cr><c-w>p<c-w>J:call AdjustWindowHeight(5, 20)<c-w>p

" Open in new tab / vsplit / split and focus new window
nnoremap <silent> <buffer> <nowait> <leader>T <c-w><cr><c-w>TgT<c-w>p:call AdjustWindowHeight(5, 20)<cr>
nnoremap <silent> <buffer> <nowait> <leader>V <c-w><cr><c-w>L<c-w>p<c-w>J:call AdjustWindowHeight(5, 20)<cr>
nnoremap <silent> <buffer> <nowait> <leader>S <c-w><cr><c-w>p<c-w>J:call AdjustWindowHeight(5, 20)<cr>

call AdjustWindowHeight(5, 20)
