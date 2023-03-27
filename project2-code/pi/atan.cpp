#include <math.h>
#include <omp.h>

#include <cassert>
#include <chrono>
#include <fstream>
#include <iostream>
#include <string>

// Critical based implementation
double midpoint_arctan_critical(const int &n) {
    double h = 1.0 / n;
    double sum = 0.0;

#pragma omp parallel
    {
        double local_sum = 0.0;
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
    double h = 1.0 / n;
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
    double h = 1.0 / n;
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * h;
        sum += 1.0 / (1.0 + x_mid * x_mid);
    }

    return sum * h * 4.0;
}

int main() {
    // IO-Handling
    int n;
    std::cin >> n;
    // strong or weak scaling (0 = strong, 1 = weak)
    int s_w;
    std::cin >> s_w;

    // double rel_err = 1e-6;
    int n_threads = omp_get_max_threads();

    std::chrono::time_point<std::chrono::system_clock> start, end;
    int iterations = 1000;
    // warm-up
    for (int i = 0; i < iterations; i++) {
        midpoint_arctan_serial(n);
    }

    // Using Serial Implementation
    std::chrono::duration<double> s_time;
    for (int i = 0; i < 1000; i++) {
        start = std::chrono::system_clock::now();
        midpoint_arctan_serial(n);
        end = std::chrono::system_clock::now();
        s_time += end - start;
    }
    s_time /= iterations;

    // Using Critical parallelization
    std::chrono::duration<double> c_time = end - start;
    for (int i = 0; i < iterations; i++) {
        start = std::chrono::system_clock::now();
        midpoint_arctan_critical(n);
        end = std::chrono::system_clock::now();
        c_time += end - start;
    }
    c_time /= iterations;

    // Using Reduction parallelization
    std::chrono::duration<double> r_time;
    for (int i = 0; i < iterations; i++) {
        start = std::chrono::system_clock::now();
        midpoint_arctan_reduction(n);
        end = std::chrono::system_clock::now();
        r_time += end - start;
    }
    r_time /= iterations;

    // weak Scaling
    if (s_w == 1) {
        std::cout << n_threads << "," << s_time.count() / s_time.count() << ","
                  << c_time.count() / s_time.count() << ","
                  << r_time.count() / s_time.count() << "\n";
    }

    // strong Scaling
    else {
        std::cout << n_threads << "," << s_time.count() / s_time.count() << ","
                  << c_time.count() / s_time.count() << ","
                  << r_time.count() / s_time.count() << "\n";
    }
    return 0;
}
