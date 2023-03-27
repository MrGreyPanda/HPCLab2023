#!/bin/bash
#SBATCH --output=quicksort-%j.out

# Compile the C code
make

# Call the C executable with different array sizes and save the output
export OMP_NUM_THREADS=10

(for i in 10000 100000 1000000 10000000
do
    ./quicksort $i
done) >> quicksort.csv

make clean
