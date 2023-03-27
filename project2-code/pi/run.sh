#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=pi-%j.out

# Run makefile
make

# Run all executables and write output to file
problemsize=1000000

# Just Timing
(for i in 1 2 4 8 16 24 32 48
do
    export OMP_NUM_THREADS=$i
	./atan $problemsize 2
done) >> time.csv

# Timing for strong scaling
(for i in 1 2 4 8 16 24 32 48
do
    export OMP_NUM_THREADS=$i
	./atan $problemsize 0
done) >> strong.csv

# Timing for weak scaling
(for i in 1 2 4 8 16 24 32 48
do
    export OMP_NUM_THREADS=$i
    ./atan $problemsize*i 1
done) >> weak.csv

gnuplot strong.gp
gnuplot weak.gp
# Clean up
make clean
