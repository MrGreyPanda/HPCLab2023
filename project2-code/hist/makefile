CXXFLAGS=-std=gnu++11 -O3

all: hist_seq hist_omp

hist_seq: hist_seq.cpp
	g++ $(CXXFLAGS) $^ -o $@

hist_omp: hist_omp.cpp
	g++ -O3 -fopenmp $^ -o $@

clean:
	rm -rf hist_seq hist_omp

