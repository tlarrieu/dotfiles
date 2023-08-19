setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

abbreviate <buffer> è <<bar>
abbreviate <buffer> é <bar>>

augroup Test
  autocmd!
  autocmd BufEnter *.elm
    \ nnoremap <silent> <buffer> <leader><return>
    \ :T elm-test<cr>:Topen<cr>
augroup END

" Import list
function! s:importlines()
  if !bufexists(expand('%'))
    return []
  endif
  let grep = 'grep -n "^\(import.*\)"'
  let column = "column -t -s ':'"
  let lines = system(grep . ' ' . expand('%:p') . '|' . column)
  return split(lines, '\n')
endfunction

function! s:importjump(i)
  let keys = split(a:i)
  exec keys[0]
  normal! ^zz
endfunction

" Functions list
function! s:funclines()
  if !bufexists(expand('%'))
    return []
  endif
  let grep = 'grep -n "^\w.*="'
  let exclgrep = 'grep -v "type"'
  let awk = "awk '{print $1}'"
  let column = "column -t -s ':'"
  let lines = system(grep . ' ' . expand('%:p') . '|' . exclgrep . '|' . awk . '|' . column)
  return split(lines, '\n')
endfunction

function! s:funcjump(l)
  let keys = split(a:l)
  exec keys[0]
  normal! ^zz
endfunction
