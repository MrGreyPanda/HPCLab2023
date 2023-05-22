#!/bin/bash
#SBATCH --nodes=1
#SBATCH --cpus-per-task=48
#SBATCH --time=2:00:00
#SBATCH --mem-per-cpu=1024

# print the header
times=3
# loop over resolutions
#p=2
(printf "workers,tasks,t1,t2,t3\n") > runtimes.csv
for tasks in 50 100; do
    # for nodes in 32; do
        for workers in {2..33}; do 
            printf "$((workers-1)),$tasks," >> runtimes.csv
            mpirun -np $workers --oversubscribe python3 manager_worker.py 4001 4001 $tasks | tr -d '\n' >> runtimes.csv
            awk '{print $(NF-1)}' | \
            sed -e 's/^[[:space:]]*//' -e 's/\ss.*$//' | \
            tr -d '\n' >> runtimes.csv
            printf "\n" >> runtimes.csv
        done;
    done;
done;