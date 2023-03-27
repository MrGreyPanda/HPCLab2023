set terminal pngcairo size 800, 600
set output 'quicksort_performance.png'

set title 'Quicksort Performance'
set xlabel 'Size of Dataset'
set ylabel 'Elapsed Time [s]'


plot 'quicksort_par.csv' using 1:4 with linespoints title 'Quicksort' \
    '' using 1:8 with linepoints title "Threads: 2" \
    '' using 1:12 with linepoints title "Threads: 4" \
    '' using 1:16 with linepoints title "Threads: 8" \
    '' using 1:16 with linepoints title "Threads: 16" \
    '' using 1:16 with linepoints title "Threads: 24" \
    '' using 1:16 with linepoints title "Threads: 32" 


plot 'strong.csv' using 1:1 with linespoints title "Ideal", \
     '' using 1:3 with linespoints title "Parallel Critical", \
     '' using 1:4 with linespoints title "Parallel Reduction"