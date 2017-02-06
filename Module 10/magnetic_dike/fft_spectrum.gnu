reset

set style line 1  linetype 1 linecolor rgb "red"  linewidth 5.000 pointtype 1 pointsize default pointinterval 0
set style line 2  linetype 1 linecolor rgb "yellow"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
set style line 3  linetype 1 linecolor rgb "blue"  linewidth 3.000 pointtype 1 pointsize default pointinterval 0
#

set xlabel "wavelength (m)"
set ylabel "Power Spectrum"
set xrange[0:40]
set xtics ('1024' 1, '204.8' 5, '102.4 ' 10, '68.3' 15, '51.2' 20, '34.1' 30, '25.6' 40) nomirror
set x2label "wavenumber"
set x2tics 0,5,40 nomirror
plot "spectrum.out" using 1:2 ls 1 notitle with lines

set terminal pngcairo size 800,500 enhanced font 'Verdana,10'
set output "spectrum.png"
replot
