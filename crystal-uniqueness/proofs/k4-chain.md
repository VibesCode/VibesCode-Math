# The chain k = 4 against every chain 5 ≤ k ≤ 1000: proofs and specification

Goal: for every k with 5 ≤ k ≤ 1000 and every position i ≥ 1, n_i(k) is not a crystal of chain 4.
(k = 3: 35 < 119 = smallest chain-4 crystal.) Together with [box.md](box.md) this gives the full box 3 ≤ k ≤ 1000.

## Lemma K1 (chain 4). [algebra] The chain-4 crystals are v(s) = (2s²−1)(2(s+1)²−1), s ≥ 2, and
v(s) = z² − 2 with z = 2s² + 2s − 1. Conversely, if n + 2 = z² with z > 0 and 2z + 3 = (2s+1)², s ≥ 2, then n = v(s).
So a collision needs N + 1 = z² (N = n + 1) with z ≥ 11.

## Lemma K2 (the conic). [algebra; also checked as an exact identity for 5 ≤ k < 400, 1 ≤ i < 40] Let c_1 = 1, c_3 = k − 3,
c_{s+2} = (k−2)c_s − c_{s−2} (odd s), w_i = 4c_{2i+3} − k, T = (k−4)³, N_i = n_i(k) + 1. Then
    4(k−4)²(N_i + 1) = k·w_i² − T.
(With ρ = (√k + √(k−4))/2, V_s = ρ^s + ρ^{−s}: c_s = V_s/√k, and the identity is (k−4)²(N+1) = (2V_s − k√k/2)² − T/4.)
So N_i + 1 = z² forces Y² − k·w_i² = −T with Y = 2(k−4)z > 0, w_i > 0.

## Case S (k = κ² a square, k = 9, 16, ..., 961). (κw − Y)(κw + Y) = T with both factors positive integers, so
w ≤ (T + 1)/(2κ). Since w_i is increasing in i, only finitely many i; check them exactly.

## Case U (k not a square). α := Y + w√k ∈ Z[√k], α > 0, norm αα' = −T, α' = Y − w√k = −T/α.
Every element of Z[√k] of norm −T equals β·η^m (m ∈ Z) with β in a finite set B_k of representatives and η > 1 the
generator of the norm-1 units of Z[√k] (sign absorbed: take β > 0, since α > 0 and η > 0).
B_k must be complete. Computed in independent ways (see Computation below): PARI bnfisintnorm in the maximal order after bnfcertify, then
multiplying by representatives of O_K^{norm 1}/Z[√k]^{norm 1} and keeping elements of Z[√k]; and the integer equation
Y² − k w² = −T solved by the Lagarias–Matthews–Mollin (LMM) algorithm, classes reduced modulo η.
Size: w√k = 4V_s − k√k with s = 2i+3, so α = 2w√k − T/α = 8ρ^s + 8ρ^{−s} − 2k√k − T/α.
Put Λ = log α − log 8 − s·log ρ = m·log η + log(β/8) − s·log ρ.
- Λ < 0 (hence Λ ≠ 0): α − 8ρ^s = 8ρ^{−s} − 2k√k − T/α < 0 because 8ρ^{−s} < 1 < 2k√k (ρ > 1.6, s ≥ 5).
- For s ≥ s* (computed per k, from rigorous bounds, with α ≥ 4ρ^s ensured: α > w√k ≥ 4ρ^s − k√k and Y > 0 give α ≥ 2w√k − T/(w√k), so it suffices that 4ρ^s > k√k and 2k√k + T/(4ρ^s − k√k) ≤ 4ρ^s): |Λ| ≤ 2·(2k√k + T/(4ρ^s) )/(8ρ^s) ≤ C_k ρ^{−s},
  C_k := (2k√k + T/(4ρ^{s*}))/4, using |log(1 − x)| ≤ 2x for 0 ≤ x ≤ 1/2 (implementations check x ≤ 1/2 at s*).

Subcase U1 (k − 4 not a square). L = Q(√k, √(k−4)) real of degree D = 4 (ρ is a unit, minimal polynomial x⁴ − (k−2)x² + 1;
h(ρ) = (log ρ)/2; h(η) = (log η)/2; h(β/8) ≤ h(β) + log 8 with h(β) = (1/2)(log max(1,|β|) + log max(1,|β'|))).
Matveev (Bugeaud–Mignotte–Siksek 2006, Thm 9.4, real case, n = 3; quoted in box.md) with b = (m, 1, −s), B = max(|m|, s):
  s·log ρ < CM(1 + log B) + log(2·C_k),  and |m| ≤ (s log ρ + |log(β/8)| + 1)/log η, giving S0 (bound for s) and M (for |m|).
Reduction (absolute-value Baker–Davenport, box.md): x = Λ/log ρ = mθ − s + μ, θ = log η/log ρ, μ = log(β/8)/log ρ,
|x| < (C_k/log ρ)·ρ^{−s}, |m| ≤ M: a certified ε0 = ||qμ|| − M||qθ|| > 0 gives s < S1.
Subcase U2 (k − 4 = j² a square; k = 5, 8, 13, 20, ..., 965). Then ρ = (√k + j)/2 ∈ Q(√k) is a unit (norm −1), so
log ρ and log η are rational multiples of log ε0 (ε0 the fundamental unit of Z[√k] or of its unit group generated with ρ):
Λ = L·log ε0 + log(β/8) with L ∈ Z. If β/8 is not ± a power of ε0, δ0 := min_L |L log ε0 + log(β/8)| > 0 and
s < log(C_k/δ0)/log ρ. If β/8 is a power of the generator, the L giving Λ = 0 is excluded by Λ < 0, and δ0 is taken over the other L
(a ball meeting 0 would be decided by an exact test in Q(√k); in the run no ball met 0).
Exact step (all cases): for every i with 2i+3 below the bound (and below s*), compute n_i(k) exactly and test Lemma K1.

Rigor: interval/ball arithmetic for every real inequality; exact integers; PARI with bnfcertify (unconditional class group
and units) or an algorithm that is unconditional by construction.

## Computation and result

Cases: 29 square k (Case S), 936 non-square k with k − 4 non-square (U1), 31 with k − 4 a square (U2). In every case the bound leaves at
most position 32 (s ≤ 66) on chain k, and the exact check finds no chain-4 crystal there. **So for every 5 ≤ k ≤ 1000 and every i ≥ 1,
n_i(k) is not a crystal of chain 4.**

Programs (in `../scripts/`):
- `k4_certify.py` with `lmm.py`: Pell classes by the LMM algorithm (unconditional by construction, no class-group or GRH assumption),
  mpmath interval arithmetic at 120 digits, own s*, Matveev bound with a certified bisection, Baker–Davenport reduction, exact check of
  positions ≤ 60 on every chain. Log `k4_certify_1000.log`: 29 S, 936 U1, 31 U2, 0 failures, 0 hits.
- `k4_iv.py`, a separately written implementation: PARI `bnfinit` + `bnfcertify` (class group and units unconditional) and `bnfisintnorm`
  for the classes, mpmath intervals at 300 digits. Log `k4_iv_1000.log`, same case split, 0 hits. `k4_canon.py` prints its canonical class
  representatives (`k4_canon_1000.log`).
- `k4_canon_compare.py`: the LMM classes and the PARI classes agree for all 967 non-square k (17,145 classes, 0 differences,
  `k4_canon_compare.log`).

Not Lean-checked. Matveev's theorem is cited; PARI, mpmath and the LMM code are not formally verified.
