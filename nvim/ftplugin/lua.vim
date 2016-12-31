let b:deoplete_sources = ['omni', 'tag', 'buffer', 'file']

augroup Lua
  autocmd!
  autocmd BufEnter config/awesome/**/*.lua,config/awesome/*.lua
        \ nnoremap <silent> <buffer> <return>
        \ :new<bar>call termopen('/home/tlarrieu/scripts/awesome-test')<cr>
augroup END
