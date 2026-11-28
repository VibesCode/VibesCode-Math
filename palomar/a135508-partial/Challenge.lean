/-
The definitions `OeisA135508.x` and `OeisA135508.a` below are copied verbatim from
google-deepmind/formal-conjectures, FormalConjectures/OEIS/135508.lean
at commit 9097e2f90e66d2f6244209cb1c07f7120d17ec53.
Copyright 2025 The Formal Conjectures Authors. Licensed under the Apache License, Version 2.0.
-/
module

public import Mathlib

/-!
# Challenge: McEachen's conjecture on OEIS A135508, two partial results

x(1) = 1 and x(n) = 2·x(n−1) + lcm(x(n−1), n); a(n) = x(n+1)/x(n) − 2 (OEIS A135508).
McEachen conjectured (2025) that a(p − 1) = p for every prime p such that p − 2 is not prime.
The theorems below prove it for every prime p < 160000, and for every prime p for which the
smallest prime factor of p − 2 is below 400 (an infinite family). The full conjecture is open.
-/

@[expose] public section

namespace OeisA135508

/-- Auxiliary sequence $x(n)$ with $x(1)=1$ and $x(n) = 2 x(n-1) + \operatorname{lcm}(x(n-1),n)$. -/
def x : ℕ → ℕ
  | 0 => 0
  | 1 => 1
  | n + 1 => 2 * x n + Nat.lcm (x n) (n + 1)

/-- $a(n) = x(n+1)/x(n) - 2$ for $n \ge 1$, and $a(0) = 0$. -/
def a (n : ℕ) : ℕ :=
  if n = 0 then 0 else (x (n + 1) / x n) - 2

end OeisA135508

/-- McEachen's A135508 conjecture for all primes below 160000: if p < 160000 is prime and
p - 2 is not prime, then a(p - 1) = p. Definitions `OeisA135508.x` and `OeisA135508.a` are
formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_lt_160000 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → p < 160000 → OeisA135508.a (p - 1) = p := by
  sorry

/-- McEachen's A135508 conjecture for every prime p whose p - 2 has smallest prime factor
(Mathlib's `Nat.minFac`) below 400: then a(p - 1) = p. An infinite family. Definitions
`OeisA135508.x` and `OeisA135508.a` are formal-conjectures' (pinned commit 9097e2f), unchanged. -/
theorem a135508_conjecture_minFac_lt_400 :
    ∀ p : ℕ, p.Prime → ¬ (p - 2).Prime → (p - 2).minFac < 400 → OeisA135508.a (p - 1) = p := by
  sorry
