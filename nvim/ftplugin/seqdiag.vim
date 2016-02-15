function! SeqDiag()
  let filename = expand('%')
  execute "!seqdiag -Tpng -a " . filename
endfunction

nnoremap <silent> <cr> :call SeqDiag()<cr>
