# Crystal uniqueness: partial results

**Status: partial result. The conjecture stays open.**

## The conjecture

M. Abrate, S. Barbero, U. Cerruti and N. Murru, "The biharmonic mean" ([arXiv:1601.03081](https://arxiv.org/abs/1601.03081)), call an odd number n = ab with a, b > 1 a *crystal* with components a, b when B(a, b) = ((a + b)² + (ab + 1)²) / (2(a + 1)(b + 1)) is an integer. They conjecture that the components of a crystal are unique: no odd n has two different such factorisations. In DeepMind's [formal-conjectures](https://github.com/google-deepmind/formal-conjectures) (pinned commit `9097e2f`) this is `Arxiv.«1601.03081».crystals_components_unique`, labelled `research open`.

## Chains

Every crystal sits on a *chain*. For an integer k ≥ 3 let x_0 = 1, x_1 = k, x_{t+1} = (k − 2)x_t − x_{t−1} + 2. The crystals are exactly the numbers

  n_t(k) = (2x_t − 1)(2x_{t+1} − 1),  with components 2x_t − 1 and 2x_{t+1} − 1,

for k = 3, t = 1 (n = 35), and for k ≥ 4, t ≥ 1. This is the paper's classification (its Theorems 4–5), re-proved here in Lean. Given n and one crystal of it, k is determined. So the conjecture says exactly that the map (k, t) ↦ n_t(k) is injective: **no number is a crystal at two different addresses (k, t).**

## What is proved here

1. **The box.** No number is a crystal on two different chains k, k' with 3 ≤ k, k' ≤ 1000, at any positions. No crystal repeats within one chain either (n_t(k) is strictly increasing in t). So no number is a crystal at two different addresses (k, t), (k', t') with k, k' ≤ 1000.
2. **Theorem D (same quadratic field).** Two chains k ≠ k' ≥ 5 whose units ε_k = ((k − 2) + √(k² − 4k))/2 lie in the same real quadratic field (equivalently, k(k − 4) and k'(k' − 4) have the same squarefree part) never share a crystal, at any positions, with no bound on k. Examples: the chains 5, 9, 20, 49, … (field Q(√5)); 6, 16, 54, … (Q(√3)).
3. **Positions 1 and 4.** No number is a crystal at position 1 of one chain and at position 4 of another, for any k, k'.
4. **Lean-checked reduction.** The classification by chains, the Pell form, "k determines the crystal", both monotonicity facts, and the equivalence of the conjecture with injectivity of (k, t) ↦ n_t(k).

## What is not proved

- **A crystal on a chain k ≤ 1000 could still have a second address on a chain k' > 1000.** The box does not exclude that. (An exhaustive search found no repeated crystal up to 10³⁷, but that is not a proof.)
- **The conjecture itself stays open.** For two chains in different fields with both positions free, no known method decides the question. It has the same shape as Goormaghtigh's equation, which is open too.

## How each part is proved, and what checks it

| Part | Method | Checked by |
| --- | --- | --- |
| Reduction (4) | elementary | **Lean 4 + Mathlib**, kernel-checked: [`VibesCodeMath/CrystalUniqueness/Classification.lean`](../VibesCodeMath/CrystalUniqueness/Classification.lean). The statements are ours (the conjecture is written out in `unique_iff_injOn`). Axioms: `propext`, `Classical.choice`, `Quot.sound` only. |
| Box (1), chains k, k' ≥ 5 | explicit approximation lemma, Matveev's lower bound for linear forms in three logarithms (cited), Baker–Davenport reduction, exact integer check | **computer-assisted proof, not Lean-checked.** Rigorous interval and ball arithmetic in independent implementations, which agree pair by pair. |
| Box (1), chain k = 4 against 5 ≤ k ≤ 1000 | the chain-4 crystals are exactly the n with n + 2 = z² and 2z + 3 a perfect square; a collision gives a generalized Pell equation Y² − k w² = −(k − 4)³; its solution classes, then the same linear-forms argument and an exact check | **computer-assisted proof, not Lean-checked.** Pell classes by two independent methods (PARI with certified class groups, and the LMM algorithm), which agree class by class; interval arithmetic in independent implementations. |
| Theorem D (2) | elementary size bracket, five cases | written proof; constants and case inequalities also checked numerically; exact cross-check of 2,386,572 crystals below 10¹⁰⁰⁰ in 2,998 fields. Not Lean-checked. |
| Positions (1, 4) (3) | polynomial squeeze, integrality, finite check | written proof, two separately written SymPy checks. Not Lean-checked. |

### The box in more detail ([`proofs/box.md`](proofs/box.md))

For chains k > k' ≥ 5 a shared crystal n_i(k) = n_j(k') forces i < j (monotonicity in k). Then:

- **Lemma 1 (explicit approximation).** With E = ε_k, M_t = 4E^{2t+1}(1 − 1/E)^{−4} and δ_t = (1 + 1/E)³/(2E^t): M_t(1 − δ_t) < n_t(k) < M_t for t ≥ 1.
- **Lemma 2 (the linear form).** If the fields differ, Λ = (2i+1) log ε_k − (2j+1) log ε_{k'} + log γ, with γ = ((1 − 1/ε_{k'})/(1 − 1/ε_k))⁴, is nonzero and |Λ| < C₀ ε_{k'}^{−j} for j past an explicit j*.
- **Matveev's theorem, as stated in Bugeaud–Mignotte–Siksek** (Ann. of Math. 163 (2006), arXiv:math/0403046, §9.1, Theorem 9.4): for a real number field of degree D, nonzero α₁, …, αₙ, integers b₁, …, bₙ with B = max |bⱼ|, Λ = α₁^{b₁}⋯αₙ^{bₙ} − 1 ≠ 0 and Aⱼ ≥ max{D h(αⱼ), |log αⱼ|, 0.16}: log |Λ| > −1.4·30^{n+3} n^{4.5} D²(1 + log D)(1 + log B) A₁⋯Aₙ. Applied with n = 3, D = 4 (the biquadratic field Q(√(k² − 4k), √(k'² − 4k'))), it bounds j by an explicit J₀ (between about 10¹⁶ and 10¹⁸ in the box).
- **Baker–Davenport reduction** (after Dujella–Pethő), in an absolute-value form with a one-line proof, cuts that bound to J₁ ≤ 59 for every pair in the box.
- **Exact check.** Both chains are computed with exact integers past the reduced bound; no value is shared.
- Same-field pairs (67 in the box) go to Theorem D instead. The chain k = 3 has the single crystal 35, smaller than every other crystal.

Result: all 495,510 pairs 5 ≤ k' < k ≤ 1000: 495,443 certified by the reduction plus exact check, 67 by Theorem D, 0 failures, 0 shared values.

### The chain k = 4 ([`proofs/k4-chain.md`](proofs/k4-chain.md))

The crystals of chain 4 grow polynomially in t, so the method above does not apply to them directly. Instead:

- **Lemma K1.** The chain-4 crystals are exactly the n with n + 2 = z² and 2z + 3 = (2s + 1)², s ≥ 2.
- **Lemma K2.** For chain k ≥ 5, an exact identity 4(k − 4)²(n_i(k) + 2) = k·w_i² − (k − 4)³ holds, with w_i an explicit integer sequence. So a collision with chain 4 gives an integer solution of Y² − k w² = −(k − 4)³.
- **Three cases.** If k is a square, the equation factors and leaves finitely many positions. If k is not a square, every solution is β·η^m for β in a finite, explicitly computed set of class representatives and η the fundamental norm-1 unit; if k − 4 is not a square, Matveev's theorem and a Baker–Davenport reduction bound the position; if k − 4 is a square, the logarithms are dependent and an explicit distance bound does it.
- **Exact check** of the remaining positions (at most 32) on each chain.

Result: 29 square k, 936 + 31 non-square k, 0 collisions.

## Files

- [`proofs/box.md`](proofs/box.md): Lemmas 1 and 2, the cited Matveev statement, the reduction lemma, the exact step and the rigour requirements.
- [`proofs/theorem-D.md`](proofs/theorem-D.md): Theorem D and its proof.
- [`proofs/positions-1-4.md`](proofs/positions-1-4.md): the (1, 4) result.
- [`proofs/k4-chain.md`](proofs/k4-chain.md): the chain k = 4: Lemmas K1 and K2, the Pell classes and the three cases.
- [`scripts/`](scripts/):
  - `box_certify.py` (mpmath interval arithmetic, with a certified bound J₀) and `box_certify_all.py` to run it on every pair; log `box_certify_1000.log.gz`; extreme pairs, including (39853, 577) outside the box, in `box_certify_extremes.log`.
  - `box_flint.py`, a separately written implementation in python-flint ball arithmetic (`python3 box_flint.py --K 1000`); log `box_flint_1000.log.gz`. Its summary line: `pairs=495510 certified_ok=495443 same_field=67 failures=0 max_J1=59`.
  - `thmD_checks.py`, `samefield_exact.py` (Theorem D), with logs.
  - `polyregime.py`, `positions_1_4_check.py` (positions 1 and 4), with log.
  - Chain k = 4: `k4_certify.py` with `lmm.py` (LMM Pell classes, interval arithmetic; log `k4_certify_1000.log`); `k4_iv.py` (a separately written implementation using PARI with certified class groups; log `k4_iv_1000.log`); `k4_canon.py` and `k4_canon_compare.py` (the two class lists agree for all 967 non-square k, 17,145 classes; `k4_canon_1000.log`, `k4_canon_compare.log`).

Every real inequality in the box programs is decided from interval or ball endpoints, and integers are exact. The interval libraries (mpmath, Arb) are standard but not formally verified.

## Related work

An open pull request in umaia1234/agentic-conjectures (#71, opened Oct 2026), described there as partial and not human-reviewed, gives a Lean classification, the k = 3 and equal-k cases, a position-1 case, the chain k = 4 against position 1 conditional on an elliptic-curve computation, and a search to 2¹²⁷. The box, Theorem D and the (1, 4) result are not there. We found no published solution or other partial result (arXiv, OpenAlex, GitHub, Nov 27 2026).

## Credits

The conjecture and the chain classification are due to Abrate, Barbero, Cerruti and Murru. Matveev's theorem is quoted from Bugeaud, Mignotte and Siksek. The reduction follows Baker–Davenport and Dujella–Pethő.
