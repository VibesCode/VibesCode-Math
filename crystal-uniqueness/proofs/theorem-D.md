# Theorem D: chains in the same quadratic field never share an n

Status: **proved by hand** (written proof below); every constant and case inequality also checked numerically
(`../scripts/thmD_checks.py`), and an exact cross-check (`../scripts/samefield_exact.py`). Not checked in Lean. It is a partial
theorem; the conjecture stays **open**.

Notation: chain k has x_0 = 1, x_1 = k, x_{t+1} = (k-2)x_t - x_{t-1} + 2, and its
crystal at position t ≥ 1 is n_t(k) = (2x_t - 1)(2x_{t+1} - 1). For k ≥ 5 put ε_k = ((k-2) + √(k(k-4)))/2 > 1,
the norm-1 unit with trace k - 2.

## Statement

**Theorem D.** Let k ≠ k' be integers ≥ 5 such that k(k-4) and k'(k'-4) have the same squarefree part
(equivalently, ε_k and ε_{k'} lie in the same real quadratic field). Then n_i(k) ≠ n_j(k') for all i, j ≥ 1.

Equivalent integer form (no field theory): for every integer T ≥ 3 let L_0 = 2, L_1 = T, L_{r+1} = T L_r - L_{r-1}
and k_r = L_r + 2. Then the values n_t(k_r), r ≥ 1, t ≥ 1, are pairwise distinct.

Why the two forms agree [cited: Dirichlet's unit theorem, standard]: the units of the real quadratic field K have
rank 1, so the norm-1 units > 1 of O_K are the powers η^r of one of them, η = (T + U√D)/2 with integer trace T ≥ 3,
and ε_k = η^r exactly when k - 2 = trace(η^r) = L_r(T). [computed: for k ≤ 100,000 the 294 fields holding two or
more chains are exactly the sets {L_r(T)+2}, `../scripts/samefield_exact.log`.]

Examples: k = 5, 9, 20, 49, ... (Q(√5), T = 3); k = 6, 16, 54, ... (Q(√3), T = 4); k = 7, 25, 112, ... (T = 5).

## Proof

**Step 1 (closed form).** [computed, exact for T < 60, r ≤ 7, t ≤ 11] For k = E + 2 + 1/E with E > 1,
x_t = E^{-t}((E^{t+1} - 1)/(E - 1))². (Both sides satisfy the chain recurrence with the same x_0, x_1.)
Put g = (1 - 1/E)^{-2}, so x_t = g E^t (1 - E^{-(t+1)})² ≤ g E^t.

**Step 2 (bracket).** Let F_t(E) = (2x_t - 1)(2x_{t+1} - 1), M_t(E) = 4E^{2t+1}(1 - 1/E)^{-4} and
δ_t(E) = (1 + 1/E)³ / (2E^t). For E ≥ (3+√5)/2 and t ≥ 1:  M_t (1 - δ_t) < F_t < M_t.
Proof. F_t < 4x_t x_{t+1} ≤ M_t. Below: F_t > 4x_t x_{t+1} - 2(x_t + x_{t+1}); with p = E^{-(t+1)}, q = E^{-(t+2)} ≤ 1/2,
4x_t x_{t+1} = M_t(1-p)²(1-q)² ≥ M_t(1 - 2p - 2q), and 2(x_t + x_{t+1}) ≤ 2g(E^t + E^{t+1}) = M_t (1+u)(1-u)²/(2E^t),
u = 1/E. Adding, the loss is M_t E^{-t}(1+u)[2u + (1-u)²/2] = M_t E^{-t}(1+u)³/2 = M_t δ_t. □
[computed: holds strictly in all 4,000+ tested cases; the ratio (M-F)/(Mδ) approaches 1 as t grows (minimum 0.859 in an independent set of test cases), so the bound is nearly sharp.]
δ_t decreases in t and in E.

**Step 3 (one unit).** In the setting of the theorem, ε_k = η^r, ε_{k'} = η^s with η ≥ (3+√5)/2 (T ≥ 3) and r ≠ s;
take r < s. A collision n_i(k) = n_j(k') means F_i(η^r) = F_j(η^s), so by Step 2
  1 - δ_j(η^s)  <  Q := M_i(η^r)/M_j(η^s)  <  1/(1 - δ_i(η^r)),
where, with A = r(2i+1), B = s(2j+1),  Q = η^{A-B} ((1 - η^{-s})/(1 - η^{-r}))^4, and the bracket factor lies in (1, (1-η^{-r})^{-4}).
Note B ≥ 6 (s ≥ 2, 2j+1 ≥ 3).

**Step 4 (cases).** Each case contradicts the display.
- A > B: Q > η, but 1/(1 - δ_i(η^r)) ≤ 1/(1 - δ_1(η)) ≤ 2.02 < 2.618 ≤ η.
- A = B: then 2i+1 = B/r > 2j+1, so i ≥ 2. With x = η^{-r} ≤ 1/η: Q ≥ ((1 - x/η)/(1 - x))^4 ≥ 1 + 4x(1 - 1/η) ≥ 1 + 2.47x,
  while 1/(1 - δ_i) ≤ 1/(1 - x²(1+x)³/2) ≤ 1 + 1.64x² < 1 + 2.47x (x ≤ 0.382).
- A < B, r ≥ 2 (so s ≥ 3): Q < (1 - η^{-2})^{-4}/η ≤ 0.72, but 1 - δ_j(η^s) ≥ 1 - δ_1(η³) ≥ 0.96.
- A ≤ B - 2, r = 1: Q ≤ η²/(η-1)^4 · (1 - y)^4 with y = η^{-s} ≤ η^{-2}; η²/(η-1)^4 ≤ 1 exactly when η ≥ (3+√5)/2. So
  Q ≤ (1-y)^4 ≤ 1 - 4y + 6y², and 1 - δ_j(η^s) ≥ 1 - y(1+y)³/2; since 4 - 6y > (1+y)³/2 for y ≤ 0.146, Q < 1 - δ_j.
- A = B - 1, r = 1: then 2i+1 = B - 1 ≥ 5, i ≥ 2.
  T = 3 (η = (3+√5)/2, where (1 - 1/η)^{-4} = η²): Q = η(1 - η^{-s})^4 ≥ η(1 - η^{-2})^4 = 1.393 > 1.239 ≥ 1/(1 - δ_2(η)).
  T ≥ 4: Q < η³/(η-1)^4 ≤ 0.934 (decreasing in η), while 1 - δ_j(η^s) ≥ 1 - δ_1(η²) ≥ 0.955 (increasing).
Every case is impossible, so no collision. □
[computed: every numerical constant above, and each case inequality for T = 3..60 on a grid, `../scripts/thmD_checks.log`;
beyond T = 60 each side is monotone in η as stated.]

**Exact cross-check** [computed, `../scripts/samefield_exact.log`]: for T = 3..3000, all crystals with n < 10^1000 on chains
k_r = L_r(T) + 2 (2,386,572 crystals in 2,998 fields): no two share an n.

## Why this is the right family to settle, and why the method stops here
In the same field the whole collision equation is a statement about one real number η, and the size of n_t determines
the pair (r, t): the main term 4E^{2t+1}(1-1/E)^{-4} has a correction factor too small to bridge a factor of η, and
equal exponents leave a first-order mismatch 4η^{-r}(1 - η^{r-s}) that the error δ cannot cover. This is the analogue
of the multiplicatively dependent case of Goormaghtigh's equation. For units in two different fields the same
comparison gives a linear form in logarithms (2i+1)log ε - (2j+1)log ε' - 4log(1-1/ε) + 4log(1-1/ε') of size about
n^{-1/2}; Baker's method then bounds positions for each fixed pair of chains, but nothing uniform, and near misses such as n_2(577) against n_1(39853) (ratio about 4·10⁻⁶ of the spacing) show that sizes alone cannot decide independent pairs.
