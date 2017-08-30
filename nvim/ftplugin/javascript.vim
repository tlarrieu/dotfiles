nnoremap <buffer> <return> :TestLast<cr>

function! Nightwatch(scope)
  if a:scope == 'all'
    call termopen('bin/nightwatch')
  elseif a:scope == 'file'
    let current_file = expand('%:f')
    new
    call termopen('bin/nightwatch' . ' ' . l:current_file)
  end
endfunction

augroup Test
  autocmd!
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :TestFile<cr>
  autocmd BufEnter *_spec.js
        \ nnoremap <silent> <buffer> <return>
        \ :TestLast<cr>

  autocmd BufEnter e2e/tests/*.js
        \ nnoremap <silent> <buffer> <return>
        \ :call Nightwatch('file')<cr>
  autocmd BufEnter e2e/tests/*.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :call Nightwatch('all')

  autocmd BufEnter e2e/tests/*.js
        \ nnoremap <silent> <buffer> <leader><return>
        \ :new<bar>echom expand('%:f')<cr>
augroup END
