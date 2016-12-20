function! OpenSQLResult() dict
  execute 'bdelete! ' . self.bufnr
  execute 'new ' . self.filename
  setf postgresql
endfunction
