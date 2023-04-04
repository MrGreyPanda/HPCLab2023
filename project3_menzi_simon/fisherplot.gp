set terminal png

# set output 'fisher_times.png'

set datafile separator ","
set title "Strong Scaling Plot"

set xlabel "Problemsize"
set ylabel "Times"

# set arrow 1 from 1,1 to 50,50 nohead dashtype 0 lw 2

set key inside right

# plot 'stat_output.csv' using 1:2 with linespoints title "Serial", \
#      '' using 1:3 with linespoints title "2 Threads", \
#      '' using 1:4 with linespoints title "4 Threads", \
#      '' using 1:5 with linespoints title "8 Threads", \
#      '' using 1:6 with linespoints title "16 Threads", \
#      '' using 1:7 with linespoints title "24 Threads",

set output 'fisher_speedup.png'
set xlabel "Threads"
set ylabel "Speedup"

plot 'stat_output.csv' using 1:1 with linespoints title "Optimal", \
     '' using 1:($2/$3) with linespoints title "2 Threads", \
     '' using 1:($2/$4) with linespoints title "4 Threads", \
     '' using 1:($2/$5) with linespoints title "8 Threads", \
     '' using 1:($2/$6) with linespoints title "16 Threads", \
     '' using 1:($2/$7) with linespoints title "24 Threads", 


