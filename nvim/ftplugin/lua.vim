let b:deoplete_sources = ['omni', 'tag', 'buffer', 'file']

augroup Lua
  autocmd!
  autocmd BufEnter config/awesome/**/*.lua,config/awesome/*.lua
        \ nnoremap <silent> <buffer> <return>
        \ :T ~/scripts/awesome-test<cr>
augroup END
