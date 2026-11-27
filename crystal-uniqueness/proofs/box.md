# The box: no two chains k' < k ≤ 1000 share a crystal (proofs and specification)

Notation. Chain k: x_0 = 1, x_1 = k, x_{t+1} = (k−2)x_t − x_{t−1} + 2; crystal at position t ≥ 1 is
n_t(k) = (2x_t − 1)(2x_{t+1} − 1). For k ≥ 5, ε_k = ((k−2) + √(k²−4k))/2 > 1, a unit of norm 1, ε_k + 1/ε_k = k − 2.
Known (checked in Lean, `VibesCodeMath/CrystalUniqueness/Classification.lean`): n_t(k) strictly increasing in t (k ≥ 4) and in k (fixed t); so a collision
n_i(k) = n_j(k') with k > k' has i < j.

## Lemma 1 (approximation, explicit error). [proved; also checked numerically, `../scripts/thmD_checks.py`]
Let E = ε_k (k ≥ 5, so E ≥ (3+√5)/2 > 2.618), M_t = 4E^{2t+1}(1 − 1/E)^{−4}, δ_t = (1 + 1/E)³/(2E^t). For t ≥ 1:
    M_t (1 − δ_t) < n_t(k) < M_t.
Proof. x_t = E^{−t}((E^{t+1} − 1)/(E − 1))² (both sides satisfy the recurrence; equal at t = 0, 1). With
g = (1−1/E)^{−2}: x_t = gE^t(1 − E^{−(t+1)})² ≤ gE^t. Upper: n_t < 4x_t x_{t+1} ≤ M_t. Lower:
n_t > 4x_t x_{t+1} − 2(x_t + x_{t+1}); 4x_t x_{t+1} = M_t(1−p)²(1−q)² ≥ M_t(1 − 2p − 2q) with p = E^{−(t+1)}, q = E^{−(t+2)};
2(x_t + x_{t+1}) ≤ 2g(E^t + E^{t+1}) = M_t(1+u)(1−u)²/(2E^t), u = 1/E. Total loss M_t E^{−t}(1+u)[2u + (1−u)²/2] = M_t δ_t. □
Note δ_t ≤ δ_1 ≤ 0.504 always, and δ_t ≤ 0.01 once E^t ≥ 140.

## Lemma 2 (the linear form). Let k > k' ≥ 5 with k(k−4), k'(k'−4) of different squarefree parts, ε = ε_k,
ε' = ε_{k'}, γ = ((1 − 1/ε')/(1 − 1/ε))^4, and
    Λ = (2i+1) log ε − (2j+1) log ε' + log γ  ( = log M_i(ε) − log M_j(ε') ).
If n_i(k) = n_j(k') then (a) Λ ≠ 0, (b) −log(1 − δ_j(ε')) < Λ < −log(1 − δ_i(ε)), (c) for j ≥ j* (below):
    |Λ| < C0 · ε'^{−j},  C0 = 2·max( (1+1/ε')³/2 , (1+1/ε)³ √ε / (2·0.7·(1−1/ε)² √ε') ).
Proof. (b) from Lemma 1 applied to both sides. (a) The fields Q(√(k²−4k)) ≠ Q(√(k'²−4k')), so some automorphism σ of
L = Q(ε, ε') sends ε ↦ 1/ε and fixes ε'. Λ = 0 means ε^{2i+1}γ = ε'^{2j+1}·1 exactly, i.e.
ε^{2i+1}(1−1/ε)^{−4} = ε'^{2j+1}(1−1/ε')^{−4}; applying σ the left side becomes ε^{−(2i+1)}(1−ε)^{−4} < 1 while the right
side is unchanged and > 1. (c) n > M_j(1 − δ_j) ≥ 0.49·4ε'^{2j+1} and n < M_i, so ε^{2i+1} > 0.49 ε'^{2j+1}(1−1/ε)^4, giving
ε^{−i} < √ε ε'^{−j−1/2} / (0.7 (1−1/ε)²). Let j* ≥ 5 be the least j for which both δ_j(ε') and the bound (1+1/ε)³/2·√ε ε'^{−j−1/2}/(0.7(1−1/ε)²) for δ_i are
≤ 1/2 (computed per pair, rigorously); for j ≥ j*, −log(1 − δ) ≤ 2δ gives (c). □

