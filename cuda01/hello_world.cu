#include <stdio.h>
#include <stdlib.h>


__global__ void print_hello(void) {
    printf("Hello from block %d, thread %d\n", blockIdx.x, threadIdx.x);
}

int main() {


    print_hello<<<1, 1>>>(); // 2 blocks, 4 threads per block
    cudaDeviceSynchronize();

    return 0;
}