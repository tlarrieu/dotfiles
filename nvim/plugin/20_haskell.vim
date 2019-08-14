function! EditImports()
  let pos = getcurpos()

  keepjumps normal! gg

  let found = search('import', 's')

  if l:found > 0
    normal! V
    call search('import', 'b')
    normal! V
  else
    keepjumps execute "normal! gg}O\<cr>\<esc>VV"
  endif

  keepjumps call setpos('.', l:pos)

  call Snipe('new')

  autocmd BufWritePre <buffer> Neoformat hindent
  autocmd BufWritePost <buffer> :x
  iabbrev <buffer> i import

  if l:found > 0
    normal! Go
  endif

  startinsert!
endfunction
