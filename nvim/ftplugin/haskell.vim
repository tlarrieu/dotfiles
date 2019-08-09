abbreviate <buffer> é <bar>>

if filereadable("stack.yaml")
  nnoremap <buffer> <leader><cr>
    \ :T stack test<cr>
    \ :Topen<cr>
  nnoremap <buffer> <cr>
    \ :T stack build<cr>
    \ :T stack run<cr>
    \ :Topen<cr>
else
  nnoremap <buffer> <cr>
    \ :execute "T echo -ne '\\033c'; ghc Main.hs && time ./Main"<cr>
endif

vnoremap <leader>f :Neoformat hindent<cr>
nnoremap <leader>f :Neoformat hindent<cr>

setlocal formatprg=hindent

setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

" Disable '\' handling, making % work properly
setlocal cpoptions+=M
