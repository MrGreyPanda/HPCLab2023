from mandelbrot_task import *
import matplotlib as mpl
mpl.use('Agg')
import matplotlib.pyplot as plt
from mpi4py import MPI # MPI_Init and MPI_Finalize automatically called
import numpy as np
import sys
import time

# some parameters
MANAGER = 0       # rank of manager
TAG_TASK      = 1 # task       message tag
TAG_TASK_DONE = 2 # tasks done message tag
TAG_DONE      = 3 # done       message tag

def manager(comm, tasks):
    """
    The manager.

    Parameters
    ----------
    comm : mpi4py.MPI communicator
        MPI communicator
    tasks : list of objects with a do_task() method perfroming the task
        List of tasks to accomplish

    Returns
    -------
    ... ToDo ...
    """
    size = comm.Get_size()
    requests = np.zeros(size - 1, dtype=MPI.Request)
    ids = np.zeros(size - 1, dtype=int)
    upcommingTask = 0

    for r in range(1, size):
        comm.send(tasks[upcommingTask], dest=r, tag=TAG_TASK)
        # Allocate a large enough buffer to store the result in, else we may get a MPI_ERR_TRUNCATE
        buffer = bytearray(1 << 20)
        requests[r - 1] = comm.irecv(buffer, source=r, tag=TAG_TASK_DONE)

        # Store which task each rank is working on
        ids[r - 1] = upcommingTask
        upcommingTask += 1

    while True:
        req = MPI.Request.waitany(requests)
        rank = req[0] + 1
        task = req[1]

        # Save completed work
        tasks[ids[rank - 1]] = task
        TasksDoneByWorker[rank] += 1

        if len(tasks) != upcommingTask:
            # Send new task to free worker
            comm.send(tasks[upcommingTask], dest=rank, tag=TAG_TASK)
            buf = bytearray(1 << 20)
            requests[rank - 1] = comm.irecv(buf, source=rank, tag=TAG_TASK_DONE)
            ids[rank - 1] = upcommingTask
            upcommingTask += 1

        else:
            # No more tasks left
            break

    # Wait for all remaining tasks
    req = MPI.Request.waitall(requests)

    # Save remaining results into tasks
    for i in range(len(req)):
        task = req[i]
        if task is not None:
            tasks[ids[i]] = task
            TasksDoneByWorker[rank] += 1

    # Tell workers we are finished
    b = np.array([TAG_DONE])
    req = comm.Ibcast(b, root=0)
    req.Wait()


def worker(comm):

    """
    The worker.

    Parameters
    ----------
    comm : mpi4py.MPI communicator
        MPI communicator
    """
    b = np.array([TAG_DONE])
    done = comm.Ibcast(b, root=0)

    while True:
        request = comm.irecv(source=MANAGER, tag=TAG_TASK)

        tmp = MPI.Request.waitany(requests=np.array([request, done]))
        if done.Test():
            request.Cancel()
            break

        task = tmp[1]
        task.do_work()
        comm.send(task, dest=MANAGER, tag=TAG_TASK_DONE)


def readcmdline(rank):
    """
    Read command line arguments

    Parameters
    ----------
    rank : int
        Rank of calling MPI process

    Returns
    -------
    nx : int
        number of gridpoints in x-direction
    ny : int
        number of gridpoints in y-direction
    ntasks : int
        number of tasks
    """
    # report usage
    if len(sys.argv) != 4:
        if rank == MANAGER:
            print("Usage: manager_worker nx ny ntasks")
            print("  nx     number of gridpoints in x-direction")
            print("  ny     number of gridpoints in y-direction")
            print("  ntasks number of tasks")
        sys.exit()

    # read nx, ny, ntasks
    nx = int(sys.argv[1])
    if nx < 1:
        sys.exit("nx must be a positive integer")
    ny = int(sys.argv[2])
    if ny < 1:
        sys.exit("ny must be a positive integer")
    ntasks = int(sys.argv[3])
    if ntasks < 1:
        sys.exit("ntasks must be a positive integer")

    return nx, ny, ntasks


if __name__ == "__main__":

    # get COMMON WORLD communicator, size & rank
    comm    = MPI.COMM_WORLD
    size    = comm.Get_size()
    my_rank = comm.Get_rank()

    # report on MPI environment
    if my_rank == MANAGER:
        # print(f"MPI initialized with {size:5d} processes")

        # read command line arguments
        nx, ny, ntasks = readcmdline(my_rank)


        # start timer
        timespent = - time.perf_counter()
        # trying out ... YOUR MANAGER-WORKER IMPLEMENTATION HERE ...
        x_min = -2.
        x_max  = +1.
        y_min  = -1.5
        y_max  = +1.5
        M = mandelbrot(x_min, x_max, nx, y_min, y_max, ny, ntasks)
        tasks = M.get_tasks()
    
    # if my_rank == MANAGER:
        TasksDoneByWorker = np.zeros(size, dtype=int)
        manager(comm, tasks)
        
    else:
        worker(comm)
    
    if my_rank == MANAGER:
        m = M.combine_tasks(tasks)
        plt.imshow(m.T, cmap="gray", extent=[x_min, x_max, y_min, y_max])
        plt.savefig("mandelbrot.png")

        # stop timer
        timespent += time.perf_counter()

        # inform that done
        # if my_rank == MANAGER:
        print(timespent)
        for i in range(size):
            if i == MANAGER:
                continue
            # print(f"Process {i:5d} has done {TasksDoneByWorker[i]:10d} tasks")
        # print("Done.")
