#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=48
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1024

# print the header

# loop over resolutions
#p=2
for tasks in 50 100; do
    file="runtimes_$tasks.csv"
    (printf "nodes,workers,time\n") > "$file"
    # for nodes in 32; do
        for workers in {3..33}; do 
            printf "1,$workers," >> "$file"
            mpirun -n $workers python3 manager_worker.py 4001 4001 $tasks >> "$file"
            printf "," >> "$file"
        done;
    printf "\n" >> "$file"
    done;
done;