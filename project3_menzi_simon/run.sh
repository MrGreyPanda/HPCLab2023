#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=fisher-%j.out

# Load needed modules
module load gcc python

# Run makefile
make

# Timeings
# for problemsize in 64 128 256 512 1024
# do
#     for threads in 1 2 4 8 16 24 
#     do
#         export OMP_NUM_THREADS=$threads
#         ./main $problemsize 100 0.005 >> stat_output.csv
#     done
#     echo >> strong_output.csv
# done

#for speedup
echo threads,size,runtime > strong_output.csv
for threads in 1 2 4 8 16 24 
do
    for problemsize in 64 128 256 512 1024
    do
        echo -n $threads,$problemsize, >> strong_output.csv
        export OMP_NUM_THREADS=$threads
        ./main $problemsize 100 0.005 >> strong_output.csv
        echo >> strong_output.csv
    done
done


make clean