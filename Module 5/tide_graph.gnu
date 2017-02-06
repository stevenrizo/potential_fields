set terminal png size 800,600
set xdata time
set timefmt "%Y-%m-%d-%H-%M"
set output "tideS0.png"

 # time range must be in same format as data file
#set xrange ["2013-10-1-0-0":"2013-10-7-23-50"]
set xtics("2013-10-1-0-0","2013-10-2-0-0", "2013-10-3-0-0","2013-10-4-0-0","2013-10-5-0-0","2013-10-6-0-0","2013-10-7-0-0")
set yrange [-0.1:0.2]
set grid
set xlabel " "
set ylabel "change in gravity (mGal)"
set title "Earth Tide"

plot "tidetable.out" using 1:2 index 0 notitle with lines
