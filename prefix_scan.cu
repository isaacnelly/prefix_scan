#include <stdlib.h>
#include <string>
#include <iostream>
#include <cuda_runtime.h>

#define THREADS_PER_BLOCK 256

__global__ void kogge_stone_inclusive(unsigned int* output, unsigned int* input, 
    unsigned int* partialSums){
    // boilerplate
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    output[i] = input[i];
    __synchthreads();

    for (unsigned int stride = 1; stride <= BLOCK_DIM/2; stride*=2){
        float v;
        if(threadIdx.x >= stride){
            v = output[i - stride];
        }
        __synchthreads();
        if(threadIdx.x >= stride){
            output[i] += v;
        }
        __synchthreads();
    }

    if(threadIdx.x == BLOCK_DIM - 1){
        partialSums[blockIdx.x] = output[i];
    }
}


int main(){



    return 0;
}