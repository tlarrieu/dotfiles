setlocal textwidth=1000

augroup TASKEDIT
  autocmd!
  autocmd BufWritePost * quit
augroup END
