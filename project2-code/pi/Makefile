# Makefile for atan.cpp

# Compiler specifications
CXX=c++
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

# run: atan
# 	OMP_NUM_THREADS=1 ./atan 1000000
# 	OMP_NUM_THREADS=2 ./atan 1000000
# 	OMP_NUM_THREADS=4 ./atan 1000000
# 	OMP_NUM_THREADS=8 ./atan 1000000
# 	OMP_NUM_THREADS=16 ./atan 1000000
# 	OMP_NUM_THREADS=24 ./atan 1000000
# 	OMP_NUM_THREADS=32 ./atan 1000000
	

# weak: 
# 	OMP_NUM_THREADS=1 ./atan 1000000
# 	OMP_NUM_THREADS=2 ./atan 2000000
# 	OMP_NUM_THREADS=4 ./atan 4000000
# 	OMP_NUM_THREADS=8 ./atan 8000000
# 	OMP_NUM_THREADS=16 ./atan 16000000
# 	OMP_NUM_THREADS=24 ./atan 24000000
# 	OMP_NUM_THREADS=32 ./atan 32000000


# Clean command
clean:
	rm -f $(EXEC) $(OBJS)
