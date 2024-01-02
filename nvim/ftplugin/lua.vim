augroup Lua
  autocmd!
  autocmd BufEnter config/awesome/**/*.lua,config/awesome/*.lua
        \ nnoremap <silent> <buffer> <return>
        \ :T ~/scripts/awesome-test<cr>

  autocmd BufEnter *.lua
        \ nnoremap <silent> <buffer> <return>
        \ :T lua %<cr>
augroup END
