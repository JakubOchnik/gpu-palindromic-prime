
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>

#if __INTELLISENSE__
void __syncthreads();
#endif

#define imin(a,b) (a<b?a:b)
const int N = 10;
const int threadsPerBlock = 256;
const int blocksPerGrid = imin(32, (N + threadsPerBlock - 1) / threadsPerBlock);

int main()
{

    return 0;
}
