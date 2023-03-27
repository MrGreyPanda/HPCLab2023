#!/bin/bash
#SBATCH --output=matrixmult-%j.out
#SBATCH --nodes=1

# # Run makefile
make

# Run all executables and write output to file
for i in 1 2 4 8 16 24 32
do
    ./atan i
done

# Clean up
make clean
