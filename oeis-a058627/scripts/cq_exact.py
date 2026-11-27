# Rigorous bound: for every n with phi(n) 7-smooth, n/phi(n) <= C, where C = prod over primes p with p-1 7-smooth of p/(p-1).
# Exact rational product over p - 1 < X = 10^12, exact tail bound: prod_{p-1 >= X} p/(p-1) <= exp(sum_{s >= X, 7-smooth} 1/s)
# <= 1 + 2 t (t < 1). Primality by sympy.isprime (BPSW): a true prime is never rejected, so the product can only be overestimated.
from fractions import Fraction
import sympy
X = 10**12
sm = []
def gen(n, i, ps=(2,3,5,7)):
    if i == 4: sm.append(n); return
    p = ps[i]
    while n < X: gen(n, i+1); n *= p
gen(1, 0)
tot = Fraction(2)*Fraction(3,2)*Fraction(5,4)*Fraction(7,6)
t = tot - sum(Fraction(1, s) for s in sm)
prod = Fraction(1)
for s in sm:
    if sympy.isprime(s + 1): prod *= Fraction(s + 1, s)
C = prod * (1 + 2 * t)
print("tail t =", float(t), " C <=", float(C), " C < 8.2586:", C < Fraction(82586, 10000))
# digit bound: a k-digit term needs 10^(k-1) <= n <= C * phi(n) = C * P <= C * 9^k
B = Fraction(82586, 10000)
ok = [k for k in range(1, 200) if 10**(k-1) <= B * 9**k]
print("k allowed by 10^(k-1) <= 8.2586 * 9^k: max", max(ok), "; all k <= max allowed:", ok == list(range(1, max(ok)+1)))
