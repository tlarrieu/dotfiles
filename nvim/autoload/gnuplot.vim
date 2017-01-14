function! gnuplot#setup() abort
  command!
    \ -buffer
    \ -complete=customlist,s:completion
    \ -nargs=1
    \ Plot
    \ call gnuplot#plot(expand('%'), <q-args>)

  cabbrev <buffer> plot Plot
endfunction

function! gnuplot#plot(filename, kind) abort
  if index(s:kinds(), a:kind) == -1
    echoerr 'Unknow kind of plot "' . a:kind . '"'
    return
  end

  call jobstart("gnuplot -e \"filename='" . a:filename . "'\" -c ~/gnuplot/" . a:kind . '.gp')
endfunction

function! s:completion(arglead, _cmdline, _cursorpos) abort
  return filter(s:kinds(), 'v:val =~# "^' . a:arglead . '"')
endfunction

function! s:kinds() abort
  return ['lines', 'bars']
endfunction
