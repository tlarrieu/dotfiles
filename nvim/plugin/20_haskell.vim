function! SelectImports()
  let pos = getcurpos()

  keepjumps normal! gg
  call search('import', 's')
  normal! V
  call search('import', 'b')
  normal! V

  keepjumps call setpos('.', pos)
endfunction
