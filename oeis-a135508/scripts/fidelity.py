# Fidelity check for OEIS A135508 (formal-conjectures definitions), written independently of the proof.
from math import lcm
N = 200
x = [0, 1]
for n in range(1, N + 2):
    x.append(2 * x[n] + lcm(x[n], n + 1))   # x(n+1) = 2x(n) + lcm(x(n), n+1)
a = lambda n: 0 if n == 0 else x[n + 1] // x[n] - 2
print("FC a(1..30):", [a(n) for n in range(1, 31)])
print("exact division x(n)|x(n+1) for all n<=200:", all(x[n + 1] % x[n] == 0 for n in range(1, N + 1)))
def isprime(n):
    return n >= 2 and all(n % d for d in range(2, int(n ** .5) + 1))
ps = [p for p in range(2, N + 1) if isprime(p)]
print("primes p<=200, p-2 not prime, a(p-1)=p:", all(a(p - 1) == p for p in ps if not isprime(p - 2)))
print("primes with p-2 prime and a(p-1)=p:", [p for p in ps if isprime(p - 2) and a(p - 1) == p])
print("primes with p-2 prime and a(p-1)!=p:", [(p, a(p - 1)) for p in ps if isprime(p - 2) and a(p - 1) != p][:8])
