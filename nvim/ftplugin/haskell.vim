iabbrev <buffer> é <bar>>
iabbrev <buffer> è <<bar>
iabbrev <buffer> ?? undefined
iabbrev <buffer> wh where

iabbrev <buffer> imp import
iabbrev <buffer> ca import Control.Applicative
iabbrev <buffer> cm import Control.Monad
iabbrev <buffer> deb import Debug.Trace

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
nnoremap <leader>i
  \ :silent call SelectImports()<cr>
  \ :<c-u>silent call Snipe('new')<cr>
  \ :silent autocmd BufWritePre <buffer> :Neoformat hindent<cr>
  \ :silent autocmd BufWritePost <buffer> :x<cr>
  \ Go

setlocal formatprg=hindent

setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

" Disable '\' handling, making % work properly
setlocal cpoptions+=M
