# Exact check of the new term with the Moebius closed forms (no sieving of the range):
#   Q(X) = #squarefree <= X = sum_{d <= sqrt X} mu(d) floor(X/d^2)
#   S(X) = sum of squarefree <= X = sum_{d <= sqrt X} mu(d) d^2 T(floor(X/d^2)),  T(m) = m(m+1)/2
# Usage: python3 verify.py   (plain Python 3, a few seconds)
import math
def mobius_upto(n):
    mu = [1] * (n + 1); isp = [True] * (n + 1)
    for p in range(2, n + 1):
        if isp[p]:
            for j in range(2 * p, n + 1, p): isp[j] = False
            for j in range(p, n + 1, p): mu[j] = -mu[j]
            for j in range(p * p, n + 1, p * p): mu[j] = 0
    return mu
x = 107251204785
mu = mobius_upto(math.isqrt(x) + 1)
def QS(X):
    q = s = 0
    for d in range(1, math.isqrt(X) + 1):
        if mu[d]:
            m = X // (d * d); q += mu[d] * m; s += mu[d] * d * d * m * (m + 1) // 2
    return q, s
q, s = QS(x); q1, s1 = QS(x - 1)
assert q == 65200913918 and q1 == q - 1 and s - s1 == x       # x is squarefree and is the k-th one
assert s == 3496438273878606471921 == 59130688089 ** 2
assert x == 3 * 5 * 7150080319
assert QS(10**10)[0] == 6079270942                               # known value of Q(10^10)
print(f"Q({x}) = {q}, S = {s} = 59130688089^2; x is squarefree; Q(10^10) = 6079270942")
print("ALL OK")
