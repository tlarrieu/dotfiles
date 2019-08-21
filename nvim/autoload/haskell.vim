function! haskell#ghci(func)
  let filename = expand('%')
  exec a:func
  call termopen("stack exec ghci " . filename)
  if a:func == 'tabnew'
    TabooRename GHCi
  end
  startinsert!
endfunction

function! haskell#editImports(mode)
  let pos = getcurpos()

  keepjumps normal! gg

  let found = search('import', 's')

  if l:found > 0
    normal! V
    call search('import', 'b')
    normal! V
  else
    keepjumps execute "normal! gg"
    call search('module')
    keepjumps execute "normal! }O\<cr>\<esc>VV"
  endif

  keepjumps call setpos('.', l:pos)

  call Snipe('new')

  if a:mode == 'insert'
    if l:found > 0
      normal! Go
    endif

    execute "normal! iimport\<space>"
    startinsert!
  end

  autocmd BufWritePre <buffer> Neoformat hindent
  autocmd BufWritePost <buffer> :close

  iabbrev <buffer> i import
  iabbrev <buffer> q qualified
  iabbrev <buffer> iq import qualified

  iabbrev <buffer> ca Control.Applicative
  iabbrev <buffer> cm Control.Monad

  iabbrev <buffer> da Data.Array
  iabbrev <buffer> dc Data.Char
  iabbrev <buffer> deb Debug.Trace
  iabbrev <buffer> dl Data.List
  iabbrev <buffer> dm Data.Map
  iabbrev <buffer> ds Data.Set
  iabbrev <buffer> dv Data.Vector
  iabbrev <buffer> mb Data.Maybe
  iabbrev <buffer> tp Text.Printf
endfunction

function! haskell#editPragmas(mode)
  let pos = getcurpos()

  keepjumps normal! gg

  let found = search('{-#', 's')

  if l:found > 0
    normal! V
    call search('#-}', 'b')
    normal! V
  else
    keepjumps execute "normal! O\<esc>O\<esc>VV"
  endif

  keepjumps call setpos('.', l:pos)

  call Snipe('new')

  if l:found > 0
    normal! Go
  endif

  if a:mode == 'insert'
    keepjumps execute "normal! i{-#  #-}\<esc>hhh"
    startinsert
  end

  autocmd BufWritePre <buffer> Neoformat hindent
  autocmd BufWritePost <buffer> :close

  iabbrev <buffer> { {-# #-}<left><left><left><left>
  iabbrev <buffer> lang LANGUAGE
  iabbrev <buffer> nfp NamedFieldPuns
endfunction
