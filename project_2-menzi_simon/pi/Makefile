# Makefile for atan.cpp

# Compiler specifications
CXX=c++
CFLAGS=-Wall -Wextra -pedantic -fopenmp -std=c++11 -O3

# File names
EXEC=atan
SRCS=atan.cpp
OBJS=$(SRCS:.cpp=.o)


# Compilation rules
%.o: %.cpp 
	$(CXX) $(CFLAGS) -c $< -o $@

$(EXEC): $(OBJS)
	$(CXX) $(CFLAGS) $(OBJS) -o $(EXEC)

# Clean command
clean:
	rm -f $(EXEC) $(OBJS)
