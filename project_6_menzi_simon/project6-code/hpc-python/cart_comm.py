from mpi4py import MPI

# Setup communicator and get number of processes
comm = MPI.COMM_WORLD
size = comm.Get_size()

# Compute the dimensions of the Cartesian topology
dims = MPI.Compute_dims(size, 2)

# Create the Cartesian topology
periods = (True, True)
cart_comm = comm.Create_cart(dims, periods=periods)

# Get the rank, coordinates, and neighboring processes of the current process
rank = cart_comm.Get_rank()
coords = cart_comm.Get_coords(rank)
north, south = cart_comm.Shift(0, 1)
west, east = cart_comm.Shift(1, 1)

# Output the topology information for the current process
print("Rank {} has coordinates {} and neighbors: North={}, South={}, West={}, East={}".format(rank, coords, north, south, west, east))

# Exchange data within the periodic Cartesian topology
# For each process, exchange its rank with four neighbors
# north_rank, south_rank, west_rank, east_rank = cart_comm.Sendrecv(rank, dest=north, source=south), cart_comm.Sendrecv(rank, dest=south, source=north), cart_comm.Sendrecv(rank, dest=west, source=east), cart_comm.Sendrecv(rank, dest=east, source=west)
cart_comm.send(rank, dest=north, tag=0)
rank_south = cart_comm.recv(source=south, tag=0)

cart_comm.send(rank, dest=south, tag=1)
rank_north = cart_comm.recv(source=north, tag=1)

cart_comm.send(rank, dest=west, tag=2)
rank_east = cart_comm.recv(source=east, tag=2)

cart_comm.send(rank, dest=east, tag=3)
rank_west = cart_comm.recv(source=west, tag=3)

# Output the exchanged data for the current process
print(f"rank {rank} with coords {coords} has neighbors: north={north}, south={south}, west={west}, east={east}\n"
      f"north_rank={rank_north}, south_rank={rank_south}, west_rank={rank_west}, east_rank={rank_east}")