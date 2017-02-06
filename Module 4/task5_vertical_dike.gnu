reset

set termoption dash

pi = 3.14159265358979;

z = 0; #depth to top of plate (m)
h = 35; #plate thickness (m)
l = 5000;  #vertical length of plate (m)
del_density = 600; #input the density cotrast (kg/m3)
big_G = 6.67e-11; #gravitational const.
to_mgal = 1e5; #convert SI to mGal


grav(x) = 2.0 * to_mgal * big_G * del_density * h * log10(((z+l)**2 + x**2)/(x**2 + z**2));


# Axes label
set xlabel 'Horizontal distance from plate center (m)'
set ylabel 'Gravity anomaly (mGal)'


# Axes ranges
set xrange [-1000:1000]
set yrange [0:2]
# Axes tics
set xtics 200
set ytics 0.2

set style fill transparent solid 0.15
set key Left


plot  grav(x) with filledcurve y1=0  lt rgb "gray0" notitle
	   
set term pdf enhanced dashed
set output "task5_vertical_sheet_anomaly.pdf"
replot
