# OEIS A058627 is complete: φ(n) = product of digits has exactly 15 solutions

OEIS [A058627](https://oeis.org/A058627) (Robert G. Wilson v, 2000) lists the numbers n such that φ(n) equals the product of the decimal digits of n:

1, 24, 26, 87, 168, 388, 594, 666, 1998, 2688, 5698, 5978, 6786, 7888, 68796.

The sequence also appears in C. A. Pickover, *Wonders of Numbers* (2000), chapter 72. The entry carries a comment by Giovanni Resta (Apr 22 2014) explaining why the sequence is finite, and ending: "If a(16) exists, it holds 10^13 < a(16) < 10^64."

## The result

**These 15 terms are all: a(16) does not exist.** This closes the window 10¹³ < a(16) < 10⁶⁴.

**Status:** elementary and computer-assisted, **not formally verified** (no Lean for this result).

## Proof

Let n ≥ 1 have k digits, and let P be the product of its digits. Suppose φ(n) = P.

1. **No zero digit, P is 7-smooth.** φ(n) ≥ 1, so no digit is 0, and P = 2^a 3^b 5^c 7^d.
2. **Prime factors.** If p^e ∥ n then p^(e−1)(p − 1) divides φ(n) = P. So p − 1 is 7-smooth, and e = 1 when p > 7. So n = A·B with A 7-smooth and B a squarefree product of primes p > 7 with p − 1 dividing P.
3. **n/φ(n) < 8.2586.** By step 2, n/φ(n) is at most C, the product of p/(p − 1) over all primes p with p − 1 7-smooth. That product converges, and C < 8.2586. The proof is an exact rational product over the 2,317 such primes with p − 1 < 10¹², plus a rigorous tail bound: the remaining factor is at most exp(t) ≤ 1 + 2t, where t = 35/8 − Σ_{s < 10¹², s 7-smooth} 1/s ≈ 2.15·10⁻⁹, computed exactly using Σ over all 7-smooth s of 1/s = 2 · 3/2 · 5/4 · 7/6 = 35/8. Primality is tested by BPSW, which never rejects a true prime, so C can only be overestimated.
4. **At most 41 digits.** 10^(k−1) ≤ n ≤ C·φ(n) = C·P ≤ 8.2586 · 9^k forces k ≤ 41.
5. **At most 36 digits (2-adic refinement).** Let v = v₂(P). Each odd prime factor of n contributes an even factor p − 1 to φ(n), so n has at most v odd prime factors. That bounds n/φ(n) by 2R(v), the product over the v smallest odd primes q with q − 1 7-smooth. Each digit d satisfies d ≤ 9·(8/9)^(v₂(d)/3), so P ≤ 9^k (8/9)^(v/3). The maximum over v of 2R(v)(8/9)^(v/3) is 4.4421 (at v = 7), which gives k ≤ 36.
6. **Exhaustive search.** For each k:
   - list every digit product P of a k-digit number with P ≥ 10^(k−1)/8.2586;
   - for each P, find every n = A·B with φ(n) = P and k digits, by a depth-first search over sets of large primes, solving φ(A) = R exactly at each node;
   - accept n if its digit product is P.
   
   The search finds exactly the 15 known terms.

## Programs ([`scripts/`](scripts/))

| Program | What it does | Range and log |
| --- | --- | --- |
| `cq_exact.py` | the constant C with its rigorous tail bound, and the 41-digit cap | `cq_exact.log` |
| `v2_bound.py` | the 2-adic refinement to 36 digits | `v2_bound.log` |
| `gen_q.py` | all primes p > 7 with p − 1 7-smooth and p − 1 ≤ 9⁴¹ (list `q41.txt`) | |
| `a058627.cpp` | the search of step 6, exact 128-bit integers | k = 1–36: `run_1_22.log`, `run_23_36.log` |
| `second/search.cpp` (needs OpenSSL and OpenMP) | a separately written search: own prime list, 256-bit integers, its own prunes; covers k ≤ 41, so it does not need step 5 | k = 1–41: `second/run41.log` |
| `third/search.cpp`, `third/gen_q.py`, `third/cbound.py` | a third, separately written search, prime list and constant | the saved log `third/search.log` covers k = 13–36 |
| `second/brute.cpp` | direct brute force over n ≤ 10⁷ | |

All of the searches find exactly the 15 known terms. The digit-product candidate counts of `a058627.cpp` and the third search agree for every k. The second program's counts agree too, except at k = 14 (902 vs 901). It used the constant 8.26 instead of 8.2586, which admits one extra, unneeded candidate.

```bash
python3 oeis-a058627/scripts/cq_exact.py
g++ -O2 -o a058627 oeis-a058627/scripts/a058627.cpp && ./a058627 1 22 oeis-a058627/scripts/q41.txt   # compare with run_1_22.log
```

## Credits

The sequence is Robert G. Wilson v's. The bound window for a(16) is Giovanni Resta's (2014). We found no earlier completeness proof and no search beyond 10¹³ (OEIS entry, GitHub, the web, Nov 27 2026). The method is elementary and the result is small.
