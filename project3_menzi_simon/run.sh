#!/bin/bash
#SBATCH --cpus-per-task=48
#SBATCH --output=fisher-%j.out
#SBATCH --time=3:00:00
#SBATCH --constraint=EPYC_7742

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
echo threads,size,t1,t2,t3,t4,t5,t6,t7,t8,t9,t10 > strong_output.csv
for threads in 1 2 4 8 16 24
do
    export OMP_NUM_THREADS=$threads
    for problemsize in 64 90 128 181 256 313
    do
        echo -n $threads,$problemsize, >> strong_output.csv
        for i in {1..10}
        do
            ./main $problemsize 100 0.005 >> strong_output.csv
        done
        echo >> strong_output.csv
    done
done

    
make clean