## Cited: Matveev's bound, real case. [cited: Bugeaud–Mignotte–Siksek,
Ann. Math. 163 (2006), arXiv math/0403046, §9.1, Theorem 9.4, which restates Matveev 2000]
"Let L be a number field of degree D, let α1,...,αn be non-zero elements of L and b1,...,bn be rational integers.
Set B = max{|b1|,...,|bn|}, and Λ = α1^b1...αn^bn − 1. ... Aj ≥ h′(αj) := max{D h(αj), |log αj|, 0.16}.
Assume that Λ is non-zero. ... if L is real, we have log|Λ| > −1.4·30^{n+3} n^{4.5} D²(1+log D)(1+log B) A1...An."
Use: n = 3, α = (ε, ε', γ), b = (2i+1, −(2j+1), 1), L = Q(√(k²−4k), √(k'²−4k')) real, D = 4, B = 2j+1 (i < j).
The multiplicative form is e^Λ − 1; for |Λ| < 1, |e^Λ − 1| ≤ 2|Λ|. Heights: h(ε) = h(ε') ... h(ε) = (log ε)/2 (unit, monic
quadratic); h(γ) ≤ 4(h(ε) + h(ε') + 2 log 2) using h(xy) ≤ h(x)+h(y), h(x^m) = |m|h(x), h(1/x) = h(x), h(x−1) ≤ h(x)+log 2.
So with CM = 1.4·30^6·3^{4.5}·16·(1+log 4)·A1A2A3:  j log ε' < CM(1 + log(2j+1)) + log(2·C0). This gives J0.

## Cited: reduction lemma. [after Dujella–Pethő 1998, Lemma 5; see also Lemma 11 of arXiv:1712.04345]
Stated one-sided there; we use the absolute-value form, whose proof is one line and needs no convergent property:
for any positive integer q, if x = uθ − v + μ with integers u, v, |u| ≤ M, then q|x| ≥ ||qμ|| − |u|·||qθ|| ≥ ε0 :=
||qμ|| − M||qθ||. So if ε0 > 0 and |x| < A·B^{−w}, then A·B^{−w} > ε0/q, i.e. w < log(Aq/ε0)/log B.
Use: x = Λ/log ε' = (2i+1)θ − (2j+1) + μ, θ = log ε/log ε', μ = log γ/log ε', u = 2i+1 ≤ M = 2J0+1, A = C0/log ε',
B = ε', w = j. Choose q among the continued-fraction denominators of θ with q > 6M (any q is valid if ε0 > 0 is
certified). Result J1 = ⌈log(Aq/ε0)/log ε'⌉: no collision with j ≥ max(J1, j*).

## Exact step. Compute both chains with exact integers up to position max(J1, j*) + 1 on chain k' (and all of chain k
below the resulting bound) and check that no value is shared.

## Rigor requirements. Every real quantity (ε, logs, γ, θ, μ, ||qθ||, ||qμ||, A_i, CM, C0, J0, ε0, J1) is computed with
interval or ball arithmetic and the bound used in the direction that is safe (upper bounds for J0, A, C0, J1; lower bound
for ε0). No bare floating point in any inequality. Integers exact.

## Same field pairs: Theorem D (theorem-D.md in this folder). Same chain: positions differ ⇒ values differ (monotone in t).
## k = 3: only n_1(3) = 35, smaller than every other crystal (n_1(4) = 119, n_1(5) = 279).
## k = 4: values (2s²−1)(2(s+1)²−1) = (2u−1)² − 2 with u = s(s+1); polynomial, so this method does not apply; see [k4-chain.md](k4-chain.md).
