augroup TEX
  autocmd!
  autocmd BufWritePost *.tex T rake
  autocmd BufWritePost *.tex Tclose
augroup END
