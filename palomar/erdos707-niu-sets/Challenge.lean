/-
The definition `IsPerfectDifferenceSet` below is copied verbatim from
google-deepmind/formal-conjectures, FormalConjecturesForMathlib/Data/ZMod/PerfectDifferenceSet.lean
at commit 9097e2f90e66d2f6244209cb1c07f7120d17ec53.
Copyright 2025 The Formal Conjectures Authors. Licensed under the Apache License, Version 2.0.
-/
module

public import Mathlib

/-!
# Challenge: Niu's candidate counterexamples to Erdős Problem 707 in cyclic planes of order divisible by 2 or 3

Erdős Problem 707 asks whether every finite Sidon set extends to a perfect difference set. Niu
(arXiv:2604.25214) proposed {0,1,3,11} and {0,1,4,11} as size-4 counterexamples. A perfect difference
set B modulo n with |B| = q + 1 has order q. The two theorems below show:
* neither set is contained in a perfect difference set of even order (|B| odd);
* {0,1,3,11} is contained in no finite perfect difference set whose order |B| - 1 is divisible by 2 or 3.
The modulus n is arbitrary; no prime-power assumption on the order is made.
-/

@[expose] public section

/--
A perfect difference set modulo `n` is a set `D` such that the map `(a, b) ↦ a - b` from
`D.offDiag` to `{x : ZMod n | x ≠ 0}` is a bijection.
-/
def IsPerfectDifferenceSet (D : Set ℕ) (n : ℕ) : Prop :=
  D.offDiag.BijOn (fun (a, b) => (a - b : ZMod n)) {x : ZMod n | x ≠ 0}

/-- Niu's two candidate size-4 counterexamples to Erdős 707 (arXiv 2604.25214), {0,1,3,11} and
{0,1,4,11}, lie in no perfect difference set of even order: if B ⊆ ℕ is a perfect difference set
modulo n (any n, formal-conjectures' definition, pinned commit 9097e2f) and B has an odd number
of elements (so its order |B| - 1 is even), then B contains neither set. -/
theorem niu_sets_not_in_even_order_pds :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → Odd B.ncard →
      ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B ∧ ¬ ({0, 1, 4, 11} : Set ℕ) ⊆ B := by
  sorry

/-- Niu's candidate size-4 counterexample {0,1,3,11} to Erdős 707 (arXiv 2604.25214) lies in no
finite perfect difference set whose order |B| - 1 is divisible by 2 or by 3, for any modulus n
(formal-conjectures' definition, pinned commit 9097e2f). -/
theorem niu_set_not_in_pds_of_order_div_two_or_three :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → B.Finite →
      (2 ∣ B.ncard - 1 ∨ 3 ∣ B.ncard - 1) → ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B := by
  sorry
