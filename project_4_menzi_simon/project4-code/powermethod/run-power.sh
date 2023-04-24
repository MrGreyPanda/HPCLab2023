#!/bin/bash -l

#SBATCH --nodes=16
#SBATCH --ntasks=16
#SBATCH --ntasks-per-node=1
#SBATCH --cpus-per-task=1
#SBATCH --output=job.out
#SBATCH --error=job.err
#SBATCH --time=01:20:00

#offset added to x coordinate so that gnuplot does not overlap the bars
offset=0 

rm -f power.csv
for nodes in 1 2 3 4
do
    for np in 1 4 8 12 16 24 32 64
    do
        echo "Computing Mandelbrot set with $np processes & $nodes nodes..."
        mpirun -np $np ./powermethod >> power.csv
        echo "$nodes $np\n" >> power.csv 
    done
done

echo "Done."
