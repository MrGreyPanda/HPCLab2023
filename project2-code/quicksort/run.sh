#!/bin/bash

# Compile the C code
make

# Call the C executable with different array sizes and save the output
export OMP_NUM_THREADS=10

(for size in 10000 100000 1000000 10000000
do
    ./quicksort $size
done) >> quicksort.csv

make clean
