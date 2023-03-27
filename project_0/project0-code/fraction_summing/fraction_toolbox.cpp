#include "fraction_toolbox.hpp"

#include <iostream>

void print_fraction(fraction frac) {
    std::cout << frac.num << '/' << frac.denom << std::endl;
}

void print_fraction_array(fraction frac_array[], int n) {
    std::cout << "[ " << frac_array[0].num << '/' << frac_array[0].denom
              << std::endl;
    for (int i = 1; i < n - 1; i++) {
        std::cout << "  ";
        print_fraction(frac_array[i]);
    }
    std::cout << "  " << frac_array[n - 1].num << '/'
              << frac_array[n - 1].denom << " ]" << std::endl;
}

fraction square_fraction(const fraction &frac) {
    int num = frac.num * frac.num;
    int denum = frac.denum * frac.denum;
    return fraction{num, denum};
}

void square_fraction_inplace(fraction &frac) {
    frac.num *= frac.num;
    frac.denum *= frac.denum;
}
double fraction2double(const fraction &frac) {
    return static_cast<double>(frac.num / frac.denum);
}

int gcd(int a, int b) {
    if(b == 0) return a;
    // int x = a % b;
    return gcd(b, a % b);
}

int gcd(fraction frac){
    int a = frac.num;
    int b = frac.denum;
    int t;
    while(b != 0){
        t = b;
        b = a % b;
        a = t;
    }
    return a;
}

void reduce_fraction_inplace(fraction &frac) {
    // this code is calling the iterative method of the euclids algorithm
    int min_divisor = gcd(frac);
    frac.num /= min_divisor;
    frac.denum /= min_divisor;
}

fraction add_fractions(fraction frac1, fraction frac2) {
    frac1.num *= frac2.denum;
    frac1.denum *= frac2.denum;
    frac2.num *= frac1.denum;
    frac2.denum *= frac1.denum;
    fraction frac_res{frac1.num + frac2.num, frac1.denum};
    reduce_fraction_inplace(frac_res);
    return frac_res;
}

double sum_fraction_array_approx(fraction frac_array[], int n) {
    // This is an approximation since we use floating points,
    // which are subject to floating point represation errors
    int a, b;
    double sum;
    for(int i = 0; i < n; i++){
        a = frac_array[i].num;
        b = frac_array[i].denum;
        sum += static_cast<double>(a / b);
    }
    return sum;
}

fraction sum_fraction_array(fraction frac_array[], int n){
    fraction result{0, 1};
    for(int i = 0; i < n; i ++){
        result = add_fractions(result, frac_array[i]);
    }
    return result;
}

void fill_fraction_array(fraction frac_array[], int n) {
    fraction temp_frac;
    temp_frac.num = 1;
    for (int i = 1; i <= n; i++) {
        temp_frac.denom = i * (i + 1);
        frac_array[i - 1] = temp_frac;
    }
}
