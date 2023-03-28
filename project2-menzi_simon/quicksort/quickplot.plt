set terminal pngcairo size 800, 600
set output 'quicksort_performance.png'

set datafile separator ","

set title 'Quicksort Performance'
set xlabel 'Size of Dataset'
set ylabel 'Elapsed Time [s]'
set logscale y


set key inside right

plot 'quicksort_par.csv' using 1:2 with linespoints title 'Quicksort' \