#include <array>
#include <iostream>
#include <math.h>
#include <numeric>
#include <queue>
#include <valarray>
#include <vector>
#include <set>
#include <tuple>

#define MAXPRIME    503
#define MAXMOD      2000000000000000000

using namespace std;

constexpr bool isPrime(size_t n) noexcept {
    if (n <= 1) return false;
    for (size_t i = 2; i * i <= n; i++) if (n % i == 0) return false;
    return true;
}

constexpr unsigned int primeAtIndex(size_t i) noexcept {
    size_t k{3};
    for (size_t counter{}; counter < i; ++k)
        if (isPrime(k)) ++counter;
    return (k - 1) * (k - 1);
}

template<typename Generator, size_t ... Indices>
constexpr array<unsigned int, sizeof...(Indices)> generateArrayHelper(Generator generator,
                                                                      std::index_sequence<Indices...>) {
    return array<unsigned int, sizeof...(Indices)>{generator(Indices)...};
}

template<size_t Size, typename Generator>
constexpr auto generateArray(Generator generator) {
    return generateArrayHelper(generator, std::make_index_sequence<Size>());
}

int input(long long numbers[], int N);

tuple<long long, long long, long long> findMods(set<long long> &mods, long long numbers[], int Pmax, long long Mmax,
                                                long long maxN, int N, int idx, long long M);

long long findMultiplier(long long numbers[], long long M);

long long findIncrement(long long numbers[], long long M, long long A);

bool verify(long long numbers[], long long M, long long A, long long C, int N, long long Mmax);

long long modInverse(long long a, long long m);


constexpr array<unsigned int, MAXPRIME> Primes = generateArray<MAXPRIME>(primeAtIndex);

int main() {
    int Pmax, N;
    long long Mmax;

    if (scanf("%i %lli %i", &Pmax, &Mmax, &N) != 3) return EXIT_FAILURE;

    if (Pmax < 5 || Pmax > 503) return EXIT_FAILURE;
    if (Mmax < 25 || Mmax > 2 * pow(10, 18)) return EXIT_FAILURE;
    if (N < 10 || N > 30) return EXIT_FAILURE;

    long long numbers[N];

    if (input(numbers, N) != EXIT_SUCCESS) return EXIT_FAILURE;

    long long maxN = 0;
    for (long long number: numbers) {
        if (number > maxN)
            maxN = number;
    }

    set<long long> mods;

    long long A, C, M;

    auto res = findMods(mods, numbers, Pmax, Mmax, maxN, N, 0, 1);

    A = get<0>(res), C = get<1>(res), M = get<2>(res);

    //    M = findMod(numbers, N);
    //    A = findMultiplier(numbers, M);
    //    C = findIncrement(numbers, M, A);

    printf("%lli %lli %lli\n", A, C, M);

    return EXIT_SUCCESS;
}

int input(long long numbers[], int N) {
    for (int i = 0; i < N; i++) {
        if (scanf("%lli", &numbers[i]) != 1) return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}

tuple<long long, long long, long long> findMods(set<long long> &mods, long long numbers[], int Pmax, long long Mmax,
                                                long long maxN, int N, int idx, long long M) {
    if (Primes[idx] > Pmax * Pmax)
        return make_tuple(-1, -1, -1);

    if (M > maxN) {
        long long a = findMultiplier(numbers, M);
        long long c = findIncrement(numbers, M, a);

        if (verify(numbers, M, a, c, N, Mmax)) {
            return make_tuple(a, c, M);
        }
    }

    auto res = findMods(mods, numbers, Pmax, Mmax, maxN, N, idx + 1, M);
    if (get<0>(res) != -1) return res;

    if (M <= Mmax / Primes[idx]) {
        res = findMods(mods, numbers, Pmax, Mmax, maxN, N, idx + 1, M * Primes[idx]);
        if (get<0>(res) != -1) return res;
    }

    return make_tuple(-1, -1, -1);
}

long long findMultiplier(long long numbers[], long long M) {
    long long diff1 = (numbers[2] - numbers[1] + M) % M;
    long long diff2 = (numbers[1] - numbers[0] + M) % M;
    long long diff2Inverse = modInverse(diff2, M);
    long long A = ((__int128)diff1 * diff2Inverse) % M;

    A = (A + M) % M;
    return A;
}

long long findIncrement(long long numbers[], long long M, long long A) {

    long long C = (numbers[1] - ((__int128) numbers[0] * A % M)) % M;

    C = (C + M) % M;
    return C;
}

bool verify(long long numbers[], long long M, long long A, long long C, int N, long long Mmax) {
    if (M < 1 || M > Mmax) return false;
    if (A < 1 || A >= M) return false;
    if (C < 1 || C >= M) return false;

    for (int i = 1; i < N; i++) {
        long long x = ((__int128)A * numbers[i - 1] + C) % M;
        if (numbers[i] != x) return false;
    }
    return true;
}

long long egcd(long long a, long long b, long long *x, long long *y) {
    if (a == 0) {
        *x = 0;
        *y = 1;
        return b;
    }

    long long x1, y1;
    long long gcd = egcd(b % a, a, &x1, &y1);

    *x = y1 - (b / a) * x1;
    *y = x1;

    return gcd;
}

long long modInverse(long long a, long long m) {
    long long x, y;

    a = (a + m) % m;

    long long g = egcd(a, m, &x, &y);

    if (g != 1)
        return -1;

    long long res = (x % m + m) % m;

    return res;
}
