#!/bin/bash
#SBATCH --job-name=mandel
#SBATCH --output=mandel-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=24

make

export OMP_NUM_THREADS=24
./mandel_par

make clean