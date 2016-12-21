function! OpenSQLResult() dict
  execute 'bdelete! ' . l:self.bufnr
  execute 'new ' . l:self.filename
  setf postgresql
endfunction
