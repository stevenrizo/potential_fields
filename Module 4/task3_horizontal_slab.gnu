#this file plots a function using gnuplot. Typically to run,
# type: gnuplot change_in_radius_with_lat.gnu
# on the command line

reset
set termoption dash

G = 6.67e-11 #gravitational constant
rho = -720 #density contrast (kg m-3)
pi = 3.14159265358979
h = 200 #bed thickness (m)

rect(x) = x>8400 ? 0 : x<3200 ? 0 : 2*pi*G*rho*h*1e5

# Axes label
set xlabel 'Distance (m)'
set ylabel 'Change in gravity (mGal)'

# Axes ranges
set xrange [0:11000]
set yrange [-10:10]

# Axes tics
set xtics 1000
set ytics 5
set tics scale 1
set key Left
plot rect(x)   
set term pdf enhanced dashed
set output "task3_horizontal_slab_graph.pdf"
replot
