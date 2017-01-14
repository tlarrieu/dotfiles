if (!exists("filename")) filename = '~/pgresult.dat'

# setup
set datafile separator ';'
set loadpath '~/gnuplot'

load 'dark2.pal'
load 'layout.gp'
load 'timeformat.gp'
load 'wxt.gp'
# load 'pngcairo.gp'

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
