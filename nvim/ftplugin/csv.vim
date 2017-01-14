nmap <silent> <buffer> <return> :call gnuplot#plot(expand('%'), 'bars')<cr>
nmap <silent> <buffer> <leader><return> :call gnuplot#plot(expand('%'), 'lines')<cr>
