function! helpers#Capitalize()
  if search('\v(%^|[.!?\]]\_s|\n\n)\_s*%#', 'bcnw') != 0
    let v:char = toupper(v:char)
  endif
endfunction
