#!/bin/bash
#SBATCH --job-name=quicksort
#SBATCH --output=quicksort-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=48


# Load the necessary modules (this may depend on the system)
module load gcc openmpi

# Compile the C code
make

# Call the C executable with different array sizes and save the output
(for t in 1 2 4 8 16 24 32
do
    for i in 10000 100000 1000000 10000000
    do
        export OMP_NUM_THREADS=$t
        srun ./quicksort $i
    done
done) >> quicksort.csv 

# Remove the compiled binary (this is optional)
make clean
