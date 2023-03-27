#include <iostream>
#include <unistd.h> // defines HOST_NAME_MAX
#include <limits.h> // defines gethostname

int main() {
    char hostname[HOST_NAME_MAX];
    gethostname(hostname, sizeof(hostname));

    std::cout << "Hello World from " << hostname << std::endl;

    return 0;
}