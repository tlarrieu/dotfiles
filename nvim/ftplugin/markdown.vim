function! RenderMarkdown()
  let filename = expand('%')
  vnew
  call termopen('markfly ' . filename . ' 2> /dev/null')
  execute "normal! \<c-w>p"
endfunction

function! Pandoc()
  let filename = expand('%')
  execute "!pandoc -s " . filename . " -o " . filename .".pdf"
endfunction
command! Pandoc :call Pandoc()

nnoremap <silent> <buffer> <cr> :call RenderMarkdown()<cr>
nnoremap <silent> <buffer> <leader><cr> :call Pandoc()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10
