function! RenderMarkdown()
  let filename = expand('%')
  vnew
  call termopen('markfly ' . filename . ' 2> /dev/null')
  execute "normal! \<c-w>p"
endfunction

nnoremap <silent> <cr> :call RenderMarkdown()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10
