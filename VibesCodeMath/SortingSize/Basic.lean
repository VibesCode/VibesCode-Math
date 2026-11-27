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
