nnoremap <buffer> <cr> :execute "T ghc " . expand('%') . " && ./" . expand('%:r')<cr>
