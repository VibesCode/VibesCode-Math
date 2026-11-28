# Exact check of a(23) and a(24) of A073614 with Python integers (no packages).
# Usage: python3 verify.py
import math
m, p, r = 55185648700, 1489415921531, 286695629220
assert m * (p + 1) == r * r and math.isqrt(m * (p + 1)) == r
assert m == 7 * (2 * 5 * 13 * 683) ** 2 and p + 1 == 7 * (2 * 3 * 11 * 29 * 241) ** 2
m24, p24, r24 = 332955594488, 9607832872831, 1788569737504
assert m24 * (p24 + 1) == r24 * r24 and math.isqrt(m24 * (p24 + 1)) == r24
assert m24 == 62 * (2 * 11 * 3331) ** 2 and p24 + 1 == 62 * (2**3 * 49207) ** 2
def mr(n, bases=(2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41)):
    # deterministic Miller-Rabin; these bases are correct for all n < 3.3*10^24
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
assert mr(p) and mr(p24)
print(f"a(23): m*(p+1) = {r}^2 exactly; p = {p} is prime (deterministic Miller-Rabin)")
print(f"a(24): m*(p+1) = {r24}^2 exactly; p = {p24} is prime (deterministic Miller-Rabin)")
print("Note: that p is the m-th prime (pi(p) = m) is shown by the sieve runs, not by this script.")
print("ALL OK")
