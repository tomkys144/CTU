#include <iostream>
#include <math.h>
#include <numeric>
#include <queue>
#include <valarray>
#include <vector>
#include <set>
#include <tuple>

using namespace std;

int input(long long int numbers[], int N);

int findPrimes(set<int> &primes, int Pmax);

int findMod(long long int numbers[], int N);

int findMods(set<int> &primes, set<long long int> &mods, long long int Mmax);

long long int findMultiplier(long long int numbers[], long long int M);

long long int findIncrement(long long int numbers[], long long int M, long long int A);

bool verify(long long int numbers[], long long int M, long long int A, long long int C, int N, long long int Mmax);

long long int modInverse(long long int a, long long int m);

int main() {
    int Pmax, N;
    long long int Mmax;

    if (scanf("%i %lli %i", &Pmax, &Mmax, &N) != 3) return EXIT_FAILURE;

    if (Pmax < 5 || Pmax > 503) return EXIT_FAILURE;
    if (Mmax < 25 || Mmax > 2 * pow(10, 18)) return EXIT_FAILURE;
    if (N < 10 || N > 30) return EXIT_FAILURE;

    long long int numbers[N];

    if (input(numbers, N) != EXIT_SUCCESS) return EXIT_FAILURE;

    set<int> primes;

    findPrimes(primes, Pmax);

    // set<long long int> mods;

    // findMods(primes, mods, Mmax);

    long long int A, C, M;
    // bool finished = false;
    // for (long long int m: mods) {
    //     long long int a = findMultiplier(numbers, m);
    //     long long int c = findIncrement(numbers, m, a);
    //
    //     if (verify(numbers, m, a, c, N, Mmax)) {
    //         A = a;
    //         C = c;
    //         M = m;
    //
    //         finished = true;
    //
    //         break;
    //     }
    // }

    // if (!finished) return EXIT_FAILURE;

    M = findMod(numbers, N);
    A = findMultiplier(numbers, M);
    C = findIncrement(numbers, M, A);

    printf("%lli %lli %lli\n", A, C, M);

    return EXIT_SUCCESS;
}

int input(long long int numbers[], int N) {
    for (int i = 0; i < N; i++) {
        if (scanf("%lli", &numbers[i]) != 1) return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

int findPrimes(set<int> &primes, int Pmax) {
    vector<bool> isPrime(Pmax + 1, true);

    isPrime[0] = isPrime[1] = false;

    for (int i = 2; i * i <= Pmax; i++) {
        if (isPrime[i]) {
            for (int j = i * i; j <= Pmax; j += i) {
                isPrime[j] = false;
            }
        }
    }

    for (int i = 5; i <= Pmax; i++) {
        if (isPrime[i]) {
            primes.insert(i);
        }
    }

    return EXIT_SUCCESS;
}

int findMod(long long int numbers[], int N) {
    long long int diffs[N - 1];
    for (int i = 0; i < N - 1; i++) {
        diffs[i] = numbers[i + 1] - numbers[i];
    }

    long long int zeros[N - 3];
    for (int i = 0; i < N - 3; i++) {
        zeros[i] = (diffs[i + 2] * diffs[i]) - (diffs[i + 1] * diffs[i + 1]);
    }

    long long int gcdAll = zeros[0];
    for (int i = 1; i < N - 3; i++) {
        gcdAll =  __gcd(gcdAll, zeros[i]);
    }
    long long int M = abs(gcdAll);
    return M;
}

int findMods(set<int> &primes, set<long long int> &mods, long long int Mmax) {
    vector<long long int> currentMods;

    for (int prime: primes) {
        currentMods.push_back(prime);

        for (const int e: primes) {
            if (e == prime) continue;

            const size_t cmSize = currentMods.size();

            for (int i = 0; i < cmSize; i++) {
                long long int p = e * currentMods[i];
                currentMods.push_back(p);
            }
        }

        for (long long int m: currentMods) {
            if (m * m <= Mmax && m * m > 0) {
                mods.insert(m * m);
            }
        }

        currentMods.clear();
    }

    return EXIT_SUCCESS;
}

long long int findMultiplier(long long int numbers[], long long int M) {
    long long int A = (numbers[2] - numbers[1]) * modInverse(numbers[1] - numbers[0], M) % M;
    if (A < 0) A += M;
    if (A > M) A -= M;
    return A;
}

long long int findIncrement(long long int numbers[], long long int M, long long int A) {
    long long int C = (numbers[1] - numbers[0] * A) % M;
    if (C < 1) C += M;
    if (C > M) C -= M;
    return C;
}

bool verify(long long int numbers[], long long int M, long long int A, long long int C, int N, long long int Mmax) {
    if (M < 1 || M > Mmax) return false;
    if (A < 1 || A >= M) return false;
    if (C < 1 || C >= M) return false;

    for (int i = 1; i < N; i++) {
        long long int x = (A * numbers[i - 1] + C) % M;
        if (numbers[i] != x) return false;
    }
    return true;
}

tuple<long long int, long long int, long long int> egcd(long long int a, long long int b) {
    if (a == 0) return {b, 0, 1};

    auto [g, x, y] = egcd(b % a, a);

    return {g, y - (b / a) * x, x};
}

long long int modInverse(long long int a, long long int m) {
    auto [g, x, y] = egcd(a, m);
    if (g == 1) return x % m;

    return NULL;
}