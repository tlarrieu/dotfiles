augroup ultisnips_hooks
  autocmd!
  autocmd User ProjectionistActivate silent! call skeleton#insert()
  autocmd BufNewFile * silent! call skeleton#insert()
augroup END
