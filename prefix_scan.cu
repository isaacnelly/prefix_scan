#include <stdlib.h>
#include <string>
#include <iostream>
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 256

__global__ void kogge_stone_inclusive(unsigned int* output, unsigned int* input){
    // boilerplate
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    output[i] = input[i];
    __synchthreads();

    for (unsigned int stride = 1; stride <= BLOCK_DIM/2; stride*=2){

    }
}

int main(){

    return 0;
}