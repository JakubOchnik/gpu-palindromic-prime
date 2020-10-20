#include "CPU_implementation.h"

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
	for (int i = 0; i < N; i++) {
		for (int j = 2; j * j <= i; j++) {
			if (i % j == 0) {
				out[i] = false;
			}
			else if (j + 1 > sqrt(i)) {
				if (!isPalindromeCPU(out[i])) {
					out[i] = false;
				}
			}
		}
	}
}

void CPUprimeSieve(bool* out, int N) {
	int i = 2;
	for (; i * i < 2 * N; i++) {
		if (out[i] == true) {
			for (int j = i * i; j < 2 * N; j += i) {
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
	for (int i = 0; i < 2 * N; i++) {
		if (arr[i] == true)
			printf("%d\n", i);
	}
}