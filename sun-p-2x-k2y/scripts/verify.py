# Exact check of the k = 47 list with plain Python integers (no packages).
# For each listed N it tries every (x, y) with x, y >= 1 and confirms N - 2^x - 47*2^y is never an odd prime.
# Usage: python3 scripts/verify.py k47_exceptions_below_1e10.txt
import sys
def mr(n, bases=(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37)):
    # deterministic Miller-Rabin; these bases are correct for all n < 3.3*10^24
    if n < 2: return False
    for p in bases:
        if n % p == 0: return n == p
    d, s = n - 1, 0
    while d % 2 == 0: d //= 2; s += 1
    for a in bases:
        x = pow(a, d, n)
        if x in (1, n - 1): continue
        for _ in range(s - 1):
            x = x * x % n
            if x == n - 1: break
        else: return False
    return True
def rep(N, k):
    y = 1
    while k * 2**y + 2 < N:
        x = 1
        while 2**x + k * 2**y + 3 <= N:
            p = N - 2**x - k * 2**y
            if p % 2 and mr(p): return (p, x, y)
            x += 1
        y += 1
    return None
L = [int(t) for t in open(sys.argv[1]) if t.strip()]
assert len(L) == 143 and L == sorted(set(L)) and L[0] == 22537515 and L[-1] < 10**10
assert all(N % 2 == 1 for N in L)
assert all(rep(N, 47) is None for N in L), "a listed N is representable"
assert all(N % 1365 == 0 for N in L)
assert rep(353, 51) is None
assert all(rep(N + 2, 47) is not None for N in L[:20]), "control N+2 not representable"
print("143 listed N: none is p + 2^x + 47*2^y; all divisible by 1365; 353 is not p + 2^x + 51*2^y")
print("Note: that no other N < 10^10 fails is shown by the exhaustive scans, not by this script.")
print("ALL OK")
