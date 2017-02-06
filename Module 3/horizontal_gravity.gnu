#Graph of gravity with changing horizontal position
reset

set termoption dash

#Gravitational constant
G = 6.67408*10**-11

#fixed depth
z = 10

#fixed point mass
mp = 1.4*10**11

#Gravity variation from centrifugal acceleration
gz(x) = (G*mp*z) / (x**2 + z**2)**(3/2)


# Line width of the axes
set border linewidth 1.5
# Line styles
set style line 1 linecolor rgb '#0060ad' linetype 1 linewidth 2
# Axes label
set title 'Change in Gravity with Horizontal Position from Point Mass'
set xlabel 'Horizontal Distance from Point Mass(m)'
set ylabel 'Gravity (m/s^2)'
# Axes ranges
set xrange [0:50]
set yrange [0:1]
# Axes tics
set xtics (0,10,20,30,40,50)
set ytics 0.1
set tics scale 1\

set style fill transparent solid 0.65
set key Left


plot  	gz(x) notitle with lines linestyle 1

	   
set term pdf enhanced dashed
set output "horizontal_gravity_change.pdf"
replot