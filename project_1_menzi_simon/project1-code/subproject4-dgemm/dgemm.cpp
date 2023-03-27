#include <assert.h>
#include <emmintrin.h>  // SSE2
#include <immintrin.h>  // AVX

#include <cassert>
#include <cmath>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <iostream>
#include <limits>

#include "Stopwatch.h"

inline double hsum_double_avx(__m256d v) {
    __m128d vlow = _mm256_castpd256_pd128(v);
    __m128d vhigh = _mm256_extractf128_pd(v, 1);  // high 128
    vlow = _mm_add_pd(vlow, vhigh);               // reduce down to 128

    __m128d high64 = _mm_unpackhi_pd(vlow, vlow);
    return _mm_cvtsd_f64(_mm_add_sd(vlow, high64));  // reduce to scalar
}

void dgemm(double* A, double* B, double* C) {
    for (int n = 0; n < N; ++n) {
        for (int m = 0; m < M; ++m) {
            for (int k = 0; k < K; ++k) {
                C[n * M + m] += A[k * M + m] * B[n * K + k];
            }
        }
    }
}

void dgemm_opt(double* A, double* B, double* C) {
    // reference normal dgemm
    // #pragma vector always
    //     for (int n = 0; n < N; ++n) {
    //         for (int m = 0; m < M; ++m) {
    //             for (int k = 0; k < K; ++k) {
    //                 C[n * M + m] += A[k * M + m] * B[n * K + k];
    //             }
    //         }
    //     }

    // TODO: write your code
    const int blocksize = 8;
    const int unroll_factor = 4;
    __m256d a_vec0, b_vec0, c_vec0, a_vec1, b_vec1, c_vec1;
    __m256i indices0, indices1;
    // int idx_buff;
    double a0, a1, a2, a3, a4, a5, a6, a7;

    // double *A_block, *B_block, *C_block;
    // posix_memalign(reinterpret_cast<void**>(&A_block), ALIGNMENT,
    //                blocksize * blocksize * sizeof(double));
    // posix_memalign(reinterpret_cast<void**>(&B_block), ALIGNMENT,
    //                blocksize * blocksize * sizeof(double));
    // posix_memalign(reinterpret_cast<void**>(&C_block), ALIGNMENT,
    //                blocksize * blocksize * sizeof(double));
    // memset(C_block, 0, blocksize * blocksize * sizeof(double));

    // for (int n = 0; n < N; n += blocksize) {
    //     for (int m = 0; m < M; m += blocksize) {
    //         for (int k = 0; k < K; k += blocksize) {
    //             for (int kk = 0; kk < blocksize; kk++) {
    //                 memcpy(&A_block[kk * blocksize], &A[(k + kk) * M + m],
    //                        blocksize * sizeof(double));
    //                 // memcpy(&B_block[kk * blocksize], &B[(n + kk) * M +
    //                 k],
    //                 //        blocksize * sizeof(double));
    //             }

    //             for (int n1 = 0; n1 < blocksize; n1++) {
    //                 for (int m1 = 0; m1 < blocksize; m1++) {
    //                     // c_vec = _mm256_setzero_pd();
    //                     // c0 = 0;
    //                     // c1 = 0;
    //                     // c2 = 0;
    //                     // c3 = 0;

    //                     // b_vec = _mm256_set_pd(b3, b2, b1, b0);
    //                     b_vec0 = _mm256_load_pd(&B_block[n1 * blocksize]);
    //                     b_vec1 = _mm256_load_pd(&B_block[n1 * blocksize +
    //                     4]); indices0 = _mm256_set_epi64x(3 * blocksize +
    //                     m1,
    //                                                  2 * blocksize + m1,
    //                                                  blocksize + m1, m1);
    //                     indices1 = _mm256_set_epi64x(
    //                         7 * blocksize + m1, 6 * blocksize + m1,
    //                         5 * blocksize + m1, 4 * blocksize + m1);
    //                     a_vec0 = _mm256_i64gather_pd(A_block, indices0, 8);
    //                     a_vec1 = _mm256_i64gather_pd(A_block, indices1, 8);

    //                     c_vec0 = _mm256_fmadd_pd(a_vec0, b_vec0, c_vec0);
    //                     c_vec0 = _mm256_fmadd_pd(a_vec1, b_vec1, c_vec0);
    //                     C[(n + n1) * M + m1 + m] += hsum_double_avx(c_vec0);
    //                     c_vec0 = _mm256_setzero_pd();
    //                 }
    //             }
    //         }
    //     }
    // }

    // -------- blocked avx instructions ---------- (without preloading)
    for (int n = 0; n < N; n += blocksize) {
        for (int m = 0; m < M; m += blocksize) {
            for (int k = 0; k < K; k += blocksize) {
                // for (kk = 0; kk < blocksize; kk++) {
                //     memcpy(&A_block[kk * blocksize], A[(k + kk) * M + m],
                //            blocksize * sizeof(double));
                //     memcpy(&B_block[kk * blocksize], B[n * M + k],
                //            blocksize * sizeof(double));
                // }
                for (int n1 = n; n1 < n + blocksize; n1++) {
                    for (int m1 = m; m1 < m + blocksize; m1++) {
                        c_vec0 = _mm256_setzero_pd();
                        // c0 = 0;
                        // c1 = 0;
                        // c2 = 0;
                        // c3 = 0;
                        a0 = A[k * M + m1];
                        a1 = A[(k + 1) * M + m1];
                        a2 = A[(k + 2) * M + m1];
                        a3 = A[(k + 3) * M + m1];
                        a4 = A[(k + 4) * M + m1];
                        a5 = A[(k + 5) * M + m1];
                        a6 = A[(k + 6) * M + m1];
                        a7 = A[(k + 7) * M + m1];

                        // b_vec = _mm256_set_pd(b3, b2, b1, b0);
                        a_vec0 = _mm256_set_pd(a3, a2, a1, a0);
                        a_vec1 = _mm256_set_pd(a7, a6, a5, a4);

                        // // c_vec = _mm256_setzero_pd();
                        b_vec0 = _mm256_load_pd(&B[n1 * K + k]);
                        b_vec1 = _mm256_load_pd(&B[n1 * K + 4 + k]);
                        // // idx_buff = k1 * M + m1;
                        // indices0 = _mm256_set_epi64x(
                        //     (k + 3) * M + m1, (k + 2) * M + m1,
                        //     (k + 1) * M + m1, k * M + m1);
                        // indices1 = _mm256_set_epi64x(
                        //     (k + 7) * M + m1, (k + 6) * M + m1,
                        //     (k + 5) * M + m1, (k + 4) * M + m1);

                        // a_vec0 = _mm256_i64gather_pd(A, indices0, 8);
                        // a_vec1 = _mm256_i64gather_pd(A, indices1, 8);

                        c_vec0 = _mm256_fmadd_pd(a_vec0, b_vec0, c_vec0);
                        c_vec0 = _mm256_fmadd_pd(a_vec1, b_vec1, c_vec0);

                        // c_vec = _mm256_setr_pd(c3, c2, c1, c0);
                        C[n1 * M + m1] += hsum_double_avx(c_vec0);
                        // C[n1 * M + m1] += hsum_double_avx(c_vec);
                    }
                }
            }
        }
    }

    // ------------------------------------------------
    /*const int blocksize = 32;
    int n, m, k, n1, m1, k1;
    int unroll = 4;
    __m256d a_vec, b_vec, c_vec;
    __m128d sum;
    __m256i indices;
    for (n = 0; n < N; n += blocksize) {
        for (m = 0; m < M; m += blocksize) {
            for (k = 0; k < K; k += blocksize) {
                for (n1 = n; n1 < n + blocksize && n1 < N; n1++) {
                    for (m1 = m; m1 < m + blocksize && m1 < M; m1++) {
                        for (k1 = k; k1 < k + blocksize && k1 < K;
                             k1 += unroll) {
                            c_vec = _mm256_setzero_pd();
                            b_vec = _mm256_loadu_pd(&B[n1 * K + k1]);
                            indices = _mm256_set_epi64x(
                                k1 * M + m1, (k1 + 1) * M + m1,
                                (k1 + 2) * M + m1, (k1 * 3) * M + m1);
                            a_vec = _mm256_i64gather_pd(A, indices, 8);

                            c_vec = _mm256_fmadd_pd(a_vec, b_vec, c_vec);
                        }

                        C[m1 * N + n1] += hsum_double_avx(c_vec);
                    }
                }
            }
        }
    }*/
}

