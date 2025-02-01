#include<iostream>


__global__ void printThreadIdx(int N) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx < N) { // Ensure the thread is within bounds
        printf("Block: %d, Thread: %d, block dim: %d, Global Index: %d\n", blockIdx.x, threadIdx.x, blockDim.x, idx);
    }
}

int main(){

    printf("Hello world\n");

    // 

    printThreadIdx<<<20, 32>>>(604);

    cudaDeviceSynchronize();
}
