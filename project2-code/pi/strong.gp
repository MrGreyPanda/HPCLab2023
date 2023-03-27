set terminal png

set output 'strong.png'

set datafile separator ","
set title "Strong Scaling Plot"

set xlabel "Number of Threads"
set ylabel "Speedup"

# set arrow 1 from 1,1 to 50,50 nohead dashtype 0 lw 2

set key inside right

plot 'strong.csv' using 1:2 with linespoints title "Serial", \
     '' using 1:3 with linespoints title "Parallel Critical", \
     '' using 1:4 with linespoints title "Parallel Reduction"

