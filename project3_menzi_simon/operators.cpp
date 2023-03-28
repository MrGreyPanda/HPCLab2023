//******************************************
// operators.f90
// based on min-app code written by Oliver Fuhrer, MeteoSwiss
// modified by Ben Cumming, CSCS
// *****************************************

// Description: Contains simple operators which can be used on 3d-meshes

#include "operators.h"

#include "data.h"
#include "stats.h"

namespace operators {

// input: s, gives updated solution for f
// only handles interior grid points, as boundary points are fixed
// those inner grid points neighbouring a boundary point, will in the following
// be referred to as boundary points and only those grid points
// only neighbouring non-boundary points are called inner grid points
void diffusion(const data::Field &s, data::Field &f) {
    using data::options;

    using data::bndE;
    using data::bndN;
    using data::bndS;
    using data::bndW;

    using data::y_old;

    const double alpha = options.alpha;
    const double beta = options.beta;

    const int nx = options.nx;
    const int iend = nx - 1;
    const int jend = nx - 1;

#pragma omp parallel
    {
// the interior grid points
#pragma omp for collapse(2) nowait
        for (int j = 1; j < jend; j++) {
            for (int i = 1; i < iend; i++) {
                f(i, j) = -(4. + alpha) * s(i, j) + s(i - 1, j) + s(i + 1, j) +
                          s(i, j - 1) + s(i, j + 1) + alpha * y_old(i, j) +
                          beta * s(i, j) * (1. - s(i, j));
            }
        }

        // the east boundary
        {
            int i1 = nx - 1;
#pragma omp for nowait
            for (int j = 1; j < jend; j++) {
                f(i1, j) = -(4. + alpha) * s(i1, j) + s(i1 - 1, j) +
                           s(i1, j - 1) + s(i1, j + 1) + alpha * y_old(i1, j) +
                           bndE[j] + beta * s(i1, j) * (1. - s(i1, j));
            }
        }

        // the west boundary
        {
            int i2 = 0;
#pragma omp for nowait
            for (int j = 1; j < jend; j++) {
                f(i2, j) = -(4. + alpha) * s(i2, j) + s(i2 + 1, j) +
                           s(i2, j - 1) + s(i2, j + 1) + alpha * y_old(i2, j) +
                           bndW[j] + beta * s(i2, j) * (1. - s(i2, j));
            }
        }

        // the north boundary (plus NE and NW corners)
        {
            int j1 = nx - 1;
#pragma omp single nowait
            {
                int i = 0;  // NW corner
                f(i, j1) = -(4. + alpha) * s(i, j1) + s(i + 1, j1) +
                           s(i, j1 - 1) + alpha * y_old(i, j1) + bndW[j1] +
                           bndN[i] + beta * s(i, j1) * (1. - s(i, j1));
            }

// inner north boundary
#pragma omp for nowait
            for (int i = 1; i < iend; i++) {
                f(i, j1) = -(4. + alpha) * s(i, j1) + s(i + 1, j1) +
                           s(i - 1, j1) + s(i, j1 - 1) + alpha * y_old(i, j1) +
                           bndN[i] + beta * s(i, j1) * (1. - s(i, j1));
            }
#pragma omp single nowait
            {
                int i = nx - 1;  // NE corner
                f(i, j1) = -(4. + alpha) * s(i, j1) + s(i - 1, j1) +
                           s(i, j1 - 1) + alpha * y_old(i, j1) + bndE[j1] +
                           bndN[i] + beta * s(i, j1) * (1.0 - s(i, j1));
            }
        }

        // the south boundary
        {
            int j2 = 0;
#pragma omp single nowait
            {
                int i = 0;  // SW corner
                f(i, j2) = -(4. + alpha) * s(i, j2) + s(i + 1, j2) +
                           s(i, j2 + 1) + alpha * y_old(i, j2) + bndW[j2] +
                           bndS[i] + beta * s(i, j2) * (1.0 - s(i, j2));
            }

// inner south boundary
#pragma omp for nowait
            for (int i = 1; i < iend; i++) {
                f(i, j2) = -(4. + alpha) * s(i, j2) + s(i + 1, j2) +
                           s(i - 1, j2) + s(i, j2 + 1) + alpha * y_old(i, j2) +
                           bndS[i] + beta * s(i, j2) * (1.0 - s(i, j2));
            }
#pragma omp single nowait
            {
                int i = nx - 1;  // SE corner
                f(i, j2) = -(4. + alpha) * s(i, j2) + s(i - 1, j2) +
                           s(i, j2 + 1) + alpha * y_old(i, j2) + bndE[j2] +
                           bndS[i] + beta * s(i, j2) * (1.0 - s(i, j2));
            }
        }
    }  // parallel region

    // Accumulate the flop counts
    // 8 ops total per point
    stats::flops_diff += +12 * (nx - 2) * (nx - 2)  // interior points
                         + 11 * (nx - 2 + nx - 2)   // NESW boundary points
                         + 11 * 4;                  // corner points
}  // namespace operators

}  // namespace operators
