# Exhaustive search over digit multisets, exact integers only (no floats).
# Exact integers only (no floats). For k = 1..84 digits (k >= 85 is impossible, see ../RESULT.md), recursively choose the
# counts of digits 1..8 in ascending order; the rest are 9s. Prune with the exact test P_max * S_max >= 10^(k-1), where
# P_max, S_max fill every undecided position with 9. Each surviving full multiset gives m = F(P,S) for each sequence,
# accepted iff the sorted digits of m equal the multiset.
import sys, time
def totient(n):
    if n == 0: return 0
    r, p, x = n, 2, n
    while p * p <= x:
        if x % p == 0:
            while x % p == 0: x //= p
            r -= r // p
        p += 1
    if x > 1: r -= r // x
    return r
def phi_smooth(e2, e3, e5, e7):          # totient of 2^e2 3^e3 5^e5 7^e7
    r = 1
    for p, e in ((2, e2), (3, e3), (5, e5), (7, e7)):
        if e: r *= (p - 1) * p ** (e - 1)
    return r
EXP = {1: (0,0,0,0), 2: (1,0,0,0), 3: (0,1,0,0), 4: (2,0,0,0), 5: (0,0,1,0), 6: (1,1,0,0), 7: (0,0,0,1), 8: (3,0,0,0), 9: (0,2,0,0)}
def totient_PS(e, S):                    # totient of P*S with P = 2^e2 3^e3 5^e5 7^e7, any S >= 1
    e2, e3, e5, e7 = e; s = S; extra = {}
    for p in (2, 3, 5, 7):
        while s % p == 0: s //= p; extra[p] = extra.get(p, 0) + 1
    base = phi_smooth(e2 + extra.get(2,0), e3 + extra.get(3,0), e5 + extra.get(5,0), e7 + extra.get(7,0))
    return base * totient(s)             # s coprime to 210
hits = {'A120121': set(), 'A120122': set(), 'A120123': set()}
examined = 0
t0 = time.time()
for k in range(1, 85):
    low = 10 ** (k - 1)
    def go(d, left, counts, P, S, e):
        global examined
        if d == 9:
            P9 = P * 9 ** left; S9 = S + 9 * left
            if P9 * S9 < low: return
            examined += 1
            ee = (e[0], e[1] + 2 * left, e[2], e[3])
            cnt = counts + [left]
            key = ''.join(str(i + 1) * c for i, c in enumerate(cnt))
            cand = {'A120121': totient_PS(ee, S9), 'A120122': phi_smooth(*ee) * S9, 'A120123': P9 * totient(S9)}
            for name, m in cand.items():
                if ''.join(sorted(str(m))) == key: hits[name].add(m)
            return
        for c in range(left + 1):
            Pn = P * d ** c; Sn = S + d * c
            if Pn * 9 ** (left - c) * (Sn + 9 * (left - c)) < low:
                break                       # larger c only lowers both bounds (d < 9)
            en = tuple(e[i] + EXP[d][i] * c for i in range(4))
            go(d + 1, left - c, counts + [c], Pn, Sn, en)
    go(1, k, [], 1, 0, (0, 0, 0, 0))
for name in hits: print(name, sorted(hits[name]))
print("multisets examined:", examined, "time %.1fs" % (time.time() - t0))
