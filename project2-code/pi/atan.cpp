#include <math.h>
#include <omp.h>

#include <chrono>
#include <iostream>

// #include <random>

// Monte Carlo integrator for a given interval with given sample count and
// function
// double integrate(std::function<double(double)> func, const int &n,
//                  const double &low, const double &high) {
//     std::random_device rd;
//     std::mt19937 gen(rd());
//     std::uniform_real_distribution<> distr(low, high);
//     double sum = 0.0;
//     for (int i = 0; i < n; i++) {
//         sum += func(distr(gen));
//     }
//     return sum / (double)n;
// }
// Haven't seen the hint using midpoint method

// midpoint_arctan using OpenMP critical directive
double midpoint_arctan_critical(const int &n) {
    double delta_x = 1.0 / n;
    double sum = 0.0;

#pragma omp parallel for
    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * delta_x;
        double local_sum = 1.0 / (1.0 + x_mid * x_mid);
#pragma omp critical
        sum += local_sum;
    }

    return sum / n;
}

// midpoint_arctan using OpenMP reduction clause
double midpoint_arctan_reduction(const int &n) {
    double delta_x = 1.0 / n;
    double sum = 0.0;

#pragma omp parallel for reduction(+ : sum)
    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * delta_x;
        sum += 1.0 / (1.0 + x_mid * x_mid);
    }

    return sum / n;
}

double midpoint_arctan_serial(const int &n) {
    double delta_x = 1.0 / n;
    double sum = 0.0;

    for (int i = 0; i < n; i++) {
        double x_mid = (i + 0.5) * delta_x;
        sum += 1.0 / (1.0 + x_mid * x_mid);
    }

    return sum / n;
}

int main() {
    int n = 10000;
    std::chrono::time_point<std::chrono::system_clock> start, end;

    start = std::chrono::system_clock::now();
    crit = midpoint_arctan_serial(n);
    end = std::chrono::system_clock::now();
    std::chrono::duration<double> diff_ser = end - start;
    std::cout << "Serial time:\t" << diff_ser << "s\n";

    start = std::chrono::system_clock::now();
    crit = midpoint_arctan_critical(n);
    end = std::chrono::system_clock::now();
    std::chrono::duration<double> diff_crit = end - start;
    std::cout << "Critical time:\t" << critical_time << " seconds\n";

    start = std::chrono::system_clock::now();
    crit = midpoint_arctan_reduction(n);
    end = std::chrono::system_clock::now();
    std::chrono::duration<double> diff_red = end - start;
    std::cout << "Reduction time:\t" << reduction_time << " seconds\n";

    return 0;
}