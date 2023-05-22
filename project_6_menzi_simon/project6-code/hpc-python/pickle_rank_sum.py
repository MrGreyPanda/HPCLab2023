from mpi4py import MPI
import pickle

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

# Create a list of all the ranks
ranks = list(range(size))

# Pickle the list and broadcast it to all processes
pickled_ranks = pickle.dumps(ranks)
all_ranks = comm.bcast(pickled_ranks, root=0)

# Compute the sum of all the ranks
sum = comm.allreduce(rank, op=MPI.SUM)

# Print the sum for each process
print(f"Rank {rank} has sum {sum}")
