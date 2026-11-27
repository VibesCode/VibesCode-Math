# No number is a crystal at position 1 of one chain and position 4 of another

Notation as in [`box.md`](box.md): chain k has x_0 = 1, x_1 = k, x_{t+1} = (k−2)x_t − x_{t−1} + 2, and its crystal at position t ≥ 1 is
n_t(k) = (2x_t − 1)(2x_{t+1} − 1). As a function of k, n_t(k) is a polynomial of degree 2t + 1.

**Claim.** There are no integers k, k' ≥ 3 with n_1(k) = n_4(k').

**Idea.** The degrees are 3 and 9, and 3 divides 9. So along a solution k must be close to a cubic polynomial in k', and integrality
pins it down exactly. For position pairs (i, j) with 2i+1 dividing 2j+1 the same squeeze works pair by pair. For other position pairs it does not.

**Proof.** n_1(k) = (2k − 1)(2(k − 1)² − 1). Put
    H(x) = x³ − (14/3)x² + (47/9)x + 19/162,
so 162·H(x) has integer coefficients (162, −756, 846, 19). This H is the polynomial part of the branch at infinity of n_1(k) = n_4(x).

1. *Squeeze.* The polynomials n_1(H(x) + 1/162) − n_4(x) and n_4(x) − n_1(H(x) − 1/162) both have degree 6 and leading coefficient 2/27,
   and their largest real roots are below 26 (25.95). So for every integer k' ≥ 26:
   n_1(H(k') − 1/162) < n_4(k') < n_1(H(k') + 1/162).
2. *Monotonicity.* n_1 is increasing for real k ≥ 2 (its critical points are 0.39 and 1.27).
3. *Integrality.* So if n_1(k) = n_4(k') with k' ≥ 26, then H(k') − 1/162 < k < H(k') + 1/162, i.e. 162k − 162H(k') is an integer in (−1, 1),
   so k = H(k') exactly. Then k' is an integer root of 162⁹·(n_1(H(x)) − n_4(x)), a nonzero polynomial with integer coefficients
   (n_1(H(x)) − n_4(x) = −(957906x⁵ − 7396434x⁴ + 18971253x³ − 17985240x² + 5343273x − 304304)/531441). It has no integer root.
4. *Small k'.* For 3 ≤ k' < 26, no n_4(k') is a value n_1(k) (exact check).

So no collision exists. □

**Checks.** `../scripts/polyregime.py` (log `polyregime.log`) derives H and the squeeze and runs the exact check below 26.
`../scripts/positions_1_4_check.py` is a second, separately written SymPy check: same H, same squeeze polynomials and roots, no integer root,
and a brute-force search for 4 ≤ k' ≤ 200,000 that finds no n_4(k') among the position-1 values.

**Scope.** This closes one position pair for all chains at once. It is effective, unlike the Bilu–Tichy finiteness argument for general position pairs.
It does not touch position pairs with 2i+1 ∤ 2j+1, such as (1, 2) or (2, 3).
