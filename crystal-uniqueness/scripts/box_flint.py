#!/usr/bin/env python3
"""Certified box check: no two chains k'<k share a crystal (independent implementation of box-spec.md)."""
import sys, argparse
from fractions import Fraction
from flint import arb, ctx

class Straddle(Exception):
    pass

def sqfree_part(n):
    r, p = 1, 2
    while p * p <= n:
        e = 0
        while n % p == 0:
            n //= p; e += 1
        if e & 1: r *= p
        p += 1
    return r * n

def ub(x): return x.upper()
def lb(x): return x.lower()
def ceil_ub(x): return int(x.upper().ceil().unique_fmpz())
def floor_lb(x): return int(x.lower().floor().unique_fmpz())

def eps(k):
    return (arb(k - 2) + arb(k * k - 4 * k).sqrt()) / 2

def certain_le(a, b):  # a <= b certified using endpoints
    return ub(a) <= lb(b)

def delta(E, t):  # ball of delta_t
    return (1 + 1 / E) ** 3 / (2 * E ** t)

def compute_pair(k, kp):
    E, Ep = eps(k), eps(kp)
    LE, LEp = E.log(), Ep.log()
    half = arb(1) / 2
    # j*
    j = 5
    cst = (1 + 1 / E) ** 3 / 2 * E.sqrt() / (arb(7) / 10 * (1 - 1 / E) ** 2)
    while True:
        d1 = delta(Ep, j)
        d2 = cst * (-(LEp * (2 * j + 1) / 2)).exp()
        if ub(d1) <= 0.5 and ub(d2) <= 0.5:
            break
        j += 1
        if j > 10**6: raise Straddle("jstar")
    jstar = j
    # C0
    t1 = (1 + 1 / Ep) ** 3 / 2
    t2 = (1 + 1 / E) ** 3 * E.sqrt() / (2 * (arb(7) / 10) * (1 - 1 / E) ** 2 * Ep.sqrt())
    C0 = 2 * arb(max(ub(t1), ub(t2)))
    C0 = arb(ub(C0))
    # gamma
    gam = ((1 - 1 / Ep) / (1 - 1 / E)) ** 4
    lgam = gam.log()
    # Matveev constants
    A1 = ub(2 * LE)  # max(D h, log, .16), D h = 2 logE
    A2 = ub(2 * LEp)
    hg = 4 * (LE / 2 + LEp / 2 + 2 * arb(2).log())
    A3 = max(ub(4 * hg), ub(abs(lgam)), arb('0.16').upper())
    A3 = arb(A3)
    CM = ub(arb('1.4') * arb(30) ** 6 * arb(3) ** arb('4.5') * 16 * (1 + arb(4).log()) * A1 * A2 * A3)
    CM = arb(CM)
    # NB: 1.4 as arb is a ball around 1.4 -> upper bound taken
    logC2 = ub((2 * C0).log())
    L = lb(LEp)
    def R(x):
        return CM * (1 + arb(2 * x + 1).log()) + logC2
    def ok(x):
        return ub(R(x) / L) < x and (2 * x + 1) > ub(2 * CM / L)
    x = jstar
    while not ok(x):
        x *= 2
        if x > 10**60: raise Straddle("J0 diverge")
    while True:
        c = ceil_ub(R(x) / L) + 1
        if c < x and ok(c):
            x = c
        else:
            break
    J0 = x  # every solution j has j < J0 (and j>=j* handled), collisions with j>=jstar have j<J0
    M = 2 * J0 + 1
    # theta, mu
    theta = LE / LEp
    mu = lgam / LEp
    mid = theta.mid().man_exp()
    fr = Fraction(int(mid[0]) * 2 ** int(mid[1])) if mid[1] >= 0 else Fraction(int(mid[0]), 2 ** (-int(mid[1])))
    # continued fraction denominators
    q_prev, q = 0, 1
    a_frac = fr
    p0, p1, q0, q1 = 0, 1, 1, 0
    # standard recurrence
    hm2, hm1, km2, km1 = 0, 1, 1, 0
    x_ = fr
    A = C0 / LEp
    attempts = 0
    while True:
        a = x_.numerator // x_.denominator
        kk = a * km1 + km2
        km2, km1 = km1, kk
        fracp = x_ - a
        if kk > 6 * M:
            qq = kk
            qm = qq * mu
            n = int(qm.mid().floor().unique_fmpz()) + (1 if qm.mid() - qm.mid().floor() >= half else 0)
            d = abs(qm - n)
            if not (ub(d) < 0.5):
                raise Straddle("qmu")
            nmu_lo = lb(d)
            qt = qq * theta
            n2 = int(qt.mid().floor().unique_fmpz()) + (1 if qt.mid() - qt.mid().floor() >= half else 0)
            nth_up = ub(abs(qt - n2))
            eps0 = lb(nmu_lo - M * nth_up)
            if eps0 > 0:
                J1 = ceil_ub((A * qq / eps0).log() / LEp)
                if (A * qq / eps0).log() / LEp > 0 or True:
                    return dict(J0=J0, q=qq, J1=J1, jstar=jstar, ok=True)
            attempts += 1
            if attempts > 400:
                raise Straddle("no q")
        if fracp == 0:
            raise Straddle("cf ended")
        x_ = 1 / fracp

def exact_check(k, kp, P):
    # chain kp positions 1..P
    def chain_vals(kk, limit_pos=None, limit_val=None):
        vals = []
        xs = [1, kk]
        t = 1
        while True:
            if t + 1 >= len(xs):
                xs.append((kk - 2) * xs[-1] - xs[-2] + 2)
            n = (2 * xs[t] - 1) * (2 * xs[t + 1] - 1)
            if limit_pos is not None and t > limit_pos: break
            if limit_val is not None and n > limit_val: break
            vals.append(n); t += 1
        return vals
    vp = chain_vals(kp, limit_pos=P)
    vk = chain_vals(k, limit_val=vp[-1])
    return len(set(vp) & set(vk))

def run_pair(k, kp, prec0=600):
    if sqfree_part(k * (k - 4)) == sqfree_part(kp * (kp - 4)):
        return f"{k} {kp} same_field - - - - -", None
    prec = prec0
    while True:
        ctx.prec = prec
        try:
            r = compute_pair(k, kp)
            break
        except Straddle as e:
            prec *= 2
            if prec > 20000:
                return f"{k} {kp} FAIL_STRADDLE({e}) - - - - -", None
    jmax = max(r['J1'], r['jstar']) + 1
    c = exact_check(k, kp, jmax)
    st = "OK" if c == 0 else "COLLISION"
    return f"{k} {kp} {st} {r['J0']} {r['q']} {r['J1']} {jmax} {c}", r

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--K", type=int, default=60)
    ap.add_argument("--pairs", type=str, default=None, help="k,k' ; k,k' ; ...")
    a = ap.parse_args()
    if a.pairs:
        pairs = [tuple(int(v) for v in s.split(",")) for s in a.pairs.split(";")]
    else:
        pairs = [(k, kp) for k in range(6, a.K + 1) for kp in range(5, k)]
    n = ok = same = bad = 0; maxJ1 = 0; maxJ0 = 0
    for k, kp in pairs:
        line, r = run_pair(k, kp)
        print(line, flush=True)
        n += 1
        if "same_field" in line: same += 1
        elif " OK " in line:
            ok += 1; maxJ1 = max(maxJ1, r['J1']); maxJ0 = max(maxJ0, r['J0'])
        else: bad += 1
    print(f"SUMMARY pairs={n} certified_ok={ok} same_field={same} failures={bad} max_J1={maxJ1} max_J0={maxJ0}")

main()
