nnoremap <buffer> <cr> :execute "T echo -ne '\\033c'; ghc Main.hs && time ./Main"<cr>
vnoremap <leader>f :Neoformat hindent<cr>
nnoremap <leader>f :Neoformat hindent<cr>

setlocal formatprg=hindent

setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

" Disable \ handling, making % work properly
setlocal cpoptions+=M
