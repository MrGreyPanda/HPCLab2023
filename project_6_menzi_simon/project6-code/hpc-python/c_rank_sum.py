from mpi4py import MPI
import numpy as np

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

# Create an array of all the ranks
ranks = np.arange(size)

# Scatter the array to all processes
my_rank = np.zeros(1, dtype=int)
comm.Scatter(ranks, my_rank, root=0)

# Compute the sum of all the ranks
buf = np.zeros(1, dtype=int)
buf[0] = my_rank
comm.Allreduce(MPI.IN_PLACE, buf, op=MPI.SUM)

# Print the sum for each process without the brackets
print("Rank {} has sum {}".format(rank, buf[0]))
