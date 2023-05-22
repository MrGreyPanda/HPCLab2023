#!/bin/bash
#SBATCH --nodes=32
#SBATCH --cpus-per-task=48
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1024

# print the header

# loop over resolutions
#p=2
for tasks in 50 100; do
    file="runtimes.csv"
    (printf "nodes,workers,tasks,time\n") > "$file"
    # for nodes in 32; do
        # for workers in 33; do 
            printf "1,$workers,$tasks" >> "$file"
            mpirun -np 33 python3 manager_worker.py 4001 4001 $tasks >> "$file"
            # printf "\n" >> "$file"
        done;
    done;
done;