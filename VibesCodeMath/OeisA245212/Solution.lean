import FormalConjectures.OEIS.«245212»

/-!
# A245212: a(n) = σ(n) iff n is a power of 2, when the odd part of n is squarefree

Write G(n) = Σ_{d ∣ n} d·τ(d), so a(n) = 2nτ(n) − G(n). Then a(n) = σ(n) forces G(n) + σ(n) to be even.
G and σ are multiplicative. For n = 2^k·m with m odd and squarefree:
G(2^k) = k·2^(k+1) + 1 and G(p) = 1 + 2p are odd, so G(n) is odd; σ(p) = p + 1 is even, so σ(n) is even
as soon as m > 1. Hence G(n) + σ(n) is odd and equality fails unless m = 1.
Powers of 2 satisfy it: a(2^k) = 2^(k+1) − 1 = σ(2^k).
-/
open ArithmeticFunction Finset
open scoped ArithmeticFunction.sigma ArithmeticFunction.zeta

def Gf : ArithmeticFunction ℕ := (ArithmeticFunction.id.pmul (σ 0)) * ζ

lemma Gf_apply (n : ℕ) : Gf n = ∑ d ∈ n.divisors, d * d.divisors.card := by
  rw [Gf, ← natCoe_nat ζ, coe_mul_zeta_apply]
  simp [pmul_apply, id_apply, sigma_zero_apply]

lemma Gf_mult : IsMultiplicative Gf :=
  (isMultiplicative_id.pmul (isMultiplicative_sigma (k := 0))).mul isMultiplicative_zeta

lemma Gf_prime {p : ℕ} (hp : p.Prime) : Gf p = 1 + 2 * p := by
  rw [Gf_apply, hp.divisors, sum_insert (by simp [hp.one_lt.ne])]
  have : ({1, p} : Finset ℕ).card = 2 := card_pair hp.one_lt.ne
  simp [hp.divisors, this]
  ring

lemma Gf_two_pow (k : ℕ) : Gf (2 ^ k) = k * 2 ^ (k+1) + 1 := by
  rw [Gf_apply, Nat.divisors_prime_pow Nat.prime_two, sum_map]
  simp only [Function.Embedding.coeFn_mk]
  simp_rw [Nat.divisors_prime_pow Nat.prime_two, card_map, card_range]
  induction k with
  | zero => simp
  | succ k ih => rw [sum_range_succ, ih]; ring

lemma sigma_two_pow (k : ℕ) : σ 1 (2 ^ k) + 1 = 2 ^ (k+1) := by
  rw [sigma_one_apply_prime_pow Nat.prime_two]
  induction k with
  | zero => simp
  | succ k ih => rw [sum_range_succ, add_right_comm, ih]; ring

lemma odd_sqfree_parity : ∀ m : ℕ, Odd m → Squarefree m →
    Odd (Gf m) ∧ (m ≠ 1 → Even (σ 1 m)) := by
  intro m
  induction m using Nat.strong_induction_on with
  | _ m ih =>
  intro hm hsq
  by_cases h1 : m = 1
  · subst h1; refine ⟨?_, fun h => absurd rfl h⟩
    rw [Gf_apply]; simp
  have hm0 : m ≠ 0 := by rintro rfl; simp at hm
  set p := m.minFac with hpdef
  have hp : p.Prime := Nat.minFac_prime h1
  have hpm : p ∣ m := Nat.minFac_dvd m
  obtain ⟨q, hq⟩ := hpm
  have hqm : q < m := by
    rw [hq]; have := hp.two_le
    have hq0 : q ≠ 0 := by rintro rfl; simp at hq; exact hm0 hq
    nlinarith [Nat.pos_of_ne_zero hq0]
  have hcop : Nat.Coprime p q := by
    rw [hp.coprime_iff_not_dvd]
    rintro ⟨r, rfl⟩
    have : p * p ∣ m := ⟨r, by rw [hq]; ring⟩
    exact hp.one_lt.ne' (Nat.isUnit_iff.mp (hsq p this))
  have hqodd : Odd q := by rw [hq] at hm; exact (Nat.odd_mul.mp hm).2
  have hpodd : Odd p := by rw [hq] at hm; exact (Nat.odd_mul.mp hm).1
  have hqsq : Squarefree q := by rw [hq] at hsq; exact hsq.of_mul_right
  obtain ⟨ihG, -⟩ := ih q hqm hqodd hqsq
  rw [hq]
  refine ⟨?_, fun _ => ?_⟩
  · rw [Gf_mult.map_mul_of_coprime hcop, Gf_prime hp]
    exact Odd.mul (by rcases hpodd with ⟨t, ht⟩; exact ⟨p, by ring⟩) ihG
  · have hσp : σ 1 p = p + 1 := by
      have := sigma_one_apply_prime_pow hp (i := 1)
      simpa [sum_range_succ, add_comm] using this
    rw [isMultiplicative_sigma.map_mul_of_coprime hcop, hσp]
    exact Even.mul_right hpodd.add_one _

