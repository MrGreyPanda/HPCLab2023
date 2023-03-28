set terminal png

set output 'weak.png'

set datafile separator ","
set title "Weak Scaling Plot"

set xlabel "Number of Threads"
set ylabel "Efficiency"

# set arrow 1 from 1,1 to 50,50 nohead dashtype 0 lw 2

set key inside right

plot 'weak.csv' using 1:2 with linespoints title "Ideal", \
     '' using 1:3 with linespoints title "Parallel Critical", \
     '' using 1:4 with linespoints title "Parallel Reduction"

