reset

set style line 1  linetype 1 linecolor rgb "green"  linewidth 5.000 pointtype 1 pointsize default pointinterval 0
set style line 2  linetype 1 linecolor rgb "yellow"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 3  linetype 1 linecolor rgb "blue"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
#

set xlabel "Distance (m)"
set ylabel "Magnetic Anomaly (nT)"

plot "low_pass.out" using 1:2 ls 1 notitle with lines,\
     "low_pass.out" using 1:3 ls 3 notitle with lines

set terminal pngcairo size 800,500 enhanced font 'Verdana,10'
set output "dike_low200.png"
replot
