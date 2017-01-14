function! gnuplot#plot(filename, kind) abort
  let l:valid_kinds = ['bars', 'lines']

  if index(l:valid_kinds, a:kind) == -1
    echoerr 'Unknow kind of plot "' . a:kind . '"'
    return
  end

  call system("gnuplot -e \"filename='" . a:filename . "'\" -c ~/gnuplot/" . a:kind . '.gp')
endfunction
