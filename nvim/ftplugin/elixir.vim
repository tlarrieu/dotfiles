nnoremap <buffer> <return> :call neoterm#test#rerun()<cr>

augroup Test
  autocmd!
  autocmd BufEnter *_test.exs nnoremap <buffer> <leader><return> :call neoterm#test#run('file')<cr>
  autocmd BufEnter *_test.exs nnoremap <buffer> <return> :call neoterm#test#run('current')<cr>
augroup END
