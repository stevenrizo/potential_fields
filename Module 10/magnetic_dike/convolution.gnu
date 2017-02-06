#plot of convolution for upward continuation

set xrange [1/1024:1]
z = 500
f(x) = exp(z*x)

set style line 1  linetype 1 linecolor rgb "blue"  linewidth 2.000 pointtype 1 pointsize default pointinterval 0

set xlabel "k Value"
set ylabel "Convolution"

plot f(x)

set terminal pngcairo size 800,500 enhanced font 'Verdana,10'
set output "convolution500.png"
replot
