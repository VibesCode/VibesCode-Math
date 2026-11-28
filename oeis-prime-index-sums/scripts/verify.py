# Exact checks for A263546, A153022 and A263076 with plain Python integers (no packages).
# 1. Brute force over the first 10^6 primes: the hits must be exactly the listed OEIS terms in that range.
# 2. A153022: from the exact sums of squares Q_i printed by both.c (logs/both-1e13.txt, DUMP lines),
#    recompute the residues of the listed a(11)-a(13) and the shifted condition.
# Usage: python3 scripts/verify.py
import re, sys, os
N = 10**6
lim = 15485864  # prime(10^6) = 15485863
s = bytearray([1]) * (lim + 1); s[0] = s[1] = 0
for i in range(2, int(lim**0.5) + 1):
    if s[i]: s[i*i::i] = bytearray(len(range(i*i, lim + 1, i)))
P = [i for i in range(lim + 1) if s[i]][:N]
assert len(P) == N and P[-1] == 15485863
a263546, a153022, a263076 = [], [], []
S = Q = Se = 0
for i, p in enumerate(P, 1):
    S += p; Q += p * p
    if i % 2 == 0:
        Se += p
        if Se % (i // 2) == 0: a263546.append(i // 2)
        if S % i == i // 2: a263076.append(i)
    if (Q + 1) % (i + 1) == 0: a153022.append(i)
J = [j for j in a263546 if 2 * j <= N]
assert J == [1, 2, 6, 12, 15, 28, 40, 92, 111, 113, 145, 223, 268, 420, 625, 2080, 2282, 2996, 3371, 19560, 38032, 54426], J
assert a153022 == [6, 10, 150, 238, 56824, 665460], a153022
assert a263076 == [2, 1810, 2458, 240926, 317602, 757730, 771610], a263076
# A153022 at the listed a(11)-a(13): exact Q_{k-1}, Q_k, Q_{k+1} and p_k, p_{k+1} from both.c
here = os.path.dirname(os.path.abspath(__file__))
D = {}
for line in open(os.path.join(here, "..", "logs", "both-1e13.txt")):
    m = re.match(r"DUMP i=(\d+) p=(\d+) Q=(\d+)", line)
    if m: D[int(m[1])] = (int(m[2]), int(m[3]))
want = {33256634229: 21015366399, 66874977806: 34587694346, 68066767730: 3633680201}
for k, r in want.items():
    (pk, qk), (pk1, qk1), (_, qkm) = D[k], D[k + 1], D[k - 1]
    assert qk - qkm == pk * pk and qk1 - qk == pk1 * pk1   # consistent consecutive sums
    assert (qk + 1) % (k + 1) == r != 0                     # fails the entry's definition
    assert (qk1 + 1) % (k + 1) == 0                         # holds with the index shifted by one
pk, qk = D[41425567038]
assert pk == 1105680866959 and (qk + 1) % 41425567039 == 0   # the term found after a(10)
print("brute force over the first 10^6 primes matches the listed terms of all three entries")
print("A153022: listed a(11)-a(13) give residues 21015366399, 34587694346, 3633680201; shifted index gives 0")
print("Note: Q_k at those indices comes from the full scan log; the 10^13 scans are not rerun here.")
print("ALL OK")
