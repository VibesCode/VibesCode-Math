# Usage: python3 check_ca_np.py ARRAY_FILE N t k v   (needs numpy)
# Second, vectorised implementation: encode each triple of columns as a base-v number per row and count distinct values.
import sys, itertools, numpy as np
path, N, t, k, v = sys.argv[1], *map(int, sys.argv[2:6])
A = np.loadtxt(path, dtype=np.int64, ndmin=2)
assert A.shape == (N, k), A.shape
assert set(np.unique(A)) == set(range(v))
fail = 0
for cols in itertools.combinations(range(k), t):
    code = np.zeros(N, dtype=np.int64)
    for c in cols: code = code * v + A[:, c]
    if np.unique(code).size != v ** t: fail += 1
print("np checker: failing triples", fail, "of", len(list(itertools.combinations(range(k), t))))
