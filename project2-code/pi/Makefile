# Makefile for atan.cpp

# Compiler specifications
CXX=g++
CFLAGS=-Wall -Wextra -pedantic -fopenmp -std=c++11

# File names
EXEC=atan
SRCS=atan.cpp
OBJS=$(SRCS:.cpp=.o)


# Compilation rules
%.o: %.cpp 
	$(CXX) $(CFLAGS) -c $< -o $@

$(EXEC): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $(EXEC)

run: atan
	OMP_NUM_THREADS=1 ./atan
	OMP_NUM_THREADS=2 ./atan
	OMP_NUM_THREADS=4 ./atan
	OMP_NUM_THREADS=8 ./atan
	OMP_NUM_THREADS=16 ./atan
	OMP_NUM_THREADS=24 ./atan
	OMP_NUM_THREADS=32 ./atan
	

# Clean command
clean:
	rm -f $(EXEC) $(OBJS)
