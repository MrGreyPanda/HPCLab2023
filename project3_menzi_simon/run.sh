#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=fisher-%j.out

# Load needed modules
module load gcc python

# Run makefile
make

for problemsize in 128 256 512 1028
do
    for threads in 1 2 4 8 16 24 
    do
        export OMP_NUM_THREADS=$threads
        ./main $problemsize 150 0.005 >> stat_output.csv
    done
done

make clean