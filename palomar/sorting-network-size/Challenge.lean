module

public import Mathlib

@[expose] public section

/-!
Van Voorhis's recurrence for the size of sorting networks (Van Voorhis 1972; Knuth, TAOCP Vol. 3, §5.3.4).

A comparator on `n` wires is a pair `(a, b)` of wires: it writes the minimum of the two values on wire `a`
and the maximum on wire `b`. A network is a list of comparators applied left to right. A network is
standard when every comparator has `a < b` (the usual drawing, minimum to the upper wire). A network sorts
when its output is in nondecreasing order for every input of natural numbers.

`SizeLowerBound n k` says every standard sorting network on `n` wires has at least `k` comparators,
i.e. `k ≤ s(n)` for the minimum size `s(n)`.

The claim: if `k ≤ s(m)` then `k + ⌈log₂ (m+1)⌉ ≤ s(m+1)`.
-/

namespace SortNet

/-- A comparator `(a, b)`: minimum to wire `a`, maximum to wire `b`. -/
abbrev Comparator (n : ℕ) := Fin n × Fin n

/-- Apply one comparator to a vector of values. -/
def applyC {n : ℕ} (c : Comparator n) (v : Fin n → ℕ) : Fin n → ℕ :=
  fun k => if k = c.1 then min (v c.1) (v c.2) else if k = c.2 then max (v c.1) (v c.2) else v k

/-- Run a network, comparators in list order. -/
def eval {n : ℕ} : List (Comparator n) → (Fin n → ℕ) → (Fin n → ℕ)
  | [], v => v
  | c :: N, v => eval N (applyC c v)

/-- Standard network: every comparator sends the minimum to the lower-indexed wire. -/
def IsStandard {n : ℕ} (N : List (Comparator n)) : Prop := ∀ c ∈ N, c.1 < c.2

/-- The network sorts every input of natural numbers into nondecreasing order. -/
def Sorts {n : ℕ} (N : List (Comparator n)) : Prop := ∀ v : Fin n → ℕ, Monotone (eval N v)

/-- Every standard sorting network on `n` wires has at least `k` comparators. -/
def SizeLowerBound (n k : ℕ) : Prop :=
  ∀ N : List (Comparator n), IsStandard N → Sorts N → k ≤ N.length

end SortNet

/-! Challenge: the statements only. The proofs are in `Solution.lean`. -/

/-- Van Voorhis (1972): if every standard sorting network on `m` wires has at least `k` comparators,
then every standard sorting network on `m + 1` wires has at least `k + ⌈log₂ (m+1)⌉` comparators. -/
theorem van_voorhis_recurrence :
    ∀ m k : ℕ, SortNet.SizeLowerBound m k →
      SortNet.SizeLowerBound (m + 1) (k + Nat.clog 2 (m + 1)) := by
  sorry

/-- From the hypothesis s(11) ≥ 35 (Harder, arXiv:2012.04400), the lower bounds for n = 12, …, 32. -/
theorem SortNet.bounds_from_s11 (h : SortNet.SizeLowerBound 11 35) :
    SortNet.SizeLowerBound 12 39 ∧
    SortNet.SizeLowerBound 13 43 ∧
    SortNet.SizeLowerBound 14 47 ∧
    SortNet.SizeLowerBound 15 51 ∧
    SortNet.SizeLowerBound 16 55 ∧
    SortNet.SizeLowerBound 17 60 ∧
    SortNet.SizeLowerBound 18 65 ∧
    SortNet.SizeLowerBound 19 70 ∧
    SortNet.SizeLowerBound 20 75 ∧
    SortNet.SizeLowerBound 21 80 ∧
    SortNet.SizeLowerBound 22 85 ∧
    SortNet.SizeLowerBound 23 90 ∧
    SortNet.SizeLowerBound 24 95 ∧
    SortNet.SizeLowerBound 25 100 ∧
    SortNet.SizeLowerBound 26 105 ∧
    SortNet.SizeLowerBound 27 110 ∧
    SortNet.SizeLowerBound 28 115 ∧
    SortNet.SizeLowerBound 29 120 ∧
    SortNet.SizeLowerBound 30 125 ∧
    SortNet.SizeLowerBound 31 130 ∧
    SortNet.SizeLowerBound 32 135 := by
  sorry
