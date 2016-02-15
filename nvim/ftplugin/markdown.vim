" nnoremap <buffer> <cr> zMzv

function! Pandoc()
  let filename = expand('%')
  execute "!pandoc -f markdown_github -t docx " . filename . " -o " . filename . '.docx'
endfunction

nnoremap <silent> <cr> :call Pandoc()<cr>

setlocal foldlevel=1
setlocal foldlevelstart=10
