module

public import FormalConjectures.Arxiv.«1601.03081».UniqueCrystalComponents

@[expose] public section

/-!
Partial results on `Arxiv.«1601.03081».crystals_components_unique` (crystal uniqueness), from
formal-conjectures. Theorem A (`crystal_iff_chain`) is the paper's Theorems 4–5 restated in integer form;
the other statements are ours. See `crystal-uniqueness/RESULT.md`.
-/

namespace CrystalUniqueness
open Arxiv.«1601.03081»

/-- The chain x_0 = 1, x_1 = k, x_{t+2} = (k-2) x_{t+1} - x_t + 2, over ℤ. -/
def x (k : ℤ) : ℕ → ℤ
  | 0 => 1
  | 1 => k
  | (t + 2) => (k - 2) * x k (t + 1) - x k t + 2

/-- n_t(k) = (2 x_t - 1)(2 x_{t+1} - 1). -/
def nn (k : ℤ) (t : ℕ) : ℤ := (2 * x k t - 1) * (2 * x k (t + 1) - 1)

lemma x_rec (k : ℤ) (t : ℕ) : x k (t + 2) = (k - 2) * x k (t + 1) - x k t + 2 := rfl

lemma x_inv (k : ℤ) (t : ℕ) : (x k t + x k (t+1) - 1)^2 = k * x k t * x k (t+1) := by
  induction t with
  | zero => simp [x]; ring
  | succ t ih =>
    rw [show t + 1 + 1 = t + 2 from rfl, x_rec]
    linear_combination ih

def Sol (k u v : ℤ) : Prop :=
  (∃ t : ℕ, (u = x k t ∧ v = x k (t+1)) ∨ (v = x k t ∧ u = x k (t+1))) ∧
  (∃ X Y : ℤ, X^2 + k*Y^2 = 1 + k*X*Y ∧ ((u = X^2 ∧ v = k*Y^2) ∨ (u = k*Y^2 ∧ v = X^2)))

lemma Sol.symm {k u v : ℤ} (h : Sol k u v) : Sol k v u := by
  obtain ⟨⟨t, ht⟩, X, Y, hr, hXY⟩ := h
  refine ⟨⟨t, ht.symm⟩, X, Y, hr, ?_⟩
  rcases hXY with ⟨h1, h2⟩ | ⟨h1, h2⟩
  · exact Or.inr ⟨h2, h1⟩
  · exact Or.inl ⟨h2, h1⟩

