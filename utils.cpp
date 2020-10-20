#include "utils.h"

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