#!/bin/bash

# Compile the C code
gcc -o quicksort -O3 -fopenmp quicksort.c Stopwatch.c

# Define the array lengths to test
sizes="10000 100000 1000000 10000000"

# Call the C executable with different array sizes and save the output
echo "Size of dataset   Elapsed time[s]" > quicksort_performance.txt
for size in $sizes
do
    echo "Measuring time for dataset of size $size"
    ./quicksort $size >> quicksort_performance.txt
done
