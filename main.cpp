#include "utils.h"
#include "CPU_implementation.h"
#include "cuda_palindromes.h"

#define N 10000

int main()
{
	int* mainArr = (int*)malloc(N * sizeof(int));

	filterArray(mainArr, N);
	CUDA_palindromes(mainArr, N/2);
	printArr(mainArr, N/2);

	free(mainArr);

	return 0;
}
