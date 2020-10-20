
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include"cuda_palindromes.h"

#define imin(a,b) (a<b?a:b)
const int threadsPerBlock = 256;

__device__ bool isPalindrome(int num) {
	int current = 0, rev = 0;
	int copy = num;
	if (num >= 0 && num <= 9) {
		return true;
	}
	else {
		do {
			current = copy % 10;
			rev = (rev * 10) + current;
			copy = copy / 10;
		} while (copy != 0);
	}
	if (num == rev)
		return true;
	else
		return false;
}

__global__ void kernel(int* out, int N) {
	int tid = threadIdx.x + blockIdx.x * blockDim.x;
	while (tid < N) {
		int i = 1;
		while ((2 * tid + 3) * i + tid + 1 < N) {
			out[(2 * tid + 3) * i + tid + 1] = false;
			i++;
		}
		if (out[tid] == false || !isPalindrome(out[tid]))
			out[tid] = false;
		tid += gridDim.x * blockDim.x;
	}
}

int* CUDA_palindromes(int* mainArr, int N)
{
	int* dev_out;

	const int blocksPerGrid = imin(32, (N + threadsPerBlock - 1) / threadsPerBlock);

	cudaMalloc((void**)&dev_out, N * sizeof(int));
	cudaMemcpy(dev_out, mainArr, N * sizeof(int), cudaMemcpyHostToDevice);
	kernel<<<blocksPerGrid, threadsPerBlock>>>(dev_out, N);
	cudaMemcpy(mainArr, dev_out, N * sizeof(int), cudaMemcpyDeviceToHost);
	cudaFree(dev_out);
	return 0;
}
