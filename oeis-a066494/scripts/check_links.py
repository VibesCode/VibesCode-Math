#!/usr/bin/env python3
"""Checks for every link of the proof outlined in ../RESULT.md.

1. Constants: gamma < ln 2 (so e^gamma < 2); ln ln 688383 >= 1; 688383 >= 396738.
2. Polynomial domination: 8 l^2 + 4*2.50637*2 l + 2*2.50637^2 <= 12.5 l^2 + 25 l + 25
   coefficientwise (exact rationals), so 2*(2l + 2.50637)^2 <= 25 e^l for l >= 0.
3. Sanity of the cited bounds on data (transcription check, NOT proof):
   - Dusart Prop 6.8: p_{k+1} <= p_k (1 + 1/(25 ln^2 p_k)) for all p_k >= 396738 in range;
   - Dusart Prop 6.6: p_k <= k(ln k + lnln k - 1 + (lnln k - 2)/ln k) for 688383 <= k in range;
   - RS Thm 15: n/phi(n) < e^g lnln n + 2.50637/lnln n for 3 <= n <= N.
4. The chain itself on N0 <= n <= N: g_n <= 2n/(25 ln n) < phi(n); g_sigma(n) <= 2nr/(25 ln n) <= n/r.
"""
import sys
from fractions import Fraction as F
import numpy as np
import mpmath as mp

mp.mp.dps = 40
ok = True
def chk(name, cond):
    global ok
    print(("PASS " if cond else "FAIL ") + name)
    ok &= bool(cond)

# 1
iv = mp.iv
iv.dps = 40
g = mp.euler
chk("gamma < ln 2  (gamma=%s, ln2=%s)" % (mp.nstr(g, 15), mp.nstr(mp.log(2), 15)), g < mp.log(2))
chk("e^gamma = %s <= 2" % mp.nstr(mp.e ** g, 15), mp.e ** g <= 2)
lln = iv.log(iv.log(iv.mpf(688383)))
chk("lnln 688383 in %s >= 1" % lln, lln.a >= 1)
chk("688383 >= 396738", 688383 >= 396738)
# 2
c = F(250637, 100000)
lhs = [F(2) * 4, F(2) * 2 * 2 * c, F(2) * c * c]  # l^2, l, 1 coefficients of 2(2l+c)^2
rhs = [F(25, 2), F(25), F(25)]                     # of 25(1 + l + l^2/2)
chk("coefficientwise %s <= %s" % ([float(x) for x in lhs], [float(x) for x in rhs]),
    all(a <= b for a, b in zip(lhs, rhs)))
chk("B>=1 so 2B <= 2B^2 (B(l)=e^g l + c/l >= 2 sqrt(e^g c) = %s)" % mp.nstr(2*mp.sqrt(mp.e**g*c), 6),
    2 * mp.sqrt(mp.e ** g * c) >= 1)

# 3, 4 on data
N = int(sys.argv[1]) if len(sys.argv) > 1 else 3000000
phi = np.arange(N + 1, dtype=np.int64)
for p in range(2, N + 1):
    if phi[p] == p:
        phi[p::p] -= phi[p::p] // p
sigma = np.zeros(N + 1, dtype=np.int64)
for d in range(1, N + 1):
    sigma[d::d] += d
M = int(sigma[1:].max()) + 2
lim = int(M * (np.log(M) + np.log(np.log(M)))) + 100
s = np.ones(lim + 1, dtype=bool); s[:2] = False
for i in range(2, int(lim ** 0.5) + 1):
    if s[i]:
        s[i * i::i] = False
pr = np.nonzero(s)[0].astype(np.float64)
pri = np.nonzero(s)[0]
assert len(pr) >= M
K = len(pr) - 1
k = np.arange(1, K + 1, dtype=np.float64)       # p_k = pr[k-1]
pk = pr[:K]; gk = (pri[1:K + 1] - pri[:K]).astype(np.float64)
# floating checks with a relative safety margin; failures here would mean a transcription error
m68 = pk >= 396738
chk("Dusart 6.8 on %d primes up to %d" % (m68.sum(), int(pk[-1])),
    np.all(gk[m68] <= pk[m68] / (25 * np.log(pk[m68]) ** 2) * (1 + 1e-12)))
m66 = k >= 688383
lk = np.log(k[m66]); llk = np.log(lk)
chk("Dusart 6.6 for 688383 <= k <= %d" % K,
    np.all(pk[m66] <= k[m66] * (lk + llk - 1 + (llk - 2) / lk) * (1 + 1e-12)))
n = np.arange(3, N + 1, dtype=np.float64)
r = n / phi[3:].astype(np.float64)
B = np.exp(float(mp.euler)) * np.log(np.log(n)) + 2.50637 / np.log(np.log(n))
chk("RS Thm 15 for 3 <= n <= %d (min slack %.4f)" % (N, (B - r).min()), np.all(r < B))
N0 = 688383
n = np.arange(N0, N + 1)
nf = n.astype(np.float64); L = np.log(nf)
ph = phi[n].astype(np.float64); rr = nf / ph
g494 = gk[n - 1]; g516 = gk[sigma[n] - 1]
chk("chain A066494: g_n <= 2n/(25 ln n) < phi(n) on [N0,N]",
    np.all(g494 <= 2 * nf / (25 * L)) and np.all(2 * nf / (25 * L) < ph))
chk("chain A066516: sigma < n r, g_m <= 2nr/(25 ln n) <= n/r on [N0,N]",
    np.all(sigma[n] < nf * rr) and np.all(g516 <= 2 * nf * rr / (25 * L)) and np.all(2 * nf * rr / (25 * L) <= nf / rr))
print("max over [N0,N] of 2r^2/(25 ln n) = %.4f (must be <= 1)" % (2 * rr ** 2 / (25 * L)).max())
print("ALL PASS" if ok else "SOME FAILED")
