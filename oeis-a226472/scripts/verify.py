# Exact check of the A226472 terms with Python big integers, plus a direct brute force on a small range.
# Usage: python3 verify.py
import math
def val(n): return (n * n) ^ (n * (n + 1) // 2)
known = [0, 1, 6, 8, 4086, 24136, 162297, 7868054, 29792904, 22666693375]
new = [42286731641, 45162001983, 90220224758]
for n in known + new:
    v = val(n); r = math.isqrt(v)
    assert r * r == v, n
    print(n, v, r, "square")
small = [n for n in range(2 * 10**6) if math.isqrt(val(n)) ** 2 == val(n)]
assert small == [n for n in known if n < 2 * 10**6], small
print("brute force below 2*10^6 gives exactly", small)
print("ALL OK")
