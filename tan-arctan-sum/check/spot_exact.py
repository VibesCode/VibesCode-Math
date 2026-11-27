# Independent exact spot check at single large n (gmpy2 product tree, full gcd, exact divisibility test).
import sys, gmpy2
from gmpy2 import mpz
q = mpz(2**61 - 1)
def prod(lo, hi):          # prod_{k=lo..hi} (1 + k i) as (re, im)
    if lo == hi: return (mpz(1), mpz(lo))
    m = (lo + hi)//2; a,b = prod(lo,m); c,d = prod(m+1,hi)
    return (a*c - b*d, a*d + b*c)
for n in map(int, sys.argv[1:]):
    A, B = prod(1, n)
    g = gmpy2.gcd(A, B); r = A // g
    print(n, int(g % q), int(r % q), "INTEGER" if (A != 0 and B % A == 0) else "not-integer", "|A/g| bits =", r.bit_length(), file=sys.stdout)
