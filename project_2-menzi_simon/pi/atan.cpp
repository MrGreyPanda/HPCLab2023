#include <math.h>
#include <omp.h>

#include <cassert>
#include <chrono>
#include <fstream>
#include <iostream>
#include <string>

// Critical based implementation
double midpoint_arctan_critical(const int &n) {
    const double h = 1.0 / n;
    double sum = 0.0;

    double local_sum = 0.0;
#pragma omp parallel firstprivate(local_sum)
    {
#pragma omp for
        for (int i = 0; i < n; i++) {
            double x_mid = (i + 0.5) * h;
            local_sum += 1.0 / (1.0 + x_mid * x_mid);
        }
#pragma omp critical
        sum += local_sum;
    }

    return sum * h * 4.0;
}

// Reduction based parallel implementation
double midpoint_arctan_reduction(const int &n) {
    const double h = 1.0 / n;
    double sum = 0.0;

#pragma omp parallel for reduction(+ : sum)
    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * h;
        sum += 1.0 / (1.0 + x_mid * x_mid);
    }

    return sum * h * 4.0;
}

// Serial implementation
double midpoint_arctan_serial(const int &n) {
    const double h = 1.0 / n;
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * h;
        sum += 1.0 / (1.0 + x_mid * x_mid);
    }

    return sum * h * 4.0;
}

int main(int argc, char **argv) {
    // IO-Handling
    int n;
    n = atoi(argv[1]);

    // std::cout << n << "\n";
    // strong or weak scaling (0 = strong, 1 = weak, 2 = time)
    int s_w;
    // std::cin >> s_w;
    s_w = atoi(argv[2]);
    double ser = 0, red = 0, crit = 0;

    double abs_err = 1e-6;
    int n_threads = omp_get_max_threads();

    std::chrono::time_point<std::chrono::high_resolution_clock> start, end;
    int iterations = 1000;
    // warm-up
    for (int i = 0; i < iterations; i++) {
        midpoint_arctan_serial(n);
    }

    // Using Serial Implementation -------------------
    std::chrono::duration<double> s_time;
    start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) {
        ser += midpoint_arctan_serial(n);
    }
    end = std::chrono::high_resolution_clock::now();
    s_time = end - start;
    s_time /= iterations;
    ser /= iterations;
    assert(abs(M_PI - ser) < abs_err);
    // ------------------------------------------------


    // Using Critical parallelization -----------------
    std::chrono::duration<double> c_time;
    start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) {
        crit += midpoint_arctan_critical(n);
    }
    end = std::chrono::high_resolution_clock::now();
    c_time = end - start;
    c_time /= iterations;
    crit /= iterations;
    assert(abs(crit - M_PI) < abs_err);
    // ------------------------------------------------

    // Using Reduction parallelization ----------------
    std::chrono::duration<double> r_time;
    start = std::chrono::high_resolution_clock::now();
    for (int i = 0; i < iterations; i++) {
        red += midpoint_arctan_reduction(n);
    }
    end = std::chrono::high_resolution_clock::now();
    r_time = end - start;
    r_time /= iterations;
    red /= iterations;
    assert(abs(red - M_PI) < abs_err);
    // ------------------------------------------------

    double crit_speedup = s_time.count() / c_time.count();
    double red_speedup = s_time.count() / r_time.count();
    double crit_eff = crit_speedup / n_threads;
    double red_eff = red_speedup / n_threads;
    // weak Scaling
    if (s_w == 1) {
        std::cout << n_threads << ","
                  << "1"
                  << "," << crit_eff << "," << red_eff << "\n";
    }

    // strong Scaling
    else if (s_w == 0) {
        std::cout << n_threads << ","
                  << "1"
                  << "," << crit_speedup << "," << red_speedup << "\n";
    } else {
        std::cout << n_threads << "," << s_time.count() << ","
                  << c_time.count() << "," << r_time.count() << "\n";
    }
    return 0;
}
