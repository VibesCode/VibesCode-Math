# List every prime p > 7 with p - 1 = 2^a 3^b 5^c 7^d <= LIMIT, as "a b c d" lines (sympy.isprime: BPSW; every true prime
# passes it, so no qualifying prime is ever left out; a composite wrongly listed would only add spurious candidates,
# and every final hit is re-verified exactly).
import sys, sympy
LIMIT = int(sys.argv[1])
out = []
a = 0
while 2**a <= LIMIT:
    b = 0
    while 2**a * 3**b <= LIMIT:
        c = 0
        while 2**a * 3**b * 5**c <= LIMIT:
            d = 0
            while 2**a * 3**b * 5**c * 7**d <= LIMIT:
                s = 2**a * 3**b * 5**c * 7**d
                if s + 1 > 7 and sympy.isprime(s + 1): out.append((s, a, b, c, d))
                d += 1
            c += 1
        b += 1
    a += 1
out.sort()
with open(sys.argv[2], 'w') as f:
    for s, a, b, c, d in out: f.write(f"{a} {b} {c} {d}\n")
print(len(out), "primes")
