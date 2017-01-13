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

# Plot
plot \
  for [COL=2:*] \
    filename \
    using 1:COL \
    title columnhead \
    with linespoints \
    linestyle COL \
    linewidth 2 \
    pt 7

# vim: filetype=gnuplot
