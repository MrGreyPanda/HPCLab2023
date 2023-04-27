# Set the output file name and format
set terminal png
set output "plot.png"

# Set the x and y axis labels and title
set xlabel "Number of Processors"
set ylabel "Timings"
set title "Benchmark Results"

# Set the plot style and size
set style data linespoints
set size 1.0,1.0

# Plot the data from bench.csv
plot "bench.data" using 3:1 with linespoints lw 2 notitle

# Save the plot to a file and show it
set output