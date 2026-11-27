# tan(arctan 1 + arctan 2 + ⋯ + arctan n) is not an integer for 5 ≤ n ≤ 1.2·10⁸

**Status of the conjecture: open.** The conjecture (Amdeberhan, Medina and Moll, 2008) says the value is never an integer for n ≥ 5. Nothing here proves that. This folder contains a finite verification, checked exactly.

## The result

For every n with 5 ≤ n ≤ 120,000,000, x_n = tan(arctan 1 + ⋯ + arctan n) is not an integer. For n = 1, 2, 3, 4 it is (1, −3, 0, 4), and the check finds exactly those.

This range includes all 22 members of Ono's exceptional set E up to 1.2·10⁸, among them the twelve indices of his Remark 3.3. Those twelve are also checked separately by the Lean kernel.

Novelty is modest. It is a verification range. The largest earlier scan we found (Moll, 2013) went to n = 50,000, and it was numerical, not exact.

## Method

Write P_n = ∏ₖ₌₁ⁿ (1 + k i) = A_n + B_n i, so x_n = B_n / A_n. Let g_n = gcd(A_n, B_n) and Q_n = P_n / g_n. Then x_n is an integer exactly when Re(Q_n) = ±1.

- `check/tancheck.c` computes g_n exactly from a sieve factorisation of the numbers 1 + k². It then computes Re(Q_n) modulo two primes q ≡ 3 (mod 4), namely 2⁶¹ − 1 and 4611686018427387847, which cannot divide g_n. If Re(Q_n) ≢ ±1 modulo either prime, x_n is certainly not an integer. So each n gets a proof, not just a failed search.
- Cross-checks: `check/exact_small.py` uses exact big-integer gcds for every n ≤ 3000 (output `check/exact_small_3000.txt`). `check/spot_exact.py` uses exact product trees at spot values up to 1,020,218 (output `check/spot_exact_E.out`). Both agree with the fast checker everywhere.
- `check/exceptional.c` locates the set E numerically (`check/E_upto_*.txt`). It only says where to look. It proves nothing.
- `lean/gen.py` writes `TanArctan12.lean`, a plain Lean 4 file with no Mathlib. It proves ¬(A n ∣ B n) for the twelve Remark 3.3 indices by kernel-checked checkpoints, and proves A n ∣ B n for n = 1…4 as controls. `#print axioms` reports only `propext`. The file defines the Gaussian product by recursion. It has not been proved equal to the formal-conjectures definition, which uses a Finset product.

## Rerun

```bash
cc -O2 -o tancheck check/tancheck.c -lm
./tancheck 1000000        # about 2 s; compare with check/run_1e6.log (same hash line)
./tancheck 120000000      # a few minutes; compare with check/run_1.2e8.log
python3 check/exact_small.py           # needs Python 3 only
cd lean && python3 gen.py && lean TanArctan12.lean   # Lean 4 v4.33.1, about 5 minutes
```
