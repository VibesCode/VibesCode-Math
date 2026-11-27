# Sharper digit bound for A058627 using the 2-adic valuation.
# For a term n with k digits and digit product P: omega_odd(n) <= v = v2(P) (each odd p | n puts a factor 2 into phi(n)),
# so n/phi(n) <= 2 * R(v), R(v) = prod of q/(q-1) over the v smallest odd primes q with q-1 7-smooth (smaller primes give
# larger factors). Each non-9 digit d satisfies d/9 <= (8/9)^(v2(d)/3), so P <= 9^k (8/9)^(v/3). Hence
#   10^(k-1) <= n <= 2 R(v) (8/9)^(v/3) 9^k  =>  (10/9)^k <= 10 * max_v g(v),  g(v) = 2 R(v) (8/9)^(v/3).
# Exact arithmetic except the cube root, handled by comparing cubes: g(v)^3 = 8 R(v)^3 (8/9)^v.
from fractions import Fraction
import sympy
odd = []
s = 2
cands = sorted({2**a * 3**b * 5**c * 7**d for a in range(1, 200) for b in range(0, 130) for c in range(0, 90) for d in range(0, 75)
                if 2**a * 3**b * 5**c * 7**d < 10**8})
odd = [q + 1 for q in cands if sympy.isprime(q + 1)]        # odd primes q with q-1 7-smooth, q < 10^8+1, ascending
R = Fraction(1); best_cube = Fraction(8); best_v = 0        # v = 0: g^3 = 8
for v, q in enumerate(odd[:400], start=1):
    R *= Fraction(q, q - 1)
    gc = 8 * R**3 * Fraction(8, 9)**v
    if gc > best_cube: best_cube, best_v = gc, v
# beyond v = 400: R(v) <= C/2 < 4.13 and (8/9)^(v/3) tiny, so g(v) < 2*4.13*(8/9)^(400/3) << 1; no larger max
print("max g at v =", best_v, " g =", float(best_cube) ** (1/3))
ks = [k for k in range(1, 100) if Fraction(10, 9)**(3*k) <= 1000 * best_cube]
print("k allowed: max", max(ks))
