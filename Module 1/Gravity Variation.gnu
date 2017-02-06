#this file plots a function using gnuplot. Typically to run,
# type: gnuplot change_in_radius_with_lat.gnu
# on the command line
reset

set termoption dash

#equatorial radius (m), WGS84
Re = 6378137.0

#flattening
f = 1/298.25722356

#Standard gravity
gs = 9.80665

#Gravity variation from centrifugal acceleration
g_centrifugal(x) = gs - (2 * pi / 86400)**2 * (Re * (1-f*sin(x)*sin(x))) * cos(x)

#Gravity as a function of radius
g_flattening(x) = ((6.67 * 10**(-11)) * (5.972 * 10**(24))) / (Re * (1-f*sin(x)*sin(x)))**2

#Combined variation
g_variation(x) = ((6.67 * 10**(-11)) * (5.972 * 10**(24))) / (Re * (1-f*sin(x)*sin(x)))**2 \
			- (2 * pi / 86400)**2 * (Re * (1-f*sin(x)*sin(x))) * cos(x)

# Line width of the axes
set border linewidth 1.5
# Line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
set style line 2 linecolor rgb '#dd181f' linetype 1 linewidth 2
set style line 3 linecolor rgb 'green' linetype 1 linewidth 2
# Axes label
set title 'Variation of Gravity by Flattening and Centrifugal Acceleration'
set xlabel 'Latitude (degrees)'
set ylabel 'Gravity (m/s^2)'
# Axes ranges
set xrange [-pi/2:pi/2]
set yrange [9.5:10]
# Axes tics
set xtics ('90 S' -pi/2,  '45 S' -pi/4, 0, '45 N' pi/4, '90 N' pi/2 )
set ytics 0.05
set tics scale 1\

set style fill transparent solid 0.65
set key Left


plot  	g_flattening(x) title 'Flattening Variation'with lines linestyle 1, \
	 g_centrifugal(x) title 'Centrifugal Variation' with lines linestyle 2, \
      	 g_variation(x) title 'Combined Variation' with lines linestyle 3

	   
set term pdf enhanced dashed
set output "Gravity Variation.pdf"
replot
