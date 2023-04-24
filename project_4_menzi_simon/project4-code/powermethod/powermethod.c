/****************************************************************
 *                                                              *
 * This file has been written as a sample solution to an        *
 * exercise in a course given at the CSCS-USI Summer School.    *
 * It is made freely available with the understanding that      *
 * every copy of this file must include this header and that    *
 * CSCS/USI take no responsibility for the use of the enclosed  *
 * teaching material.                                           *
 *                                                              *
 * Purpose: : Parallel matrix-vector multiplication and the     *
 *            and power method                                  *
 *                                                              *
 * Contents: C-Source                                           *
 *                                                              *
 ****************************************************************/


#include <stdio.h>
#include <mpi.h>
#include <stdlib.h>
#include <math.h>
#include "hpc-power.h"


int main (int argc, char *argv[])
{
    int my_rank, size;
    int snd_buf, rcv_buf;
    int right, left;
    int sum, i;
    int n = 8192;
    int maxIterations = 1000;

    MPI_Status  status;
    MPI_Request request;
    // double norm = 0;
    // double *x = hpc_generateVector(n, *norm);
	double globalNorm = 0.;

    //generate the initial random vector
    double* x = (double*)malloc(n * sizeof(double));
    for(i = 0; i < n; i++){
        double random = rand();
        x[i] = random;
        globalNorm = random * random;
    }
    globalNorm = sqrt(globalNorm);

    MPI_Init(&argc, &argv);

    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);

    MPI_Comm_size(MPI_COMM_WORLD, &size);

    /* This subproject is about to write a parallel program to
       multiply a matrix A by a vector x, and to use this routine in
       an implementation of the power method to find the absolute
       value of the largest eigenvalue of the matrix. Your code will
       call routines that we supply to generate matrices, record
       timings, and validate the answer.
    */

    int numRows = n / size;
    int begin = my_rank * numRows;
    if(my_rank == size - 1) numRows += n % size;

    
    // double* A = hpc_generateMatrix(n, begin, numRows);
    double* A = hpc_generateOnes(n, begin, numRows);
    double start_time = hpc_timer();

	double localNorm = 0.;
	double* nextX = (double*)malloc(numRows * sizeof(double));
	double val = 0.;



    //start the power method
	for(int k = 0; k < maxIterations; k++){
		for(i = 0; i < n; i++){
			x[i] = x[i] / globalNorm;
		}

		for(i = 0; i < numRows; i++){
			val = 0.;

			for(int j = 0; j < n; j++){
				val += A[i * n + j] * x[j];
			}
			nextX[i] = val;
			localNorm += val * val;
		}

		MPI_Allreduce(&localNorm, &globalNorm, 1, MPI_DOUBLE, MPI_SUM, MPI_COMM_WORLD);
		globalNorm = sqrt(globalNorm);
		localNorm = 0.;
		MPI_Allgather(nextX, numRows, MPI_DOUBLE, x, numRows, MPI_DOUBLE, MPI_COMM_WORLD);
	}

    double end_time = hpc_timer();
    double time = end_time - start_time;
    if(my_rank == 0){
        printf("%f,%d,%d\n", time, hpc_verify(x, n, time), size);
    }

    MPI_Finalize();
    free(x);
    free(nextX);
    free(A);
    return 0;
}
