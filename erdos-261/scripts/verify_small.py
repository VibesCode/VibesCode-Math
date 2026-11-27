# Exact check for small n: rebuild a set S with |S| >= 2 and n/2^n = sum_{k in S} k/2^k, and verify the
# sum with exact rational arithmetic. Usage: python3 verify_small.py [N]   (default N = 300)
import sys
from fractions import Fraction
def find(n):
    # breadth-first over residuals E (E_m = 2^m (n/2^n - partial sum)), keeping the path
    level = {n: []}; m = n
    while True:
        nxt = {}
        for e, path in level.items():
            for x, take in ((2 * e, False), (2 * e - (m + 1), True)):
                if 0 <= x <= m + 3 and x not in nxt:
                    nxt[x] = path + [m + 1] if take else path
        m += 1; level = nxt
        if 0 in level: return level[0]
N = int(sys.argv[1]) if len(sys.argv) > 1 else 300
# n = 1 is special: the search above would return the single term {2} (2/4 = 1/2), so check a 3-term set directly.
assert Fraction(3, 8) + Fraction(6, 64) + Fraction(8, 256) == Fraction(1, 2)
for n in range(2, N + 1):
    S = find(n)
    assert len(S) >= 2 and len(set(S)) == len(S), (n, S)
    assert sum(Fraction(k, 2 ** k) for k in S) == Fraction(n, 2 ** n), n
print(f"n = 1..{N}: every n/2^n is an exact sum of k/2^k over at least two distinct k")
print("ALL OK")
