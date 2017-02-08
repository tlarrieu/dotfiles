function! gnuplot#setup() abort
  command!
    \ -buffer
    \ -complete=customlist,s:completion
    \ -nargs=+
    \ Plot
    \ call gnuplot#plot(expand('%'), <f-args>)

  cabbrev <buffer> plot Plot
endfunction

function! gnuplot#plot(filename, kind, ...) abort
  if !executable('gnuplot')
    echohl Error
    echomsg '"gnuplot" is not installed'
    return
  endif

  let l:terminal = (a:0 >= 1) ? a:1 : 'wxt'

  if index(s:kinds(), a:kind) == -1
    echoerr 'Unknow kind of plot "' . a:kind . '"'
    return
  end

  let l:commands = s:commands({
    \ 'filename' : a:filename,
    \ 'terminal' : l:terminal
    \ })

  call jobstart("gnuplot -e " . l:commands . " -c ~/gnuplot/" . a:kind . '.gp')
endfunction

function! s:completion(arglead, _cmdline, _cursorpos) abort
  return filter(s:kinds(), 'v:val =~# "^' . a:arglead . '"')
endfunction

function! s:kinds() abort
  return ['lines', 'bars']
endfunction

function! s:commands(dict) abort
  let l:variables = []

  for [l:key, l:value] in items(a:dict)
    let l:variables += [l:key . '="' . l:value . '"']
  endfor

  return shellescape(join(l:variables, ';'))
endfunction
