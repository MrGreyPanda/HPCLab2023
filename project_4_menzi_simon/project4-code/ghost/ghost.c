/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School     *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: Exchange ghost cell in 2 directions using a topology*
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/

/* Use only 16 processes for this exercise
 * Send the ghost cell in two directions: left<->right and top<->bottom
 * ranks are connected in a cyclic manner, for instance, rank 0 and 12 are connected
 *
 * process decomposition on 4*4 grid
 *
 * |-----------|
 * | 0| 1| 2| 3|
 * |-----------|
 * | 4| 5| 6| 7|
 * |-----------|
 * | 8| 9|10|11|
 * |-----------|
 * |12|13|14|15|
 * |-----------|
 *
 * Each process works on a 6*6 (SUBDOMAIN) block of data
 * the D corresponds to data, g corresponds to "ghost cells"
 * xggggggggggx
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * gDDDDDDDDDDg
 * xggggggggggx
 */

#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

#define SUBDOMAIN 6
#define DOMAINSIZE (SUBDOMAIN+2)

int main(int argc, char *argv[])
{
    int rank, size, i, j, dims[2], periods[2], rank_top, rank_bottom, rank_left, rank_right;
    double data[DOMAINSIZE*DOMAINSIZE];
    MPI_Request request;
    MPI_Status status;
    MPI_Comm comm_cart;
    MPI_Datatype data_ghost_col, data_ghost_row;

    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);
    MPI_Comm_size(MPI_COMM_WORLD, &size);

    if (size!=16) {
        printf("please run this with 16 processors\n");
        MPI_Finalize();
        exit(1);
    }

    // initialize the domain
    for (i=0; i<DOMAINSIZE*DOMAINSIZE; i++) {
        data[i]=rank;
    }

    // TODO: set the dimensions of the processor grid and periodic boundaries in both 
    // int dim = std::sqrt(size);
    // For testing we fix it
    int dim = 4;
    dims[0]= dim;
    dims[1]= dim;
    periods[0]= true;
    periods[1]= true;

    // TODO: Create a Cartesian communicator (4*4) with periodic boundaries (we do not allow
    // the reordering of ranks) and use it to find your neighboring
    // ranks in all dimensions in a cyclic manner.
    MPI_Comm cart_comm;
    MPI_Cart_create(MPI_COMM_WORLD, 2, dims, periods, true, &cart_comm);
    MPI_Comm_rank(cart_comm, &rank);
    // TODO: find your top/bottom/left/right neighbor using the new communicator, see MPI_Cart_shift()
    MPI_Cart_shift(cart_comm, 0, 1, &rank_left, &rank_right);
    MPI_Cart_shift(cart_comm, 0, 2, &rank_bottom, &rank_top);

    //  TODO: create derived datatype data_ghost, create a datatype for sending the column, see MPI_Type_vector() and MPI_Type_commit()
    // data_ghost
    MPI_Type_contiguous(dim, MPI_DOUBLE, &data_ghost_row);
    MPI_Type_commit(&data_ghost_row);
    MPI_Type_vector(dim, DOMAINSIZE, dim, MPI_DOUBLE, &data_ghost_col);
    MPI_Type_commit(&data_ghost_col);

    //  TODO: ghost cell exchange with the neighbouring cells in all directions
    //  use MPI_Irecv(), MPI_Send(), MPI_Wait() or other viable alternatives

    //  to the top
    MPI_Sendrecv(&data[DOMAINSIZE + 1], SUBDOMAIN, data_ghost_row, rank_top, 0, &data[1], SUBDOMAIN, data_ghost_row, rank_top, 0, comm_cart, status);
    
    //  to the bottom
    MPI_Sendrecv(&data[DOMAINSIZE * (DOMAINSIZE - 2) + 1], SUBDOMAIN, data_ghost_row, rank_bottom, 0, &data[DOMAINSIZE * (DOMAINSIZE - 1) + 1], SUBDOMAIN, data_ghost_row, rank_top, 0, comm_cart, status);

    //  to the left
    MPI_Sendrecv(&data[DOMAINSIZE + 1], SUBDOMAIN, data_ghost_col, rank_left, 0, &data[DOMAINSIZE], SUBDOMAIN, data_ghost_col, rank_left, 0, comm_cart, status);
   
    //  to the right
    MPI_Sendrecv(&data[DOMAINSIZE + SUBDOMAIN], SUBDOMAIN, data_ghost_col, rank_right, 0, &data[DOMAINSIZE + SUBDOMAIN + 1], SUBDOMAIN, data_ghost_col, rank_right, 0, comm_cart, status);
    

    if (rank==9) {
        printf("data of rank 9 after communication\n");
        for (j=0; j<DOMAINSIZE; j++) {
            for (i=0; i<DOMAINSIZE; i++) {
                printf("%.1f ", data[i+j*DOMAINSIZE]);
            }
            printf("\n");
        }
    }

    // TODO: uncomment when done with tasks above
    MPI_Type_free(&data_ghost_col);
    MPI_Type_free(&data_ghost_row);
    MPI_Comm_free(&comm_cart);
    MPI_Finalize();

    return 0;
}