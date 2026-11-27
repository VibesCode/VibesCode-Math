# Program 1b: dp.py vectorised with numpy (same recurrence: rows j ascending, a[q:] += b[:-q]).
import sys, numpy as np
N = int(sys.argv[1]); K = int(sys.argv[2])
M = 1
while (M+1)**3 <= N: M += 1
f = np.zeros((10, N+1), dtype=np.int64); f[0, 0] = 1
for c in range(1, M+1):
    q = c**3
    for j in range(1, 10):
        f[j, q:] += f[j-1, :N+1-q]
r = f[1:].sum(axis=0); r8 = f[1:9].sum(axis=0)
assert r.max() < 2**62
print("NOT8", [int(m) for m in np.nonzero(r8[1:] == 0)[0] + 1])
for k in range(1, K+1):
    s = np.nonzero(r[1:] == k)[0] + 1
    print("LAST", k, len(s), int(s[-1]) if len(s) else None)
