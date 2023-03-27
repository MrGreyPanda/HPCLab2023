CXX=c++
CXXFLAGS=-O2  -fopenmp
LDFLAGS=-fopenmp
SOURCES=quicksort.cpp
OBJECTS=$(SOURCES:.cpp=.o)
EXECUTABLE=quicksort

$(EXECUTABLE): $(OBJECTS)
	$(CXX) $(LDFLAGS) $(OBJECTS) -o $@

.cpp.o:
	$(CXX) -c $(CXXFLAGS) $< -o $@ $(DEFINES)
	

clean:
	rm *.o $(EXECUTABLE)
