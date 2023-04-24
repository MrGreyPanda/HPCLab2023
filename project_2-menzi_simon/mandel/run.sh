#!/bin/bash
#SBATCH --job-name=mandel
#SBATCH --output=mandel-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=32

make
(for i in 1 2 4 8 16 24 32
do
    export OMP_NUM_THREADS=$i
    srun ./mandel_par
done) >> mandel.csv

make clean

