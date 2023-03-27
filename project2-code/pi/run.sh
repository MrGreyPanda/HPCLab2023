#!/bin/bash
#SBATCH --output=matrixmult-%j.out
#SBATCH --nodes=1
#SBATCH --cpus-per-task=1

# # Run makefile
make

# Run all executables and write output to file
for num_threads in 1 2 4 8 16 24 32
do
    export OMP_NUM_THREADS=num_threads
    ./atan
done

# Clean up
make clean
