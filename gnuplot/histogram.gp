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
  linewidth .5 \
  font "Inconsolata-g for Powerline" \
  fontscale .8 \
  persist

# set terminal pngcairo \
#   linewidth .5 \
#   size 2000,800 \
#   font "Inconsolata-g for Powerline" \
#   fontscale .8
# set output '~/gnuplot.png'

# Visualisation
set style data histogram
set style histogram rowstacked

# Grid configuration
set style line 100 linetype 1 linecolor rgb "gray" linewidth 2
set style line 101 linetype 1 linecolor rgb "gray" linewidth 1

set grid mytics ytics ls 100, ls 101
set grid mxtics xtics ls 100, ls 101

# Boxes configuration
set style fill solid .5

# Tics configuration
set xtics rotate by 45
set xtics right
set xtics offset 0,-.5

# Plot
plot \
  for [COL=2:*] \
  filename \
  using COL:xticlabels(1) title columnhead linestyle COL

# Plot with lines skipping
# plot \
#   for [COL=2:*] \
#   filename \
#   every ::0::10000 \
#   using COL:xticlabels(1) title columnhead linestyle COL

# vim: filetype=gnuplot
