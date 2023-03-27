#!/bin/bash -l

#SBATCH --time=00:05:00
#SBATCH --ntasks 2
#SBATCH --nodes 2


srun ./a.out