# Exact check for OEIS A224241: k such that k^2 XOR (k+1)^2 and k^2 XOR (k+2)^2 are both squares.
import math
def roots(k):
    a, b = (k * k) ^ ((k + 1) ** 2), (k * k) ^ ((k + 2) ** 2)
    r, s = math.isqrt(a), math.isqrt(b)
    return (r, s) if r * r == a and s * s == b else None
known = [0, 3, 130456, 342096, 1226720, 291575011, 379894587, 523040160, 15216609776, 136622606520]
new = {248040136995: (2019429, 1864044), 790113072584: (1362263, 1854790), 1176347566499: (1550565, 2173164)}
assert roots(136622606520) == (526887, 1962550)
for k in known: assert roots(k) is not None, k
for k, rs in new.items(): assert roots(k) == rs, k
small = [k for k in range(2 * 10**6) if roots(k) is not None]
assert small == [k for k in known if k < 2 * 10**6], small
print("ALL OK")
