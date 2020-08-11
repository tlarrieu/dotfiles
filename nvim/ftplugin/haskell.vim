iabbrev <buffer> é <bar>>
iabbrev <buffer> è <<bar>
iabbrev <buffer> ?? undefined
iabbrev <buffer> wh where

if !exists("g:hs_stack_run_args")
  let g:hs_stack_run_args = ""
endif

function! haskell#run()
  call execute("T stack run " . g:hs_stack_run_args, "Topen")
endfunction

function! haskell#test()
  call execute("T stack test", "Topen")
endfunction

if filereadable("stack.yaml")
  nnoremap <buffer> <leader><cr> :call haskell#test()<cr>
  nnoremap <buffer> <cr> :call haskell#run()<cr>
else
  nnoremap <buffer> <cr>
    \ :execute "T echo -ne '\\033c'; ghc Main.hs && time ./Main"<cr>
endif

nnoremap <buffer> <leader>e.
  \ :call MaybeTabedit('package.yaml')<cr>
  \ gg
  \ :call search('dependencies')<cr>
  \ }
vnoremap <silent> <buffer> <leader>f :Neoformat hindent<cr>
nnoremap <silent> <buffer> <leader>f :Neoformat hindent<cr>

nnoremap <silent> <buffer> <leader>i
  \ :silent call haskell#editImports('insert')<cr>
nnoremap <silent> <buffer> <leader>ei
  \ :silent call haskell#editImports('normal')<cr>

nnoremap <silent> <buffer> <leader>è
  \ :silent call haskell#editPragmas('insert')<cr>
nnoremap <silent> <buffer> <leader>eè
  \ :silent call haskell#editPragmas('normal')<cr>

nnoremap <silent> <buffer> <leader>tu
  \ :call haskell#ghci('tabnew')<cr>
nnoremap <silent> <buffer> <leader>vu
  \ :call haskell#ghci('vnew')<cr>
nnoremap <silent> <buffer> <leader>nu
  \ :call haskell#ghci('new')<cr>

setlocal formatprg=hindent

setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

" Disable '\' handling, making % work properly
setlocal cpoptions+=M

let b:fzf_tags_config = {
  \   'func': { 'identifiers': ['c_a', 'ft'], 'prompt': 'func' },
  \   'type': {
  \       'identifiers': ['c', 'cons', 'd', 'nt', 't'],
  \       'prompt': 'type'
  \     }
  \ }
nnoremap <silent> <c-c> :FZFtags type<cr>
nnoremap <silent> <c-l> :FZFtags func<cr>
