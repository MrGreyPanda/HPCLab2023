#!/bin/bash

#SBATCH -n 1
#SBATCH --cpus-per-task=1
#SBATCH --output=ouput-%j.out
#SBATCH --constraint=EPYC_7742

./dgemm