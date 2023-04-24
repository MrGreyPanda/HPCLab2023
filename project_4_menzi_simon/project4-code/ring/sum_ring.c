/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School.    *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: Parallel sum using a ping-pong                      *
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/


#include <stdio.h>
#include <mpi.h>


int main (int argc, char *argv[])
{
    int my_rank, size;
    int snd_buf, rcv_buf;
    int right, left;
    int sum = 0, i;

    MPI_Status  status;


    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Request sendRequest;
    MPI_Request recieveRequest;


    right = (my_rank + 1) % size;/* get rank of neighbor to your right */
    left  = (my_rank - 1) % size;/* get rank of neighbor to your left */

    /* Implement ring addition code
     * do not use if (rank == 0) .. else ..
     * every rank sends initialy its rank number to a neighbor, and then sends what
     * it receives from that neighbor, this is done n times with n = number of processes
     * all ranks will obtain the sum.
     */
    snd_buf = my_rank;
    for(i = 0; i < size; i++){
        MPI_Isend(&snd_buf, 1, MPI_INT, right, 0, MPI_COMM_WORLD, &sendRequest);
        MPI_Irecv(&rcv_buf, 1, MPI_INT, left, 0, MPI_COMM_WORLD, &recieveRequest);

        MPI_Wait(&sendRequest, &status);
        MPI_Wait(&recieveRequest, &status);

        sum += rcv_buf;
        snd_buf = rcv_buf;
    }




    printf ("Process %i:\tSum = %i\n", my_rank, sum);

    MPI_Finalize();
    return 0;
}
