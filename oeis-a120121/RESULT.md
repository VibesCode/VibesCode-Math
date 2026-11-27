# OEIS A120121, A120122, A120123 are complete: 139968 is the largest term

For a positive integer m, let P and S be the product and the sum of its decimal digits, and let φ be Euler's totient (φ(0) = 0). The three sequences of Farideh Firoozbakht (OEIS, Aug 2006) are:

- **A120121**: m = φ(P·S)
- **A120122**: m = φ(P)·S
- **A120123**: m = P·φ(S)

Each entry says: "Conjecture: 139968 is the largest term."

## The result

**The three sequences are complete:**

| Sequence | Terms |
| --- | --- |
| A120121 | 1, 2, 64, 384, 139968 |
| A120122 | 1, 2, 24, 139968 |
| A120123 | 1, 2, 672, 34992, 139968 |

This proves the conjecture in all three entries that 139968 is the largest term. (139968 = 2⁶·3⁷ has digits 1, 3, 9, 9, 6, 8, with P = 11664 and S = 36.)

## Proof

1. **No zero digit.** If a digit is 0 then P = 0, and each right-hand side is 0, so m ≥ 1 is not a term.
2. **At most 84 digits.** φ(x) ≤ x, so in all three cases m ≤ P·S ≤ 9^k · 9k for a k-digit m. Since m ≥ 10^(k−1), and 9^(k+1)·k < 10^(k−1) for every k ≥ 85, a term has at most 84 digits. This is the bound H. Bottomley gave for A049101 in 2000.
3. **Exhaustive search.** P and S depend only on the multiset of digits. So it is enough to run over digit multisets (counts c₁, …, c₉ of the digits 1–9) of size k ≤ 84. For each one, compute M = F(P, S) exactly and check whether M's digits form that multiset. Branches with P_max·S_max < 10^(k−1) are pruned, where P_max and S_max fill the undecided positions with 9s. That bound only falls as smaller digits replace 9s, so the prune never skips a term.

## What rests on what

- **Steps 1 and 2: checked in Lean 4 + Mathlib.** [`VibesCodeMath/OeisA120121/Challenge.lean`](../VibesCodeMath/OeisA120121/Challenge.lean) states `digit_phi_terms_bound`: if m > 0 satisfies any of the three equations (with `Nat.digits 10 m`), then no digit of m is 0 and m < 10⁸⁴. `Solution.lean` proves it, and `Verify.lean` restates it and prints `[propext, Classical.choice, Quot.sound]`.
- **Step 3: exact computation.** Separately written programs (in [`scripts/`](scripts/)) all return exactly the three lists above:

| Program | Method | Log |
| --- | --- | --- |
| `enum_exact.py` | digit counts chosen 1 → 8 (rest 9s), exact integer prune | `enum_exact.log` (581,669 complete multisets) |
| `enum_exact_2.py` | digit counts chosen 9 → 1, exact integer prune, sympy totient | `enum_exact_2.log` (581,669) |
| `enum_logprune.py` | "9s plus a few smaller digits", logarithmic prune with slack, tests m = F(P(m), S(m)) directly | `enum_logprune.log` (683,504) |
| `enum_family.py` | a further separate search | `enum_family.log` |
| `brute_small.c` | direct brute force over every m ≤ 10⁸, no reduction, as a check of the definitions | `brute_1e8.log` |

`bound_check.log` records the exact comparison 9⁸⁶·85 < 10⁸⁴ (and that 9⁸⁵·84 < 10⁸³ fails, so 84 is the cut-off of this argument).

```bash
python3 oeis-a120121/scripts/enum_exact.py     # about 7 s
cc -O2 -o brute oeis-a120121/scripts/brute_small.c && ./brute 100000000
```

## Credits and status

The sequences and the conjecture are Farideh Firoozbakht's. The 84-digit bound is H. Bottomley's (A049101, May 18 2000), and the multiset enumeration is the standard method used for that sequence, which Giovanni Resta declared complete (2013). For the joint question, a number with all three properties at once, F. Schneider gave an informal argument on Prime Puzzles 507. That covers only the joint condition, not each sequence. We found no proof of completeness for any of the three sequences (OEIS entries, GitHub, the web, arXiv, Nov 27 2026). The method is standard and the result is small.
