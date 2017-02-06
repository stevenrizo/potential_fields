#this file plots a function using gnuplot. Typically to run,
# type: gnuplot change_in_radius_with_lat.gnu
# on the command line

reset
set termoption dash
Grv = 6.67e-11 #gravitational constant
rho = -2400 #density contrast (kg m-3)
a = 14 #radius (m)
z= 21 #depth to center (m)
gz(x) = 2*Grv*pi*a**2*rho/(x**2 + z**2)**0.5 * 1e5

# Axes label
set xlabel 'Distance from tube center  (m)'
set ylabel 'Change in gravity (mGal)'

# Axes ranges
set xrange [-100:100]
set yrange [-1.2:0]

# Axes tics
set xtics 20
set ytics 0.1
set tics scale 1
set key Left
plot gz(x)   
set term pdf enhanced dashed
set output "task2_cave_graph.pdf"
replot