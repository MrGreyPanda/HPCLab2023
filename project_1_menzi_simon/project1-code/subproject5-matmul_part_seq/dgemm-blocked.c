/*
    Please include compiler name below (you may also include any other modules
you would like to be loaded)

COMPILER= gnu

    Please include All compiler flags and libraries as you want them run. You
can simply copy this over from the Makefile's first few lines

CC = cc
OPT = -O3
CFLAGS = -Wall -std=gnu99 $(OPT)
MKLROOT = /opt/intel/composer_xe_2013.1.117/mkl
LDLIBS = -lrt -Wl,--start-group $(MKLROOT)/lib/intel64/libmkl_intel_lp64.a
$(MKLROOT)/lib/intel64/libmkl_sequential.a $(MKLROOT)/lib/intel64/libmkl_core.a
-Wl,--end-group -lpthread -lm

*/
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

const char *dgemm_desc = "Naive, three-loop dgemm.";

#define MIN(X, Y) (((X) < (Y)) ? (X) : (Y))

// inline int r_b(const int &i, const int &n, const int &blocksize) {
//     if (i + blocksize < n && k + blocksize < n && j + blocksize < n)
//         return blocksize;
//     else
//         return n - i;
// }

void blockMM(double *A, double *B, double *C, int I, int J, int K, int n) {
    /* For each row i of A */
    for (int i = 0; i < I; ++i) /* For each column j of B */
        for (int j = 0; j < J; ++j) {
            /* Compute C(i,j) */
            double cij = C[i + j * n];
            for (int k = 0; k < K; k++) cij += A[i + k * n] * B[k + j * n];
            C[i + j * n] = cij;
        }
}
// void blocking(double *A_block, double *B_block, double *C_block, double *A,
//               double *B, double *C, const int &i, const int &j, const int
//               &k, const int &n, const int &blocksize) {
//     for (int ii = 0; ii < blocksize && ii + i < n; ii++) {
//         for (int kk = 0; kk < blocksize && kk + k < n; kk++) {
//             A_block[kk + ii * blocksize] = A[i + ii + (kk + k) * n];
//             memcpy(&B_block[ii * blocksize], &B[j + k * n],
//                    blocksize * sizeof(double));
//         }
//     }
// }

/* This routine performs a dgemm operation
 *  C := C + A * B
 * where A, B, and C are lda-by-lda matrices stored in column-major format.
 * On exit, A and B maintain their input values. */
void square_dgemm(int n, double *A, double *B, double *C) {
    // TODO: Implement the blocking optimization
    const int blocksize = 10;
    int I, J, K;

    // blockMM(A, B, C, n, n, n, n);
    for (int i = 0; i < n; i += blocksize) {
        I = MIN(blocksize, n - i);
        for (int j = 0; j < n; j += blocksize) {
            J = MIN(blocksize, n - j);
            for (int k = 0; k < n; k += blocksize) {
                K = MIN(blocksize, n - k);
                blockMM(&A[i + n * k], &B[k + j * n], &C[i + j * n], I, J, K,
                        n);
            }
        }
    }
}
