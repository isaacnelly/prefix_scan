#include <stdlib.h>
#include <string>
#include <iostream>
#include <cuda_runtime.h>
#include <curand_kernel.h>

#define THREADS_PER_BLOCK 256

/**
 * @brief kogge stone algorithm, inclusive w/ parallelization
 * 
 * @param output 
 * @param input 
 * @param partialSums 
 * @return __global__ 
 */
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

/**
 * @brief generates a random array, length provided in main. 
 * 
 * @param length 
 * @return __global 
 */
__global void generateRandomArray(unsigned int* array, unsigned int length, unsigned long long seed){
    unsigned int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i < length){
        curandState state;
        curand_init(seed,i,0,&state);
        array[i] = curand(&state);
    }
}

int main(){
    int n = 1024;
    unsigned int* RandIntArray_d;
    int blocks = (n + THREADS_PER_BLOCK - 1) / THREADS_PER_BLOCK;

    cudaMalloc((void**)&RandIntArray, n*sizeof(unsigned int));

    generateRandomArray<<<blocks,THREADS_PER_BLOCK>>>(RandIntArray,n,0);


    return 0;
}