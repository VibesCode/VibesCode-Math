#!/usr/bin/env python3
"""Finite check, program A (numpy sieve).

A066494: n >= 1 with prime(n+1) - prime(n) = phi(n).
A066516: n >= 1 with prime(s+1) - prime(s) = phi(n), s = sigma(n).

Usage: python3 check_a.py N
Lists every term n <= N of both sequences, and also reports
  max over 100 < n <= N of gap/phi  (both sequences),
so the margin is visible. Exact integer arithmetic only.
"""
import sys
import numpy as np

N = int(sys.argv[1])

# phi and sigma for 1..N by sieve over divisors / primes
phi = np.arange(N + 1, dtype=np.int64)
for p in range(2, N + 1):
    if phi[p] == p:  # p prime
        phi[p::p] -= phi[p::p] // p
sigma = np.zeros(N + 1, dtype=np.int64)
for d in range(1, N + 1):
    sigma[d::d] += d

need_index = int(max(N + 1, sigma[1:].max() + 1))  # need prime(need_index)


def primes_upto(m):
    s = np.ones(m + 1, dtype=bool)
    s[:2] = False
    for i in range(2, int(m ** 0.5) + 1):
        if s[i]:
            s[i * i::i] = False
    return np.nonzero(s)[0]


limit = 100
while True:
    pr = primes_upto(limit)
    if len(pr) >= need_index:
        break
    limit *= 2
# prime(k) = pr[k-1]
gap = pr[1:] - pr[:-1]  # gap[k-1] = prime(k+1) - prime(k)

n = np.arange(1, N + 1)
g494 = gap[n - 1]
g516 = gap[sigma[1:] - 1]
ph = phi[1:]
t494 = n[g494 == ph]
t516 = n[g516 == ph]
print("N =", N, " primes used up to", int(pr[need_index - 1]))
print("A066494 terms <= N:", t494.tolist())
print("A066516 terms <= N:", t516.tolist())
m = n > 100
r494 = (g494[m] / ph[m]).max()
r516 = (g516[m] / ph[m]).max()
print("max gap/phi over 100<n<=N: A066494 %.6f  A066516 %.6f" % (r494, r516))