lemma a_eq (n : ℕ) : OeisA245212.a n = 2 * (n : ℤ) * (n.divisors.card : ℤ) - (Gf n : ℤ) := by
  rcases eq_or_ne n 0 with rfl | hn
  · simp [OeisA245212.a]
  have hs : (∑ d ∈ n.divisors, ((d * d.divisors.card : ℕ) : ℤ)) =
      ∑ d ∈ n.properDivisors, ((d * d.divisors.card : ℕ) : ℤ) + ((n * n.divisors.card : ℕ) : ℤ) := by
    conv_lhs => rw [← Nat.cons_self_properDivisors hn]
    rw [Finset.sum_cons, add_comm]
  rw [OeisA245212.a, Gf_apply]
  push_cast at hs ⊢
  rw [hs]; ring

theorem squarefree_odd_part_main (k m : ℕ) (hm : Odd m) (hsq : Squarefree m) :
    OeisA245212.a (2 ^ k * m) = (σ 1 (2 ^ k * m) : ℤ) ↔ ∃ j : ℕ, 2 ^ k * m = 2 ^ j := by
  have hcop : Nat.Coprime (2 ^ k) m := Nat.Coprime.pow_left _ (Nat.coprime_two_left.mpr hm)
  have htau : (2 ^ k).divisors.card = k + 1 := by
    rw [Nat.divisors_prime_pow Nat.prime_two, card_map, card_range]
  constructor
  · intro h
    refine ⟨k, ?_⟩
    by_contra hne
    have h1 : m ≠ 1 := by rintro rfl; simp at hne
    obtain ⟨hG, hS⟩ := odd_sqfree_parity m hm hsq
    have hS := hS h1
    rw [a_eq] at h
    have hnat : σ 1 (2 ^ k * m) + Gf (2 ^ k * m) = 2 * (2 ^ k * m) * (2 ^ k * m).divisors.card := by
      have : ((σ 1 (2 ^ k * m) + Gf (2 ^ k * m) : ℕ) : ℤ) = ((2 * (2 ^ k * m) * (2 ^ k * m).divisors.card : ℕ) : ℤ) := by
        push_cast at h ⊢; linarith
      exact_mod_cast this
    have hodd : Odd (σ 1 (2 ^ k * m) + Gf (2 ^ k * m)) := by
      rw [isMultiplicative_sigma.map_mul_of_coprime hcop, Gf_mult.map_mul_of_coprime hcop, Gf_two_pow]
      apply Even.add_odd (hS.mul_left _)
      apply Odd.mul _ hG
      exact ⟨k * 2 ^ k, by ring⟩
    rw [hnat] at hodd
    exact (Nat.not_even_iff_odd.mpr hodd) (even_two_mul _ |>.mul_right _)
  · rintro ⟨j, hj⟩
    have hm1 : m = 1 := by
      have hd : m ∣ 2 ^ j := ⟨2 ^ k, by rw [← hj]; ring⟩
      exact Nat.Coprime.eq_one_of_dvd (Nat.Coprime.pow_right _ (Nat.coprime_two_right.mpr hm)) hd
    subst hm1
    simp only [mul_one]
    rw [a_eq, htau, Gf_two_pow]
    have := sigma_two_pow k
    have h2 : ((σ 1 (2 ^ k) : ℕ) : ℤ) = 2 ^ (k+1) - 1 := by
      have : ((σ 1 (2 ^ k) + 1 : ℕ) : ℤ) = ((2 ^ (k+1) : ℕ) : ℤ) := by rw [this]
      push_cast at this; linarith
    rw [h2]; push_cast; ring

/-- Partial result toward OEIS A245212's conjecture (formal-conjectures `OeisA245212.conjecture`):
if the odd part m of n = 2^k * m is squarefree, then a(n) = σ(n) holds exactly when n is a power of 2.
`OeisA245212.a` is formal-conjectures' definition (pinned commit 9097e2f), unchanged. -/
theorem a245212_squarefree_odd_part (k m : ℕ) (hm : Odd m) (hsq : Squarefree m) :
    OeisA245212.a (2 ^ k * m) = (ArithmeticFunction.sigma 1 (2 ^ k * m) : ℤ) ↔
      ∃ j : ℕ, 2 ^ k * m = 2 ^ j :=
  squarefree_odd_part_main k m hm hsq
