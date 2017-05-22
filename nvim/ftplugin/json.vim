nmap <buffer> <return> :Jacinto validate<cr>
nmap <buffer> <leader><return> :Jacinto format<cr>

augroup JSONautocmd
  autocmd BufEnter package.json
        \ nnoremap <silent> <buffer> <return>
        \ :new<bar>call termopen('npm install')<cr>
augroup END
