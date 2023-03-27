#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=pi-%j.out

# Run makefile
make

# Run all executables and write output to file
problemsize=10000000

(for i in 1 2 4 8 16 24 32 48
do
    export OMP_NUM_THREADS=$i
	./atan problemsize 0
done) >> strong.csv

(for i in 1 2 4 8 16 24 32 48
do
    export OMP_NUM_THREADS=$i
    ./atan problemsize*i 1
done) >> weak.csv


# Clean up
make clean
