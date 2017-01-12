function! gnuplot#plot(filename) abort
  call system("gnuplot -e \"filename='" . a:filename . "'\" -c ~/gnuplot/histogram.gp")
endfunction
