#include <stdio.h>
#include <cuda_runtime.h>

// Convert RGB to grayscale on GPU
__global__ void convertToGray(unsigned char* rgb, unsigned char* gray, int width, int height) {
    // Get pixel position
    int x = blockIdx.x * blockDim.x + threadIdx.x;
    int y = blockIdx.y * blockDim.y + threadIdx.y;
    
    
    if (x < width && y < height) {
        // Calculate position in RGB array (3 values per pixel)
        int pos = (y * width + x) * 3;
        
        // Get RGB values
        int r = rgb[pos];
        int g = rgb[pos + 1];
        int b = rgb[pos + 2];
        
        // Simple average of RGB values
        gray[y * width + x] = (r + g + b) / 3;
    }
}

int main() {
    // Image size
    int width = 640;
    int height = 480;
    
    // Allocate memory for input RGB image
    unsigned char* inputImage = new unsigned char[width * height * 3];
    
    // Fill with white pixels for testing
    for (int i = 0; i < width * height * 3; i++) {
        inputImage[i] = 255;
    }
    
    // Allocate memory for output grayscale image
    unsigned char* outputImage = new unsigned char[width * height];
    
    // GPU memory pointers
    unsigned char *d_input, *d_output;
    
    // Allocate GPU memory
    cudaMalloc(&d_input, width * height * 3);
    cudaMalloc(&d_output, width * height);
    
    // Copy input image to GPU
    cudaMemcpy(d_input, inputImage, width * height * 3, cudaMemcpyHostToDevice);
    
    // Set up grid and blocks
    dim3 block(16, 16);  // 16x16 threads per block
    dim3 grid((width + 15) / 16, (height + 15) / 16);
    
    // Run conversion on GPU
    convertToGray<<<grid, block>>>(d_input, d_output, width, height);
    
    // Copy result back to CPU
    cudaMemcpy(outputImage, d_output, width * height, cudaMemcpyDeviceToHost);
    
    // Clean up
    cudaFree(d_input);
    cudaFree(d_output);

}
