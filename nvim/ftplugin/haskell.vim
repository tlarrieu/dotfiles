nnoremap <buffer> <cr> :execute "T ghc Main.hs && time ./Main"<cr>
vnoremap <leader>f :Neoformat hindent<cr>
nnoremap <leader>f :Neoformat hindent<cr>

setlocal formatprg=hindent

" setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i
