setlocal conceallevel=2
setlocal concealcursor=c
setlocal concealcursor+=n
setlocal concealcursor+=i

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

nnoremap <c-l> :call fzf#run({
  \   'source':  <sid>funclines(),
  \   'sink':    function('<sid>funcjump'),
  \   'options': '--extended --nth=2.. +s',
  \   'down':    '30%'
  \ })<cr>
