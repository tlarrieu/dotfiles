# variables
if (!exists("filename")) filename = '~/pgresult.dat'

# setup
set datafile separator ';'
set loadpath '~/gnuplot'

# Decoration
set key outside

# palette
load 'dark2.pal'

# Output
set terminal wxt \
  font "Inconsolata-g for Powerline" \
  fontscale 1.2 \
  persist

# set terminal pngcairo \
#   size 2000,800 \
#   font "Inconsolata-g for Powerline" \
#   fontscale .8
# set output '~/gnuplot.png'

# Visualisation
set xdata time
set timefmt "%Y-%m-%d"
set format x "%Y-%m-%d"
set mouse mouseformat 3

# Grid configuration
set style line 100 linetype 1 linecolor rgb "gray" linewidth 2
set style line 101 linetype 1 linecolor rgb "gray" linewidth 1

set grid mytics ytics ls 100, ls 101
set grid mxtics xtics ls 100, ls 101

# Boxes configuration
set style fill solid .5

# Plot
plot \
  filename using 1:(sum [col=2:9] column(col)) title columnhead(9) with boxes linestyle 8, \
  ""       using 1:(sum [col=2:8] column(col)) title columnhead(8) with boxes linestyle 7, \
  ""       using 1:(sum [col=2:7] column(col)) title columnhead(7) with boxes linestyle 6, \
  ""       using 1:(sum [col=2:6] column(col)) title columnhead(6) with boxes linestyle 5, \
  ""       using 1:(sum [col=2:5] column(col)) title columnhead(5) with boxes linestyle 4, \
  ""       using 1:(sum [col=2:4] column(col)) title columnhead(4) with boxes linestyle 3, \
  ""       using 1:(sum [col=2:3] column(col)) title columnhead(3) with boxes linestyle 2, \
  ""       using 1:(sum [col=2:2] column(col)) title columnhead(2) with boxes linestyle 1, \

# Plot with line skipping
# plot \
#   filename every ::0::1000 using 1:(sum [col=2:9] column(col)) title columnhead(9) with boxes linestyle 8, \
#   ""       every ::0::1000 using 1:(sum [col=2:8] column(col)) title columnhead(8) with boxes linestyle 7, \
#   ""       every ::0::1000 using 1:(sum [col=2:7] column(col)) title columnhead(7) with boxes linestyle 6, \
#   ""       every ::0::1000 using 1:(sum [col=2:6] column(col)) title columnhead(6) with boxes linestyle 5, \
#   ""       every ::0::1000 using 1:(sum [col=2:5] column(col)) title columnhead(5) with boxes linestyle 4, \
#   ""       every ::0::1000 using 1:(sum [col=2:4] column(col)) title columnhead(4) with boxes linestyle 3, \
#   ""       every ::0::1000 using 1:(sum [col=2:3] column(col)) title columnhead(3) with boxes linestyle 2, \
#   ""       every ::0::1000 using 1:(sum [col=2:2] column(col)) title columnhead(2) with boxes linestyle 1, \

# vim: filetype=gnuplot
