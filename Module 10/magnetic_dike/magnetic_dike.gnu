reset

set style line 1  linetype 1 linecolor rgb "blue"  linewidth 2.000 pointtype 1 pointsize default pointinterval 0
set style line 2  linetype 1 linecolor rgb "yellow"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 3  linetype 1 linecolor rgb "blue"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
#

set xlabel "Distance (m)"
set ylabel "Magnetic Anomaly (nT)"

plot "dike.out" using 1:2 ls 1 notitle with lines

set terminal pngcairo size 800,500 enhanced font 'Verdana,10'
set output "dike.png"
replot
