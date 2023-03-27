#!/bin/bash

# Run makefile
make loop

# Run all executables and write output to file
for num_threads in 1 2 4 8 16 24 32
do
    echo "Running $num_threads threads"
    ./atan.$num_threads >> output.txt
    echo "Done"
done

# Clean up
make clean
