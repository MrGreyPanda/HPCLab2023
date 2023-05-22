#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=48
#SBATCH --time=4:00:00
#SBATCH --job-name="mini_app"
#SBATCH --mem-per-cpu=1024

# Euler fix
##env2lmod
##module purge
## module load gcc python openmpi hdf5


number_of_timings=10

# print the header
(printf "size,processes"
t=1
while [ $t -le $number_of_timings ]; do
    printf ",t$t"
    t=$((t+1))
done;
printf "\n") > runtimes.csv

# loop over resolutions
#p=2
for p in 2 4 8 12 16 20 24 28 32; do
    for n in 128 256 512 1024; do
        printf "$n," >> runtimes.csv
        printf "$p" >> runtimes.csv
        t=1
        while [ $t -le $number_of_timings ]; do
            printf "," >> runtimes.csv
            mpirun -np $p --oversubscribe python3 main.py $n 100 0.005 | tr -d '\n' >> runtimes.csv
            # sed -i '$s/\r$//' runtimes.csv
            awk '{print $(NF-1)}' | \
            sed -e 's/^[[:space:]]*//' -e 's/\ss.*$//' | \
            tr -d '\n' >> runtimes.csv
            t=$((t+1))
        done;
        printf "\n" >> runtimes.csv
    done;
    p=$((p+1))
done;
