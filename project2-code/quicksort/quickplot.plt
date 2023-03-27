set terminal pngcairo size 800, 600
set output 'quicksort_performance.png'

set title 'Quicksort Performance'
set xlabel 'Size of Dataset'
set ylabel 'Elapsed Time [s]'

set datafile separator ' '

plot 'quicksort_performance.txt' using 1:2 with linespoints title 'Quicksort'
