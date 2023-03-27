#!/bin/bash
#SBATCH --output=matrixmult-%j.out
#SBATCH --nodes=1

# # Run makefile
# make

# Run all executables and write output to file
make run

# Clean up
make clean
