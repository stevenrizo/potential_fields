set terminal png size 800,600
set xdata time
set timefmt "%b-%d-%H:%M:%S"
set output "nonlinear_drift_curve.png"

 # time range must be in same format as data file
set xrange ["Feb-09-00:00:00":"Feb-17-00:00:00"]
set yrange [-.20:.25]
set grid
set xlabel "Time"
set ylabel "change in gravity (mGal)"
set title "Daily drift curve"



plot "drift.dat" using 1:2 index 0 notitle smooth csplines,\
     "drift.dat" using 1:2 index 0 with points pointtype 7 pointsize 3 linecolor rgb "black" notitle,\
     "drift.dat" using 1:2:3 index 0 with labels offset 0,1 notitle,\
     "new_station.dat" using 1:2 with points pointtype 7 pointsize 3 linecolor rgb "red" notitle,\
     "new_station.dat" using 1:2:3 index 0 with labels offset 0,1 notitle
