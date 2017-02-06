set xdata time
set timefmt "%b-%d-%H:%M:%S"
set format x "%b-%d-%H:%M:%S"
set samples 200
set table "interpolated_drift.out"
      plot "drift.dat" using 1:2 smooth csplines

      unset table
