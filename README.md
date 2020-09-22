# GPU-accelerated palindromic primes generator
CUDA program which uses sieve of Eratosthenes in order to find prime numbers which are **palindromes**
(e.g. 101, 11011).
## Features
Program includes three versions of the generator:
- GPU-accelerated sieve of Erastothenes
- CPU version of Sieve of Eratosthenes
- CPU classic version
## Algorithms
### Sieve of Eratosthenes
A popular, ancient algorithm of finding prime numbers within a given limit. It does so by marking all multiples of each prime number as non-prime and skips them.
### Classic CPU algorithm
It's the simplest, naive solution one can ever find. It's based on a simple loop which checks N numbers in terms of divisibility and being palindromic.
## Performance analysis
Note that the following time values may not be 100% accurate as they might have been influenced by other programs running on the test PC setup and they have been interpolated (rolling mean) in order to make the graphs more clear.
### GPU vs CPU version of Sieve of Eratosthenes
![GPU vs CPU sieve](https://ochnik.me/public/gpu_cpu_sieve.png)
*Comparison of GPU vs CPU speed. Y axis - seconds, X axis - search range*
The comparison clearly shows the advantage of GPU parallel version over the CPU one.
Although, as visible at the very beginning, for smaller search ranges CPU outperforms the GPU.
### Beginning
![GPU vs CPU sieve start](ochnik.me/public/gpu_cpu_sieve_start.png)
*Initial fragment of the previous graph*
### CPU vs CPU classic (iterative) version
![CPU classic vs CPU sieve](ochnik.me/public/cpu_cpu_sieve.png)
It seems that performance-wise, CPU version of sieve of Eratosthenes definitely outperforms classic algorithm.
### Comparison of all 3 versions
![Summary](ochnik.me/public/all.png)
