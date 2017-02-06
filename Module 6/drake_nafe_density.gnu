#Graph of Drake-Nafe curve

set termoption dash

#Drake-Nafe Curve with a basin characterized by linear change in P-wave velocity with depth (Vp = 1.5 + 0.5z, 0 < z < 5 km)

rho(x) = 1.6612 * (1.5 + 0.05*x) - 0.4721 * (1.5 + .05*x)**2 + 0.0671 * (1.5 + .05*x)**3 - 0.0043 * (1.5 + .05*x)**4 + 0.000106 * (1.5 + .05*x)**5

# Line width of the axes
set border linewidth 1.5
# Line styles
set style line 1 linecolor rgb 'black' linetype 1 linewidth 2
# Axes label
set title 'Change in Density with P-Wave Velocity by Drake-Nafe Curve'
set xlabel 'Vp (km/s)'
set ylabel 'Density (g/cm^3)'
# Axes ranges
set xrange [0:5]
set yrange [1.6:1.8]
# Axes tics
set xtics ('1.5' 0,'1.55' 1,'1.6' 2,'1.65' 3,'1.7' 4,'1.75' 5)
set ytics .025
set tics scale 1\

set key Left

plot  	rho(x) notitle with lines linestyle 1
  
set term pdf enhanced dashed
set output "drake_nafe_density_change.pdf"
replot
