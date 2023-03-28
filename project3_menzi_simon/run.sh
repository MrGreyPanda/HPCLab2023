#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=fisher-%j.out


# Run makefile
make

for threads in 1 2 4 8 16 24 
do
    export OMP_NUM_THREADS=$threads
    for problemsize in 128 256 512 1028
    do
        ./main $problemsize 100 0.005 >> stat_output.csv
    done
    "\n" >> stat_output.csv 
done