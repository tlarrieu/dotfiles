function! gnuplot#plot(filename, kind) abort
  if a:kind ==# 'lines'
    call system("gnuplot -e \"filename='" . a:filename . "'\" -c ~/gnuplot/lines.gp")
  else
    call system("gnuplot -e \"filename='" . a:filename . "'\" -c ~/gnuplot/histogram.gp")
  end
endfunction
