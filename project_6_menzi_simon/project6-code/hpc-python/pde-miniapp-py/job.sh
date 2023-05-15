#!/bin/bash

#SBATCH -n 4
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=1
#SBATCH --time=4:00:00
#SBATCH --job-name="pde-miniapp-py"

time -p mpirun python main.py 128 100 0.01 v 2>&1 | tee main.log
exit
