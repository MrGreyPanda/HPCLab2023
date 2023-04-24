CC=mpicc
CFLAGS=-O3

all: powermethod

powermethod: powermethod.c hpc-power.c hpc-power.h
	$(CC) $(CFLAGS) $^ -o $@ -lm

clean:
	rm -f powermethod
