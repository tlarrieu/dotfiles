if (!exists("filename")) filename = '~/pgresult.dat'

# setup
set datafile separator '\t'
set loadpath '~/gnuplot'

load 'dark2.pal'
load 'layout.gp'
load 'timeformat.gp'
if (!exists("terminal")) terminal = 'wxt'
load terminal . '.gp'

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
