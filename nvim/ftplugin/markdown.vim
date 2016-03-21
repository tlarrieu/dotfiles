function! Grip()
  let filename = expand('%')
  vnew
  call termopen('grip ' . filename)
  execute "normal! \<c-w>p"
endfunction

nnoremap <silent> <cr> :call Grip()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10
