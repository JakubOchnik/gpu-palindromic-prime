
#include "cuda_runtime.h"
#include "device_launch_parameters.h"

#include <stdio.h>
#include<iostream>
#include<chrono>
#include<fstream>

/*#define imin(a,b) (a<b?a:b)
const int N = 10;
const int threadsPerBlock = 256;
const int blocksPerGrid = imin(32, (N + threadsPerBlock - 1) / threadsPerBlock);*/

class countTime {
    bool active;
    std::chrono::steady_clock clk;
    std::chrono::steady_clock::time_point t1;
    std::chrono::steady_clock::time_point t2;
    std::chrono::duration<float> duration;
public:
    countTime() {
        active = false;
    }
    void toggleCount() {
        if (!active) {
            t1 = clk.now();
            active = true;
            return;
        }
        else if (active) {
            t2 = clk.now();
            duration = t2 - t1;
            active = false;
        }
    }
    std::chrono::duration<float> printTime() {
        return duration;
    }
};

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
    if (num == rev) {
        return true;
    }
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
        //__syncthreads();
        if (out[tid] != false && isPalindrome(out[tid])) {
        }
        else
            out[tid] = false;
        tid += gridDim.x * blockDim.x;
    }
}

bool isPalindromeCPU(int num) {
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
    if (num == rev) {
        return true;
    }
    else
        return false;
}

void CPUprime(int* out, int N) {
    for (int i = 0; i < N;i++) {
        for (int j = 2; j * j <= i; j++) {
            if (i % j == 0) {
                out[i] = false;
            }
            else if (j + 1 > sqrt(i)) {
                //git
                if (!isPalindromeCPU(out[i])) {
                    out[i] = false;
                }
            }
        }
    }
}

void CPUprimeSieve(bool* out, int N) {
    int i = 2;
    for (; i*i < 2*N; i++) {
        if (out[i] == true) {
            for (int j = i*i; j < 2*N; j += i) {
                out[j] = false;
            }
            //update all next numbers
            if (!isPalindromeCPU(i))
                out[i] = false;
        }
    }
    for (; i < 2 * N; i++) {
        if (out[i] == false || !isPalindromeCPU(i)) {
            out[i] = false;
        }
    }
}

void printSieveArr(bool* arr, int N) {
    for (int i = 0; i < 2*N; i++) {
        if (arr[i] == true)
            printf("%d\n", i);
    }
}

void filterArray(int* arr, int N) {
    for (int i = 0; i < N; i++)
        arr[i] = 2 * i + 1;
    arr[0] = 2;
}

void printArr(int arr[], int N) {
    for (int i = 0; i < N; i++) {
        if (arr[i] != 0)
            printf("%d\n", arr[i]);
    }
}

int main()
{
    std::ofstream data("data.csv");
    if (!data.is_open())
        return -1;
    data.setf(std::ios_base::fixed);
    data << "N,GPU_SIEVE,CPU_SIEVE,CPU_CLASSIC\n";
    for (int i = 10; i <= 100000; i+=10) {
        int N = i;
        printf("%d\n", N);
        data << N << ",";
        const int threadsPerBlock = 256;
        int blocksPerGrid = 32;
        if (32 < (N + threadsPerBlock - 1) / threadsPerBlock)
            int blocksPerGrid = 32;
        else
            int blocksPerGrid = (N + threadsPerBlock - 1) / threadsPerBlock;

        int* mainArr = (int*)malloc(N * sizeof(int));
        int* dev_out;

        countTime timer;
        filterArray(mainArr, N);
        cudaMalloc((void**)&dev_out, N * sizeof(int));
        cudaMemcpy(dev_out, mainArr, N * sizeof(int), cudaMemcpyHostToDevice);
        timer.toggleCount();
        kernel<<<blocksPerGrid, threadsPerBlock>>>(dev_out, N);
        timer.toggleCount();
        //printf("A. GPU Sieve of Eratosthenes implementation:\n%f s\n", timer.printTime().count());
        data << timer.printTime().count() << ",";
        cudaMemcpy(mainArr, dev_out, N * sizeof(int), cudaMemcpyDeviceToHost);
        cudaFree(dev_out);

        bool* arr = (bool*)malloc(2 * N * sizeof(bool));
        memset(arr, true, sizeof(arr));

        timer.toggleCount();
        CPUprimeSieve(arr, N);
        timer.toggleCount();
        //printf("B. CPU Sieve of Eratosthenes implementation:\n%f s\n", timer.printTime().count() / 2);
        data << timer.printTime().count()/2 << ",";

        filterArray(mainArr, N);
        timer.toggleCount();
        CPUprime(mainArr, N);
        timer.toggleCount();
        //printf("C. CPU classic:\n%f s\n", timer.printTime().count());
        data << timer.printTime().count() << "\n";

        free(arr);
        free(mainArr);
    }
    data.close();
    return 0;
}