lemma sol_of_eq (k : ℤ) : ∀ S : ℕ, ∀ u v : ℤ, 1 ≤ u → 1 ≤ v → u + v ≤ S →
    (u+v-1)^2 = k*u*v → Sol k u v := by
  intro S
  induction S with
  | zero => intro u v hu hv hS; push_cast at hS; omega
  | succ S ih =>
    have key : ∀ u v : ℤ, 1 ≤ u → 2 ≤ v → v < u → u + v ≤ ((S + 1 : ℕ) : ℤ) →
        (u+v-1)^2 = k*u*v → Sol k u v := by
      intro u v hu hv hvu hS h
      push_cast at hS
      obtain ⟨u', hu'⟩ : ∃ u', u' = (k-2)*v + 2 - u := ⟨_, rfl⟩
      have h1 : u * u' = (v-1)^2 := by rw [hu']; linear_combination (-1:ℤ) * h
      have hpos : 1 ≤ u' := by
        by_contra hc
        push_neg at hc
        have : u * u' ≤ 0 := by nlinarith
        nlinarith
      have hlt : u' < v := by
        by_contra hc
        push_neg at hc
        nlinarith
      have h2 : (v + u' - 1)^2 = k*v*u' := by rw [hu']; linear_combination h
      have hS' : v + u' ≤ ((S : ℕ) : ℤ) := by omega
      have hsol := ih v u' (by omega) hpos hS' h2
      obtain ⟨⟨t, ht⟩, X, Y, hr, hXY⟩ := hsol
      have hu_eq : u = (k-2)*v + 2 - u' := by omega
      refine ⟨?_, ?_⟩
      · rcases ht with ⟨h3, h4⟩ | ⟨h3, h4⟩
        · cases t with
          | zero => simp [x] at h3; omega
          | succ s =>
            refine ⟨s, Or.inl ⟨?_, h3⟩⟩
            rw [hu_eq, h3, h4, show s + 1 + 1 = s + 2 from rfl, x_rec]; ring
        · refine ⟨t + 1, Or.inr ⟨h4, ?_⟩⟩
          rw [hu_eq, h3, h4, show t + 1 + 1 = t + 2 from rfl, x_rec]; ring
      · rcases hXY with ⟨h3, h4⟩ | ⟨h3, h4⟩
        · refine ⟨X, X - Y, by linear_combination hr, Or.inr ⟨?_, h3⟩⟩
          rw [hu_eq, h3, h4]; linear_combination (-2:ℤ) * hr
        · refine ⟨k*Y - X, Y, by linear_combination hr, Or.inl ⟨?_, h3⟩⟩
          rw [hu_eq, h3, h4]; linear_combination (-2:ℤ) * hr
    intro u v hu hv hS h
    by_cases hv1 : v = 1
    · subst hv1
      have hk : u = k := by
        have : u * u = u * k := by linear_combination h
        exact mul_left_cancel₀ (by omega) this
      subst hk
      exact ⟨⟨0, Or.inr ⟨by simp [x], by simp [x]⟩⟩, 1, 1, by ring, Or.inr ⟨by ring, by ring⟩⟩
    by_cases hu1 : u = 1
    · subst hu1
      have hk : v = k := by
        have : v * v = v * k := by linear_combination h
        exact mul_left_cancel₀ (by omega) this
      subst hk
      exact ⟨⟨0, Or.inl ⟨by simp [x], by simp [x]⟩⟩, 1, 1, by ring, Or.inl ⟨by ring, by ring⟩⟩
    rcases lt_trichotomy v u with hlt | heq | hgt
    · exact key u v hu (by omega) hlt hS h
    · subst heq
      exfalso
      have h5 : v * (k*v - 4*v + 4) = 1 := by linear_combination (-1:ℤ) * h
      have := Int.eq_one_of_mul_eq_one_right (by omega) h5
      omega
    · have := key v u hv (by omega) hgt (by omega) (by linear_combination h)
      exact this.symm


lemma crystal_sol (n a b : ℕ) (h : IsCrystalWithComponents n a b) :
    ∃ k : ℤ, 3 ≤ k ∧ ∃ u v : ℤ, (a:ℤ) = 2*u-1 ∧ (b:ℤ) = 2*v-1 ∧ 2 ≤ u ∧ 2 ≤ v ∧ Sol k u v := by
  rw [isCrystalWithComponents_iff_sum_sq_dvd] at h
  obtain ⟨hn, ha, hb, hnab, hdvd⟩ := h
  have hoa : Odd a := Nat.Odd.of_mul_left (hnab ▸ hn)
  have hob : Odd b := Nat.Odd.of_mul_right (hnab ▸ hn)
  obtain ⟨m, hm⟩ := hoa
  obtain ⟨l, hl⟩ := hob
  have hd := Int.natCast_dvd_natCast.mpr hdvd
  push_cast at hd
  obtain ⟨c, hc⟩ := hd
  rw [hm, hl] at hc
  push_cast at hc
  have hu : (2:ℤ) ≤ (m:ℤ) + 1 := by omega
  have hv : (2:ℤ) ≤ (l:ℤ) + 1 := by omega
  have h4 : 4 * (((m:ℤ)+1 + ((l:ℤ)+1) - 1)^2) = 4 * (c * ((m:ℤ)+1) * ((l:ℤ)+1)) := by
    linear_combination hc
  have h5 := mul_left_cancel₀ (by norm_num : (4:ℤ) ≠ 0) h4
  refine ⟨c, ?_, (m:ℤ)+1, (l:ℤ)+1, by omega, by omega, hu, hv, ?_⟩
  · by_contra hc3
    push_neg at hc3
    have e1 : (0:ℤ) ≤ ((m:ℤ)+1) * ((l:ℤ)+1) := by positivity
    nlinarith [mul_nonneg (sub_nonneg.2 hu) (sub_nonneg.2 hv), mul_nonneg (sub_nonneg.2 hu) (sub_nonneg.2 hu),
      mul_nonneg (sub_nonneg.2 hv) (sub_nonneg.2 hv), mul_nonneg (show (0:ℤ) ≤ 2 - c by omega) e1]
  · refine sol_of_eq c (((m:ℤ)+1 + ((l:ℤ)+1)).toNat) _ _ (by omega) (by omega) (Int.self_le_toNat _) ?_
    linear_combination h5

lemma crystal_of_chain (n a b : ℕ) (k p q : ℤ) (hp : (a:ℤ) = 2*p-1) (hq : (b:ℤ) = 2*q-1)
    (ha : 1 < a) (hb : 1 < b) (hn : n = a * b) (h : (p+q-1)^2 = k*p*q) :
    IsCrystalWithComponents n a b := by
  rw [isCrystalWithComponents_iff_sum_sq_dvd]
  refine ⟨?_, ha, hb, hn, ?_⟩
  · rw [hn]
    apply Nat.odd_mul.mpr
    constructor <;> rw [Nat.odd_iff] <;> omega
  · rw [← Int.natCast_dvd_natCast]
    push_cast
    refine ⟨k, ?_⟩
    have e1 : (a:ℤ) + 1 = 2*p := by omega
    have e2 : (b:ℤ) + 1 = 2*q := by omega
    have e3 : (a:ℤ) + b = 2*(p+q-1) := by omega
    rw [e1, e2, e3]
    linear_combination 4 * h

lemma chain_sum_sq (a b : ℕ) (k p q : ℤ) (hp : (a:ℤ) = 2*p-1) (hq : (b:ℤ) = 2*q-1)
    (h : (p+q-1)^2 = k*p*q) : ((a:ℤ)+b)^2 = k*(((a:ℤ)+1)*((b:ℤ)+1)) := by
  have e1 : (a:ℤ) + 1 = 2*p := by omega
  have e2 : (b:ℤ) + 1 = 2*q := by omega
  have e3 : (a:ℤ) + b = 2*(p+q-1) := by omega
  rw [e1, e2, e3]
  linear_combination 4 * h

/-- Theorem A (classification; = Abrate–Barbero–Cerruti–Murru Thm 5). -/
theorem crystal_iff_chain (n a b : ℕ) :
    IsCrystalWithComponents n a b ↔
      1 < a ∧ 1 < b ∧ n = a * b ∧ ∃ k : ℤ, ∃ t : ℕ, 3 ≤ k ∧ 1 ≤ t ∧
        (((a : ℤ) = 2 * x k t - 1 ∧ (b : ℤ) = 2 * x k (t + 1) - 1) ∨
         ((b : ℤ) = 2 * x k t - 1 ∧ (a : ℤ) = 2 * x k (t + 1) - 1)) := by
  constructor
  · intro h
    have hh := h
    obtain ⟨k, hk, u, v, hu, hv, hu2, hv2, ⟨t, ht⟩, -⟩ := crystal_sol n a b h
    rw [isCrystalWithComponents_iff_sum_sq_dvd] at hh
    obtain ⟨-, ha, hb, hnab, -⟩ := hh
    refine ⟨ha, hb, hnab, k, t, hk, ?_, ?_⟩
    · rcases t with _ | t
      · rcases ht with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> simp [x] at h1 h2 <;> omega
      · omega
    · rcases ht with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · left; constructor <;> omega
      · right; constructor <;> omega
  · rintro ⟨ha, hb, hn, k, t, hk, ht, h⟩
    rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · exact crystal_of_chain n a b k _ _ (by omega) (by omega) ha hb hn (x_inv k t)
    · refine crystal_of_chain n a b k (x k (t+1)) (x k t) (by omega) (by omega) ha hb hn ?_
      linear_combination x_inv k t

/-- Theorem B (integer form). -/
theorem crystal_iff_pell (n a b : ℕ) :
    IsCrystalWithComponents n a b ↔
      1 < a ∧ 1 < b ∧ n = a * b ∧ ∃ k X Y : ℕ, X ^ 2 + k * Y ^ 2 = 1 + k * X * Y ∧
        ((a + 1 = 2 * X ^ 2 ∧ b + 1 = 2 * k * Y ^ 2) ∨ (a + 1 = 2 * k * Y ^ 2 ∧ b + 1 = 2 * X ^ 2)) := by
  constructor
  · intro h
    have hh := h
    obtain ⟨k, hk, u, v, hu, hv, hu2, hv2, -, X, Y, hr, hXY⟩ := crystal_sol n a b h
    rw [isCrystalWithComponents_iff_sum_sq_dvd] at hh
    obtain ⟨-, ha, hb, hnab, -⟩ := hh
    have hXYn : 0 ≤ X * Y := by
      by_contra hc
      push_neg at hc
      have : X * Y ≤ -1 := by omega
      nlinarith [sq_nonneg X, mul_nonneg (show (0:ℤ) ≤ k by omega) (sq_nonneg Y)]
    have habs : ((X * Y).natAbs : ℤ) = X * Y := Int.natAbs_of_nonneg hXYn
    rw [Int.natAbs_mul] at habs
    push_cast at habs
    have hX : |X|^2 = X^2 := sq_abs X
    have hY : |Y|^2 = Y^2 := sq_abs Y
    refine ⟨ha, hb, hnab, k.toNat, X.natAbs, Y.natAbs, ?_, ?_⟩
    · have hk' : ((k.toNat : ℕ) : ℤ) = k := Int.toNat_of_nonneg (by omega)
      have : ((X.natAbs ^ 2 + k.toNat * Y.natAbs ^ 2 : ℕ) : ℤ) = ((1 + k.toNat * X.natAbs * Y.natAbs : ℕ) : ℤ) := by
        push_cast
        rw [hk', hX, hY, mul_assoc, habs]
        linear_combination hr
      exact_mod_cast this
    · have hk' : ((k.toNat : ℕ) : ℤ) = k := Int.toNat_of_nonneg (by omega)
      rcases hXY with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · left
        constructor
        · have : ((a + 1 : ℕ) : ℤ) = ((2 * X.natAbs ^ 2 : ℕ) : ℤ) := by push_cast; rw [hX]; omega
          exact_mod_cast this
        · have : ((b + 1 : ℕ) : ℤ) = ((2 * k.toNat * Y.natAbs ^ 2 : ℕ) : ℤ) := by push_cast; rw [hk', hY]; linarith
          exact_mod_cast this
      · right
        constructor
        · have : ((a + 1 : ℕ) : ℤ) = ((2 * k.toNat * Y.natAbs ^ 2 : ℕ) : ℤ) := by push_cast; rw [hk', hY]; linarith
          exact_mod_cast this
        · have : ((b + 1 : ℕ) : ℤ) = ((2 * X.natAbs ^ 2 : ℕ) : ℤ) := by push_cast; rw [hX]; omega
          exact_mod_cast this
  · rintro ⟨ha, hb, hn, k, X, Y, hr, h⟩
    rw [isCrystalWithComponents_iff_sum_sq_dvd]
    refine ⟨?_, ha, hb, hn, ?_⟩
    · rw [hn]
      apply Nat.odd_mul.mpr
      rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · have h2' : b + 1 = 2 * (k * Y ^ 2) := by linarith
        constructor <;> rw [Nat.odd_iff] <;> omega
      · have h1' : a + 1 = 2 * (k * Y ^ 2) := by linarith
        constructor <;> rw [Nat.odd_iff] <;> omega
    · rcases h with ⟨h1, h2⟩ | ⟨h1, h2⟩
      · have e : a + b = 2 * k * X * Y := by linarith
        refine ⟨k, ?_⟩
        rw [e, h1, h2]; ring
      · have e : a + b = 2 * k * X * Y := by linarith
        refine ⟨k, ?_⟩
        rw [e, h1, h2]; ring

/-- (C3) For a fixed n, the parameter k = (a+b)^2/((a+1)(b+1)) determines the crystal. -/
theorem crystal_k_determines (n a b c d : ℕ)
    (hab : IsCrystalWithComponents n a b) (hcd : IsCrystalWithComponents n c d)
    (hk : (a + b) ^ 2 * ((c + 1) * (d + 1)) = (c + d) ^ 2 * ((a + 1) * (b + 1))) :
    ({a, b} : Finset ℕ) = {c, d} := by
  obtain ⟨-, ha, hb, hn1, -⟩ := hab
  obtain ⟨-, hc, hd, hn2, -⟩ := hcd
  have hk' : (((a:ℤ) + b) ^ 2 * (((c:ℤ) + 1) * ((d:ℤ) + 1)) = ((c:ℤ) + d) ^ 2 * (((a:ℤ) + 1) * ((b:ℤ) + 1))) := by
    exact_mod_cast hk
  have hN : (a:ℤ) * b = (c:ℤ) * d := by exact_mod_cast hn1.symm.trans hn2
  have ha' : (1:ℤ) ≤ a := by exact_mod_cast (by omega : 1 ≤ a)
  have hb' : (1:ℤ) ≤ b := by exact_mod_cast (by omega : 1 ≤ b)
  have hc' : (1:ℤ) ≤ c := by exact_mod_cast (by omega : 1 ≤ c)
  have hd' : (1:ℤ) ≤ d := by exact_mod_cast (by omega : 1 ≤ d)
  have hs : (a:ℤ) + b = (c:ℤ) + d := by
    have h1 : ((a:ℤ)+b - ((c:ℤ)+d)) * (((a:ℤ)*b+1)*((a:ℤ)+b+((c:ℤ)+d)) + ((a:ℤ)+b)*((c:ℤ)+d)) = 0 := by
      linear_combination hk' + ((a:ℤ)+b)^2 * hN
    have h2 : 0 < ((a:ℤ)*b+1)*((a:ℤ)+b+((c:ℤ)+d)) + ((a:ℤ)+b)*((c:ℤ)+d) := by
      have : 0 ≤ (a:ℤ)*b := by positivity
      nlinarith
    rcases mul_eq_zero.mp h1 with h | h
    · linarith
    · exact absurd h h2.ne'
  have h3 : ((a:ℤ) - c) * ((a:ℤ) - d) = 0 := by linear_combination (a:ℤ) * hs - hN
  rcases mul_eq_zero.mp h3 with h | h
  · have e1 : a = c := by omega
    have e2 : b = d := by omega
    subst e1; subst e2; rfl
  · have e1 : a = d := by omega
    have e2 : b = c := by omega
    subst e1; subst e2; exact Finset.pair_comm _ _


lemma x_pos_lt (k : ℤ) (hk : 4 ≤ k) : ∀ t, 1 ≤ x k t ∧ x k t < x k (t+1) := by
  intro t
  induction t with
  | zero => simp [x]; omega
  | succ t ih =>
    obtain ⟨h1, h2⟩ := ih
    refine ⟨by omega, ?_⟩
    rw [show t + 1 + 1 = t + 2 from rfl, x_rec]
    nlinarith [mul_nonneg (show (0:ℤ) ≤ k - 4 by omega) (show (0:ℤ) ≤ x k (t+1) by omega)]

/-- (C1) For k ≥ 4 the chain is strictly increasing. -/
theorem x_strictMono (k : ℤ) (hk : 4 ≤ k) : StrictMono (x k) := by
  exact strictMono_nat_of_lt_succ fun t => (x_pos_lt k hk t).2

lemma x_cmp (k k' : ℤ) (hk : 4 ≤ k) (hkk : k ≤ k') : ∀ t : ℕ,
    x k t ≤ x k' t ∧ k' - k ≤ (x k' (t+1) - x k' t) - (x k (t+1) - x k t) := by
  intro t
  induction t with
  | zero => simp [x]
  | succ t ih =>
    obtain ⟨h1, h2⟩ := ih
    have p1 := (x_pos_lt k hk t).1
    have p2 := (x_pos_lt k' (by omega) t).1
    have hx : x k (t+1) ≤ x k' (t+1) := by omega
    have q1 := (x_pos_lt k hk (t+1)).1
    have q2 := (x_pos_lt k' (by omega) (t+1)).1
    refine ⟨hx, ?_⟩
    rw [show t + 1 + 1 = t + 2 from rfl, x_rec, x_rec]
    nlinarith [mul_nonneg (show (0:ℤ) ≤ k' - k by omega) (show (0:ℤ) ≤ x k' (t+1) by omega),
      mul_nonneg (show (0:ℤ) ≤ k - 4 by omega) (show (0:ℤ) ≤ x k' (t+1) - x k (t+1) by omega)]

/-- (C2) For fixed t ≥ 1, n_t(k) is strictly increasing in k ≥ 4. -/
theorem nn_strictMonoOn (t : ℕ) (ht : 1 ≤ t) : StrictMonoOn (fun k => nn k t) (Set.Ici 4) := by
  intro k hk k' hk' hlt
  simp only [Set.mem_Ici] at hk hk'
  obtain ⟨s, rfl⟩ : ∃ s, t = s + 1 := ⟨t - 1, by omega⟩
  have c := x_cmp k k' hk hlt.le s
  have hs := x_cmp k k' hk hlt.le (s+1)
  have hs1 : x k (s+1) < x k' (s+1) := by
    have := (x_pos_lt k hk s).1
    have := (x_pos_lt k' (by omega) s).1
    omega
  have hs2 : x k (s+1+1) < x k' (s+1+1) := by
    have := (x_pos_lt k hk (s+1)).1
    have := (x_pos_lt k' (by omega) (s+1)).1
    omega
  have a1 := (x_pos_lt k hk (s+1)).1
  have a2 := (x_pos_lt k hk (s+1+1)).1
  simp only [nn]
  nlinarith

/-- Theorem A restated for chain pairs. -/
lemma pair_cases {a b c d : ℕ} (h : ({a, b} : Finset ℕ) = {c, d}) :
    (a = c ∧ b = d) ∨ (a = d ∧ b = c) := by
  have h1 := Finset.ext_iff.mp h a
  have h2 := Finset.ext_iff.mp h b
  have h3 := Finset.ext_iff.mp h c
  have h4 := Finset.ext_iff.mp h d
  simp at h1 h2 h3 h4
  omega

lemma x3_pairs : ∀ t : ℕ,
    (x 3 t = 1 ∧ x 3 (t+1) = 3) ∨ (x 3 t = 3 ∧ x 3 (t+1) = 4) ∨ (x 3 t = 4 ∧ x 3 (t+1) = 3) ∨
    (x 3 t = 3 ∧ x 3 (t+1) = 1) ∨ (x 3 t = 1 ∧ x 3 (t+1) = 0) ∨ (x 3 t = 0 ∧ x 3 (t+1) = 1) := by
  intro t
  induction t with
  | zero => simp [x]
  | succ t ih =>
    rw [show t + 1 + 1 = t + 2 from rfl, x_rec]
    omega

lemma crystal_pt (k : ℤ) (t : ℕ) (hk : 3 ≤ k) (h1 : 2 ≤ x k t) (h2 : 2 ≤ x k (t+1)) :
    ∃ a b : ℕ, IsCrystalWithComponents (a*b) a b ∧ (a:ℤ) = 2 * x k t - 1 ∧
      (b:ℤ) = 2 * x k (t+1) - 1 ∧ nn k t = (a:ℤ) * b := by
  refine ⟨(2 * x k t - 1).toNat, (2 * x k (t+1) - 1).toNat, ?_, by omega, by omega, ?_⟩
  · exact crystal_of_chain _ _ _ k (x k t) (x k (t+1)) (by omega) (by omega) (by omega) (by omega) rfl (x_inv k t)
  · simp only [nn]
    rw [Int.toNat_of_nonneg (by omega), Int.toNat_of_nonneg (by omega)]

/-- The domain of the reduction: (3,1) and all (k,t) with k ≥ 4, t ≥ 1. -/
def Dom : Set (ℤ × ℕ) := {p | p = (3, 1) ∨ (4 ≤ p.1 ∧ 1 ≤ p.2)}

lemma dom_crystal (p : ℤ × ℕ) (hp : p ∈ Dom) :
    ∃ a b : ℕ, IsCrystalWithComponents (a*b) a b ∧ (a:ℤ) = 2 * x p.1 p.2 - 1 ∧
      (b:ℤ) = 2 * x p.1 (p.2+1) - 1 ∧ nn p.1 p.2 = (a:ℤ) * b := by
  rcases hp with rfl | ⟨h1, h2⟩
  · exact crystal_pt 3 1 le_rfl (by simp [x]) (by simp [x])
  · have hm := x_strictMono p.1 h1
    have e1 : x p.1 1 ≤ x p.1 p.2 := hm.monotone h2
    have e2 : x p.1 1 ≤ x p.1 (p.2 + 1) := hm.monotone (by omega)
    have e3 : x p.1 1 = p.1 := rfl
    exact crystal_pt p.1 p.2 (by omega) (by omega) (by omega)

lemma crystal_dom (n a b : ℕ) (h : IsCrystalWithComponents n a b) :
    ∃ p ∈ Dom, (n:ℤ) = nn p.1 p.2 ∧
      ({a, b} : Finset ℕ) = {(2 * x p.1 p.2 - 1).toNat, (2 * x p.1 (p.2+1) - 1).toNat} := by
  obtain ⟨ha, hb, hn, k, t, hk, ht, hh⟩ := (crystal_iff_chain n a b).mp h
  have hn' : (n:ℤ) = a * b := by exact_mod_cast hn
  rcases lt_or_eq_of_le hk with hk4 | hk3
  · refine ⟨(k, t), Or.inr ⟨by show 4 ≤ k; omega, ht⟩, ?_⟩
    simp only [nn]
    rcases hh with ⟨h1, h2⟩ | ⟨h1, h2⟩
    · refine ⟨by rw [hn', h1, h2], ?_⟩
      have : a = (2 * x k t - 1).toNat := by omega
      have : b = (2 * x k (t+1) - 1).toNat := by omega
      simp_all
    · refine ⟨by rw [hn', h1, h2]; ring, ?_⟩
      have : b = (2 * x k t - 1).toNat := by omega
      have : a = (2 * x k (t+1) - 1).toNat := by omega
      rw [Finset.pair_comm]
      simp_all
  · subst hk3
    have hp := x3_pairs t
    have hx : (a = 5 ∧ b = 7) ∨ (a = 7 ∧ b = 5) := by
      rcases hh with ⟨h1, h2⟩ | ⟨h1, h2⟩ <;> omega
    refine ⟨(3, 1), Or.inl rfl, ?_, ?_⟩
    · rcases hx with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> simp [nn, x] at hn' ⊢ <;> omega
    · rcases hx with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩
      · simp [x]
      · simp [x]; exact Finset.pair_comm _ _

/-- Reduction: the conjecture is equivalent to injectivity of (k,t) ↦ n_t(k) on `Dom`. -/
theorem unique_iff_injOn :
    (∀ n a b c d : ℕ, IsCrystalWithComponents n a b → IsCrystalWithComponents n c d →
      ({a, b} : Finset ℕ) = {c, d}) ↔
    Set.InjOn (fun p : ℤ × ℕ => nn p.1 p.2) Dom := by
  constructor
  · intro U
    rintro ⟨k, t⟩ hp ⟨k', t'⟩ hp' heq
    simp only at heq
    obtain ⟨a, b, hab, ha, hb, hn⟩ := dom_crystal _ hp
    obtain ⟨c, d, hcd, hc, hd, hn'⟩ := dom_crystal _ hp'
    simp only at ha hb hc hd hn hn'
    have hN : a * b = c * d := by
      have : (a:ℤ) * b = (c:ℤ) * d := by rw [← hn, ← hn', heq]
      exact_mod_cast this
    have hcd' : IsCrystalWithComponents (a*b) c d := by rw [hN]; exact hcd
    have hF := U _ a b c d hab hcd'
    have hsum1 := chain_sum_sq a b k _ _ ha hb (x_inv k t)
    have hsum2 := chain_sum_sq c d k' _ _ hc hd (x_inv k' t')
    have hpair := pair_cases hF
    have hkk : k = k' := by
      have hP : (0:ℤ) < ((a:ℤ)+1)*((b:ℤ)+1) := by positivity
      have hS : ((a:ℤ)+b) = c+d ∧ ((a:ℤ)+1)*((b:ℤ)+1) = ((c:ℤ)+1)*((d:ℤ)+1) := by
        rcases hpair with ⟨rfl, rfl⟩ | ⟨rfl, rfl⟩ <;> constructor <;> ring
      have e : k * (((a:ℤ)+1)*((b:ℤ)+1)) = k' * (((a:ℤ)+1)*((b:ℤ)+1)) := by
        rw [← hsum1, hS.1, hsum2, hS.2]
      exact mul_right_cancel₀ hP.ne' e
    subst hkk
    rcases hp with hp | ⟨h4, h1⟩
    · simp only [Prod.mk.injEq] at hp
      obtain ⟨rfl, rfl⟩ := hp
      rcases hp' with hp' | ⟨h4, h1⟩
      · simp only [Prod.mk.injEq] at hp'
        rw [hp'.2]
      · omega
    · rcases hp' with hp' | ⟨h4', h1'⟩
      · simp only [Prod.mk.injEq] at hp'
        omega
      · simp only at h4 h1 h4' h1'
        have hm := x_strictMono k h4
        have l1 : x k t < x k (t+1) := hm (by omega)
        have l2 : x k t' < x k (t'+1) := hm (by omega)
        have : x k t = x k t' := by
          rcases hpair with ⟨e1, e2⟩ | ⟨e1, e2⟩
          · omega
          · omega
        rw [hm.injective this]
  · intro H n a b c d hab hcd
    obtain ⟨p, hp, hn, hF⟩ := crystal_dom n a b hab
    obtain ⟨p', hp', hn', hF'⟩ := crystal_dom n c d hcd
    have : p = p' := H hp hp' (by simp only; rw [← hn, ← hn'])
    subst this
    rw [hF, hF']

end CrystalUniqueness
