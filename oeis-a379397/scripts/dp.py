# Program 1: DP count of multisets of <= 9 positive cubes summing to n, for n <= N.
import sys
N = int(sys.argv[1])
M = 1
while (M+1)**3 <= N: M += 1
# f[j][n] = number of multisets with exactly j parts (cubes processed so far)
f = [[0]*(N+1) for _ in range(10)]
f[0][0] = 1
for c in range(1, M+1):
    q = c**3
    for j in range(1, 10):
        a, b = f[j], f[j-1]
        for n in range(q, N+1):
            a[n] += b[n-q]
r = [sum(f[j][n] for j in range(1, 10)) for n in range(N+1)]
# also: which m <= N are NOT a sum of <= 8 positive cubes
not8 = [m for m in range(1, N+1) if sum(f[j][m] for j in range(1, 9)) == 0]
print("NOT8", not8)
for k in range(1, 6):
    s = [n for n in range(1, N+1) if r[n] == k]
    print("K", k, len(s), s[-1] if s else None, ",".join(map(str, s)))
# largest n with r(n) <= K for K up to 40 (within N)
for K in range(1, 41):
    s = [n for n in range(1, N+1) if r[n] == K]
    print("LAST", K, len(s), s[-1] if s else None)