int main(int argc, char** argv) {
    int repetitions = 10000;
    if (argc > 1) {
        repetitions = atoi(argv[1]);
    }

    /** Allocate memory */
    double *A, *B, *C, *A_test, *B_test, *C_test;

    posix_memalign(reinterpret_cast<void**>(&A), ALIGNMENT,
                   M * K * sizeof(double));
    posix_memalign(reinterpret_cast<void**>(&B), ALIGNMENT,
                   K * N * sizeof(double));
    posix_memalign(reinterpret_cast<void**>(&C), ALIGNMENT,
                   M * N * sizeof(double));
    posix_memalign(reinterpret_cast<void**>(&A_test), ALIGNMENT,
                   M * K * sizeof(double));
    posix_memalign(reinterpret_cast<void**>(&B_test), ALIGNMENT,
                   K * N * sizeof(double));
    posix_memalign(reinterpret_cast<void**>(&C_test), ALIGNMENT,
                   M * N * sizeof(double));

    for (int j = 0; j < K; ++j) {
        for (int i = 0; i < M; ++i) {
            A[j * M + i] = i + j;
        }
    }
    for (int j = 0; j < N; ++j) {
        for (int i = 0; i < K; ++i) {
            B[j * K + i] = (K - i) + (N - j);
        }
    }
    memset(C, 0, M * N * sizeof(double));
    memcpy(A_test, A, M * K * sizeof(double));
    memcpy(B_test, B, K * N * sizeof(double));
    memset(C_test, 0, M * N * sizeof(double));

/** Check correctness of optimised dgemm */
#pragma noinline
    {
        dgemm(A, B, C);
        dgemm_opt(A_test, B_test, C_test);
    }

    double error = 0.0;
    for (int i = 0; i < M * N; ++i) {
        double diff = C[i] - C_test[i];
        error += diff * diff;
    }
    error = sqrt(error);
    if (error > std::numeric_limits<double>::epsilon()) {
        printf(
            "Optimised DGEMM is incorrect. Error: "
            "%e\n",
            error);
        return -1;
    }

    /** Test performance of optimised dgemm */

#pragma noinline
    dgemm_opt(A, B, C);

    Stopwatch stopwatch;
    stopwatch.start();

#pragma noinline
    for (int r = 0; r < repetitions; ++r) {
        dgemm_opt(A, B, C);
        //__asm__ __volatile__("");
    }

    double time = stopwatch.stop();
    printf("%lf ms, %lf GFLOP/s\n", time * 1.0e3,
           repetitions * 2.0 * M * N * K / time * 1.0e-9);

    /** Clean up */

    free(A);
    free(B);
    free(C);
    free(A_test);
    free(B_test);
    free(C_test);

    return 0;
}
