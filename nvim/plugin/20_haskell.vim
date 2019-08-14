function! HaskellSave()
  if match(&filetype, 'import') > 0
    execute "Neoformat hindent"
    setf haskell
    execute "x"
  else
    execute "w"
  end
endfunction
