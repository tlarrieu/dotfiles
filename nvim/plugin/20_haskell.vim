function! EditImports(mode)
  let pos = getcurpos()

  keepjumps normal! gg

  let found = search('import', 's')

  if l:found > 0
    normal! V
    call search('import', 'b')
    normal! V
  else
    keepjumps execute "normal! gg}O\<cr>\<esc>VV"
  endif

  keepjumps call setpos('.', l:pos)

  call Snipe('new')

  autocmd BufWritePre <buffer> Neoformat hindent
  autocmd BufWritePost <buffer> :x

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
  iabbrev <buffer> dv Data.Vector
  iabbrev <buffer> mb Data.Maybe
  iabbrev <buffer> tp Text.Printf

  if a:mode == 'insert'
    if l:found > 0
      normal! Go
    endif

    execute "normal! iimport\<space>"
    startinsert!
  end
endfunction
