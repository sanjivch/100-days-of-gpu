__global__ void vecadd( const float* A, const float* B, float* C, int n){
    int i = blockDim.x * blockIdx.x + threadIdx.x ;

    if (i < n){
        C[i] = A[i] + 2.5*B[i];
    }
}
#include<iostream>
int main(){
    const int n = 1024;
    const int size = n*sizeof(float);

    float h_A[n], h_B[n], h_C[n];
    float *d_A, *d_B, *d_C;

    // h_A = new float [n];
    // h_B = new float [n];
    // h_C = new float [n];

    for(int i = 0 ;i <n;i++){
        h_A[i] = 1.0;
        h_B[i] = 0.5*i;
        
    }

    cudaMalloc((void**)&d_A,size);
    cudaMalloc((void**)&d_B,size);
    cudaMalloc((void**)&d_C,size);

    cudaMemcpy(d_A, h_A, size,cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B,size,cudaMemcpyHostToDevice);

     int threadsPerBlock = 256;
    int blocksPerGrid = ( n + threadsPerBlock -1) / threadsPerBlock;

    vecadd<<<blocksPerGrid, threadsPerBlock>>>(d_A,d_B,d_C,n);

    cudaMemcpy(h_C,d_C, size,cudaMemcpyDeviceToHost);
    for(int i =0;i<n;i++){
        printf("%d\t%f\t%f\t%f\n", i, d_A[i], d_B[i], d_C[i]);
    }

    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);


}
