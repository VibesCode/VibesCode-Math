module

public import Mathlib
public import FormalConjectures.ErdosProblems.«707»

@[expose] public section

/-!
# Erdős 707: Mueller's four-element sets {0,1,3,11} and {0,1,4,11}

Part 1 (`SidonFourEven`): Baer's polarity argument for even order, both sets.
Part 2 (`SidonFourOrder23`): Hall's multiplier theorem for planar difference sets, proved here for any
modulus, applied with p = 2 and p = 3 to {0,1,3,11}.
-/

namespace SidonFourEven
open Finset

variable {n : ℕ}

/-- An odd finset has no fixed-point-free involution. -/
lemma exists_fixed_of_involution (S : Finset (ZMod n)) (hk : Odd S.card)
    (p : ZMod n → ZMod n) (hp : ∀ b ∈ S, p b ∈ S) (hinv : ∀ b ∈ S, p (p b) = b) :
    ∃ b ∈ S, p b = b := by
  by_contra hno
  push Not at hno
  have hsum : ∑ _x ∈ S, (1 : ZMod 2) = 0 :=
    Finset.sum_involution (fun b _ => p b) (fun _ _ => by decide)
      (fun b hb _ => hno b hb) (fun b hb => hp b hb) (fun b hb => hinv b hb)
  rw [Finset.sum_const, nsmul_eq_mul, mul_one] at hsum
  rw [ZMod.natCast_eq_zero_iff] at hsum
  obtain ⟨m, hm⟩ := hk
  omega

/-- Every translate `2•S + t` of the doubled set meets `S` (uses: order even, i.e. `|S|` odd). -/
lemma meets (S : Finset (ZMod n))
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d)
    (hk : Odd S.card) (t : ZMod n) : ∃ b ∈ S, 2 * b + t ∈ S := by
  by_cases hmt : -t ∈ S
  · exact ⟨-t, hmt, by ring_nf; simpa [add_comm] using hmt⟩
  have hne : ∀ b ∈ S, b + t ≠ 0 := by
    intro b hb h
    apply hmt
    have : b = -t := by linear_combination h
    rwa [← this]
  have hex : ∀ b ∈ S, ∃ b' ∈ S, b + b' + t ∈ S := by
    intro b hb
    obtain ⟨x, hx, y, hy, hxy⟩ := he (b + t) (hne b hb)
    exact ⟨y, hy, by have : b + y + t = x := by linear_combination -hxy
                     rw [this]; exact hx⟩
  have huniq : ∀ b ∈ S, ∀ b1 ∈ S, ∀ b2 ∈ S, b + b1 + t ∈ S → b + b2 + t ∈ S → b1 = b2 := by
    intro b hb b1 hb1 b2 hb2 h1 h2
    have := hu _ h1 b1 hb1 _ h2 b2 hb2 (by ring)
      (by intro h; apply hne b hb; linear_combination h)
    exact this.2
  choose! p hpS hpP using hex
  have hinv : ∀ b ∈ S, p (p b) = b := by
    intro b hb
    apply huniq (p b) (hpS b hb) _ (hpS _ (hpS b hb)) _ hb (hpP _ (hpS b hb))
    have := hpP b hb
    rwa [show p b + b + t = b + p b + t by ring]
  obtain ⟨b, hb, hfix⟩ := exists_fixed_of_involution S hk p hpS hinv
  refine ⟨b, hb, ?_⟩
  have := hpP b hb
  rw [hfix] at this
  rwa [show 2 * b + t = b + b + t by ring]

/-- Baer's step: for even order, `2 • S` is a translate of `S`. -/
lemma doubling (S : Finset (ZMod n))
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d)
    (hk : Odd S.card) (h1 : 1 < S.card) (u : ZMod n) (hu2 : 2 * u = 1) :
    ∃ t, ∀ b ∈ S, 2 * b + t ∈ S := by
  classical
  obtain ⟨x1, hx1, x2, hx2, hx12⟩ := Finset.one_lt_card.mp h1
  have hd : x1 - x2 ≠ 0 := sub_ne_zero.mpr hx12
  have he0 : u * (x1 - x2) ≠ 0 := by
    intro h; apply hd; linear_combination 2 * h - (x1 - x2) * hu2
  obtain ⟨b1, hb1, b2, hb2, hb12⟩ := he _ he0
  refine ⟨x1 - 2 * b1, ?_⟩
  by_contra hcon
  push Not at hcon
  obtain ⟨b0, hb0, hw⟩ := hcon
  set w := 2 * b0 + (x1 - 2 * b1) with hwdef
  -- Q = pairs (c, b') with 2 b' + w - 2 c ∈ S
  let Q := (S ×ˢ S).filter (fun q : ZMod n × ZMod n => 2 * q.2 + (w - 2 * q.1) ∈ S)
  have hQ : Q.card = S.card := by
    apply Finset.card_bij (fun q _ => 2 * q.2 + (w - 2 * q.1))
    · intro q hq
      exact (Finset.mem_filter.mp hq).2
    · intro q hq r hr heq
      have hq' := Finset.mem_filter.mp hq
      have hr' := Finset.mem_filter.mp hr
      have hqS := Finset.mem_product.mp hq'.1
      have hrS := Finset.mem_product.mp hr'.1
      have hdiff : q.2 - q.1 = r.2 - r.1 := by
        linear_combination u * heq - (q.2 - q.1 - (r.2 - r.1)) * hu2
      have hneq : q.2 ≠ q.1 := by
        intro h
        apply hw
        have := hq'.2
        rw [h] at this
        rwa [show 2 * q.1 + (w - 2 * q.1) = w by ring] at this
      have := hu _ hqS.2 _ hqS.1 _ hrS.2 _ hrS.1 hdiff hneq
      exact Prod.ext this.2 this.1
    · intro x hx
      have hxw : u * (x - w) ≠ 0 := by
        intro h
        apply hw
        have : x = w := by linear_combination 2 * h - (x - w) * hu2
        rwa [← this]
      obtain ⟨b', hb', c, hc, hbc⟩ := he _ hxw
      refine ⟨(c, b'), Finset.mem_filter.mpr ⟨Finset.mem_product.mpr ⟨hc, hb'⟩, ?_⟩, ?_⟩
      · have : 2 * b' + (w - 2 * c) = x := by
          linear_combination 2 * hbc + (x - w) * hu2
        rw [this]; exact hx
      · show 2 * b' + (w - 2 * c) = x
        linear_combination 2 * hbc + (x - w) * hu2
  let F : ZMod n → ℕ := fun c => (S.filter (fun b' => 2 * b' + (w - 2 * c) ∈ S)).card
  have hQsum : Q.card = ∑ c ∈ S, F c := by
    simp only [Q, F, Finset.card_filter]
    rw [Finset.sum_product]
  have hF1 : ∀ c ∈ S, 1 ≤ F c := by
    intro c hc
    obtain ⟨b, hb, hbS⟩ := meets S hu he hk (w - 2 * c)
    exact Finset.card_pos.mpr ⟨b, Finset.mem_filter.mpr ⟨hb, hbS⟩⟩
  have hF2 : 2 ≤ F b0 := by
    have hb1ne : b1 ≠ b2 := by intro h; apply he0; rw [← hb12, h, sub_self]
    have hsub : ({b1, b2} : Finset (ZMod n)) ⊆ S.filter (fun b' => 2 * b' + (w - 2 * b0) ∈ S) := by
      intro z hz
      simp only [Finset.mem_insert, Finset.mem_singleton] at hz
      rcases hz with rfl | rfl
      · refine Finset.mem_filter.mpr ⟨hb1, ?_⟩
        rw [show 2 * z + (w - 2 * b0) = x1 by rw [hwdef]; ring]; exact hx1
      · refine Finset.mem_filter.mpr ⟨hb2, ?_⟩
        have : 2 * z + (w - 2 * b0) = x2 := by
          rw [hwdef]; linear_combination -2 * hb12 - (x1 - x2) * hu2
        rw [this]; exact hx2
    have := Finset.card_le_card hsub
    rw [Finset.card_pair hb1ne] at this
    exact this
  have hsum : S.card + 1 ≤ ∑ c ∈ S, F c := by
    rw [← Finset.add_sum_erase S F hb0]
    have : (S.erase b0).card ≤ ∑ c ∈ S.erase b0, F c := by
      rw [Finset.card_eq_sum_ones]
      exact Finset.sum_le_sum (fun c hc => hF1 c (Finset.mem_of_mem_erase hc))
    have hc := Finset.card_erase_add_one hb0
    omega
  omega


/-- A perfect difference set of the trusted kind has `|S|(|S|-1) = n - 1` distinct differences. -/
lemma count (S : Finset (ZMod n)) [NeZero n]
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d) :
    S.card * S.card - S.card = n - 1 := by
  classical
  rw [← Finset.offDiag_card]
  have h : (Finset.univ.filter (fun x : ZMod n => x ≠ 0)).card = n - 1 := by
    rw [Finset.filter_ne' Finset.univ (0 : ZMod n), Finset.card_erase_of_mem (Finset.mem_univ _),
      Finset.card_univ, ZMod.card]
  rw [← h]
  apply Finset.card_bij (fun q _ => q.1 - q.2)
  · intro q hq
    have := Finset.mem_offDiag.mp hq
    simpa [sub_eq_zero] using this.2.2
  · intro q hq r hr heq
    have hq' := Finset.mem_offDiag.mp hq
    have hr' := Finset.mem_offDiag.mp hr
    have := hu _ hq'.1 _ hq'.2.1 _ hr'.1 _ hr'.2.1 heq hq'.2.2
    exact Prod.ext this.1 this.2
  · intro d hd
    have hd' : d ≠ 0 := (Finset.mem_filter.mp hd).2
    obtain ⟨x, hx, y, hy, hxy⟩ := he d hd'
    refine ⟨(x, y), Finset.mem_offDiag.mpr ⟨hx, hy, ?_⟩, hxy⟩
    intro h; apply hd'; rw [← hxy]; simp only at h; rw [h, sub_self]

lemma lit_ne [NeZero n] (m : ℕ) (hm0 : 0 < m) (hmn : m < n) : (m : ZMod n) ≠ 0 := by
  rw [Ne, ZMod.natCast_eq_zero_iff]
  intro h
  exact absurd (Nat.le_of_dvd hm0 h) (by omega)

end SidonFourEven

open SidonFourEven in
/-- Mueller's two size-4 Sidon sets for Erdős 707 (MathOverflow answer 502053), {0,1,3,11} and
{0,1,4,11}, lie in no perfect difference set of even order: if B ⊆ ℕ is a perfect difference set
modulo n (any n, formal-conjectures' definition, pinned commit 9097e2f) and B has an odd number
of elements (so its order |B| - 1 is even), then B contains neither set. -/
theorem sets_0_1_3_11_and_0_1_4_11_not_in_even_order_pds :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → Odd B.ncard →
      ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B ∧ ¬ ({0, 1, 4, 11} : Set ℕ) ⊆ B := by
  classical
  intro B n hB hodd
  have hfin : B.Finite := Set.finite_of_ncard_ne_zero (by rcases hodd with ⟨m, hm⟩; omega)
  have hinj : ∀ a ∈ B, ∀ b ∈ B, ((a : ℕ) : ZMod n) = b → a = b := by
    intro a ha b hb h
    by_contra hab
    have := hB.mapsTo (show (a, b) ∈ B.offDiag from ⟨ha, hb, hab⟩)
    simp [h] at this
  set S : Finset (ZMod n) := hfin.toFinset.image (fun a : ℕ => (a : ZMod n)) with hSdef
  have hS : ∀ x, x ∈ S ↔ ∃ a ∈ B, (a : ZMod n) = x := by
    intro x; simp [hSdef]
  have hmem : ∀ a ∈ B, (a : ZMod n) ∈ S := fun a ha => (hS _).mpr ⟨a, ha, rfl⟩
  have hcard : S.card = B.ncard := by
    rw [Set.ncard_eq_toFinset_card B hfin, hSdef]
    apply Finset.card_image_of_injOn
    intro a ha b hb h
    exact hinj a (by simpa using ha) b (by simpa using hb) h
  have hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y' := by
    intro x hx y hy x' hx' y' hy' hxy hne
    obtain ⟨a, ha, rfl⟩ := (hS x).mp hx
    obtain ⟨b, hb, rfl⟩ := (hS y).mp hy
    obtain ⟨a', ha', rfl⟩ := (hS x').mp hx'
    obtain ⟨b', hb', rfl⟩ := (hS y').mp hy'
    have hab : a ≠ b := by rintro rfl; exact hne rfl
    have hab' : a' ≠ b' := by
      rintro rfl; apply hne; rw [← sub_eq_zero, hxy, sub_self]
    have := hB.injOn (show (a, b) ∈ B.offDiag from ⟨ha, hb, hab⟩)
      (show (a', b') ∈ B.offDiag from ⟨ha', hb', hab'⟩) (by simpa using hxy)
    simp only [Prod.mk.injEq] at this
    rw [this.1, this.2]; exact ⟨rfl, rfl⟩
  have he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d := by
    intro d hd
    obtain ⟨⟨a, b⟩, hab, heq⟩ := hB.surjOn (show d ∈ {x : ZMod n | x ≠ 0} from hd)
    exact ⟨a, hmem a hab.1, b, hmem b hab.2.1, heq⟩
  have hk : Odd S.card := hcard ▸ hodd
  -- n ≠ 0
  have hn0 : n ≠ 0 := by
    rintro rfl
    obtain ⟨d, hd⟩ := Infinite.exists_notMem_finset
      ((S ×ˢ S).image (fun q : ZMod 0 × ZMod 0 => q.1 - q.2) ∪ {0})
    have hd0 : d ≠ 0 := by intro h; apply hd; simp [h]
    obtain ⟨x, hx, y, hy, hxy⟩ := he d hd0
    apply hd
    exact Finset.mem_union_left _ (Finset.mem_image.mpr ⟨(x, y), Finset.mem_product.mpr ⟨hx, hy⟩, hxy⟩)
  have : NeZero n := ⟨hn0⟩
  have hcount := count S hu he
  set k := S.card with hkdef
  have hnk : n = k * k - k + 1 := by omega
  have hnodd : n % 2 = 1 := by
    have : Even (k * (k - 1)) := Nat.even_mul_pred_self k
    rw [Nat.mul_sub_one] at this
    rcases this with ⟨r, hr⟩
    omega
  set u : ZMod n := (((n + 1) / 2 : ℕ) : ZMod n) with hudef
  have hu2 : 2 * u = 1 := by
    have h : 2 * ((n + 1) / 2) = n + 1 := by omega
    have : ((2 * ((n + 1) / 2) : ℕ) : ZMod n) = ((n + 1 : ℕ) : ZMod n) := by rw [h]
    push_cast at this
    rw [hudef, this, ZMod.natCast_self, zero_add]
  constructor
  · intro hA
    have h0 := hmem 0 (hA (by simp)); have h1 := hmem 1 (hA (by simp))
    have h3 := hmem 3 (hA (by simp)); have h11 := hmem 11 (hA (by simp))
    push_cast at h0 h1 h3 h11
    have hk4 : 4 ≤ k := by
      have : ({0, 1, 3, 11} : Finset ℕ).card ≤ B.ncard := by
        rw [← Set.ncard_coe_finset]
        apply Set.ncard_le_ncard _ hfin
        intro x hx; apply hA; simpa using hx
      have hc : k = B.ncard := hcard
      simp at this; omega
    have hk5 : 5 ≤ k := by rcases hk with ⟨r, hr⟩; omega
    have hn21 : 21 ≤ n := by have := Nat.mul_le_mul_right k hk5; omega
    have h2 : (2 : ZMod n) ≠ 0 := by exact_mod_cast lit_ne 2 (by norm_num) (by omega)
    have h4 : (4 : ZMod n) ≠ 0 := by exact_mod_cast lit_ne 4 (by norm_num) (by omega)
    obtain ⟨t, ht⟩ := doubling S hu he hk (by omega) u hu2
    have m0 := ht 0 h0; have m1 := ht 1 h1; have m3 := ht 3 h3
    have e1 := hu _ m1 _ m0 _ h3 _ h1 (by ring) (by intro h; apply h2; linear_combination h)
    have ht1 : t = 1 := by linear_combination e1.1
    rw [ht1] at m3
    have e2 := hu _ h11 _ m3 _ m3 _ h3 (by ring) (by intro h; apply h4; linear_combination h)
    apply h4; linear_combination e2.1
  · intro hA
    have h0 := hmem 0 (hA (by simp)); have h1 := hmem 1 (hA (by simp))
    have h4m := hmem 4 (hA (by simp)); have h11 := hmem 11 (hA (by simp))
    push_cast at h0 h1 h4m h11
    have hk4 : 4 ≤ k := by
      have : ({0, 1, 4, 11} : Finset ℕ).card ≤ B.ncard := by
        rw [← Set.ncard_coe_finset]
        apply Set.ncard_le_ncard _ hfin
        intro x hx; apply hA; simpa using hx
      have hc : k = B.ncard := hcard
      simp at this; omega
    have hk5 : 5 ≤ k := by rcases hk with ⟨r, hr⟩; omega
    have hn21 : 21 ≤ n := by have := Nat.mul_le_mul_right k hk5; omega
    have h1ne : (1 : ZMod n) ≠ 0 := by exact_mod_cast lit_ne 1 (by norm_num) (by omega)
    have h4 : (4 : ZMod n) ≠ 0 := by exact_mod_cast lit_ne 4 (by norm_num) (by omega)
    have h10 : (10 : ZMod n) ≠ 0 := by exact_mod_cast lit_ne 10 (by norm_num) (by omega)
    obtain ⟨t, ht⟩ := doubling S hu he hk (by omega) u hu2
    have m0 := ht 0 h0; have m1 := ht 1 h1
    have m00 := ht _ m0; have m11 := ht _ m1
    have e1 := hu _ m11 _ m00 _ h4m _ h0 (by ring) (by intro h; apply h4; linear_combination h)
    have h3t : 3 * t = 0 := by linear_combination e1.1
    by_cases ht0 : t = 0
    · rw [ht0] at m1
      have e := hu _ m1 _ h1 _ h1 _ h0 (by ring) (by intro h; apply h1ne; linear_combination h)
      exact h1ne e.2
    · have m4 := ht _ h4m; have m44 := ht _ m4; have m444 := ht _ m44
      have m11' := ht _ h11
      have e := hu _ h1 _ h11 _ m11' _ m444 (by linear_combination 2 * h3t)
        (by intro h; apply h10; linear_combination -h)
      have htm : t = -21 := by linear_combination -e.1
      have h63 : ((63 : ℕ) : ZMod n) = 0 := by
        push_cast; linear_combination -h3t + 3 * htm
      rw [ZMod.natCast_eq_zero_iff] at h63
      have hle : n ≤ 63 := Nat.le_of_dvd (by norm_num) h63
      have hk8 : k ≤ 8 := by
        by_contra hc; push Not at hc; have := Nat.mul_le_mul_right k (show 9 ≤ k by omega); omega
      have hn : n = 21 := by
        rcases hk with ⟨r, hr⟩
        interval_cases k <;> (try omega) <;> (rw [hnk] at h63; norm_num at h63)
      subst hn
      apply ht0; rw [htm]; decide


namespace SidonFourOrder23
open Finset AddMonoidAlgebra

variable {n : ℕ}

/-- Frobenius step of Hall's multiplier theorem (planar case): for a prime `p ∣ |S| - 1`,
every count `#{(d, d') ∈ S² : p d - d' = s}` is `1` mod `p`. -/
lemma hall_mod_p [NeZero n] (S : Finset (ZMod n))
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d)
    (p : ℕ) [hp : Fact p.Prime] (hpk : p ∣ S.card - 1) (hk1 : 1 ≤ S.card) (s : ZMod n) :
    ((((S ×ˢ S).filter (fun x : ZMod n × ZMod n => (p : ZMod n) * x.1 - x.2 = s)).card : ℕ) : ZMod p) = 1 := by
  classical
  have hk : ((S.card : ℕ) : ZMod p) = 1 := by
    have h0 : ((S.card - 1 : ℕ) : ZMod p) = 0 := (ZMod.natCast_eq_zero_iff _ _).mpr hpk
    have : S.card = (S.card - 1) + 1 := by omega
    rw [this, Nat.cast_add, h0, Nat.cast_one, zero_add]
  have hinj : Function.Injective (algebraMap (ZMod p) (AddMonoidAlgebra (ZMod p) (ZMod n))) := by
    intro a b h
    rw [Algebra.algebraMap_eq_smul_one, Algebra.algebraMap_eq_smul_one, one_def, smul_single',
      smul_single'] at h
    have := congrArg (fun x : AddMonoidAlgebra (ZMod p) (ZMod n) => x.coeff 0) h
    simpa [coeff_single] using this
  have : CharP (AddMonoidAlgebra (ZMod p) (ZMod n)) p := charP_of_injective_algebraMap hinj p
  set D : AddMonoidAlgebra (ZMod p) (ZMod n) := ∑ d ∈ S, single d 1 with hD
  set D' : AddMonoidAlgebra (ZMod p) (ZMod n) := ∑ d ∈ S, single (-d) 1 with hD'
  set G : AddMonoidAlgebra (ZMod p) (ZMod n) := ∑ x : ZMod n, single x 1 with hG
  have hsG : ∀ d : ZMod n, single d (1 : ZMod p) * G = G := by
    intro d
    rw [hG, Finset.mul_sum]
    simp only [single_mul_single, mul_one]
    exact Fintype.sum_equiv (Equiv.addLeft d) _ _ (fun x => rfl)
  have hkG : ∀ X : AddMonoidAlgebra (ZMod p) (ZMod n), S.card • X = X := by
    intro X
    rw [← Nat.cast_smul_eq_nsmul (ZMod p), hk, one_smul]
  have hDG : D * G = G := by
    rw [hD, Finset.sum_mul]
    simp only [hsG, Finset.sum_const]
    exact hkG G
  have hDpow : ∀ j : ℕ, D ^ j * G = G := by
    intro j
    induction j with
    | zero => simp
    | succ j ih => rw [pow_succ, mul_assoc, hDG, ih]
  have hDD' : D * D' = G := by
    rw [hD, hD', Finset.sum_mul_sum]
    simp only [single_mul_single, mul_one]
    rw [← Finset.sum_product' (f := fun a b => single (a + -b) (1 : ZMod p))]
    rw [← Finset.diag_union_offDiag, Finset.sum_union (Finset.disjoint_diag_offDiag S)]
    have h1 : ∑ x ∈ S.diag, single (x.1 + -x.2) (1 : ZMod p) = S.card • single 0 1 := by
      rw [Finset.sum_congr rfl (g := fun _ => single (0 : ZMod n) (1 : ZMod p))]
      · rw [Finset.sum_const, Finset.diag_card]
      · intro x hx
        rw [Finset.mem_diag] at hx
        rw [hx.2, add_neg_cancel]
    have h2 : ∑ x ∈ S.offDiag, single (x.1 + -x.2) (1 : ZMod p) =
        ∑ x ∈ (Finset.univ : Finset (ZMod n)).erase 0, single x 1 := by
      apply Finset.sum_bij (fun x _ => x.1 + -x.2)
      · intro x hx
        have := Finset.mem_offDiag.mp hx
        refine Finset.mem_erase.mpr ⟨?_, Finset.mem_univ _⟩
        rw [← sub_eq_add_neg, sub_ne_zero]; exact this.2.2
      · intro x hx y hy h
        have hx' := Finset.mem_offDiag.mp hx
        have hy' := Finset.mem_offDiag.mp hy
        rw [← sub_eq_add_neg, ← sub_eq_add_neg] at h
        have := hu _ hx'.1 _ hx'.2.1 _ hy'.1 _ hy'.2.1 h hx'.2.2
        exact Prod.ext this.1 this.2
      · intro d hd
        have hd0 := (Finset.mem_erase.mp hd).1
        obtain ⟨x, hx, y, hy, hxy⟩ := he d hd0
        refine ⟨(x, y), Finset.mem_offDiag.mpr ⟨hx, hy, ?_⟩, ?_⟩
        · intro h; apply hd0; rw [← hxy]; simp only at h; rw [h, sub_self]
        · simp only; rw [← sub_eq_add_neg, hxy]
      · intro x hx; rfl
    rw [h1, h2, hkG, hG, ← Finset.add_sum_erase _ _ (Finset.mem_univ (0 : ZMod n))]
  have hDp : D ^ p = ∑ d ∈ S, single ((p : ZMod n) * d) 1 := by
    rw [hD, sum_pow_char]
    simp only [single_pow, one_pow, nsmul_eq_mul]
  have key : D ^ p * D' = G := by
    have hp1 : D ^ p = D ^ (p - 1) * D := by
      rw [← pow_succ]; congr 1; have := hp.out.two_le; omega
    rw [hp1, mul_assoc, hDD', hDpow]
  rw [hDp, hD', Finset.sum_mul_sum] at key
  simp only [single_mul_single, mul_one] at key
  have := congrArg (fun x : AddMonoidAlgebra (ZMod p) (ZMod n) => x.coeff s) key
  simp only [coeff_sum, coeff_single, hG, Finsupp.coe_finsetSum, Finset.sum_apply,
    Finsupp.single_apply] at this
  rw [Finset.card_filter, Nat.cast_sum, Finset.sum_product]
  rw [Finset.sum_ite_eq_of_mem' _ _ _ (Finset.mem_univ s)] at this
  rw [← this]
  apply Finset.sum_congr rfl; intro a _; apply Finset.sum_congr rfl; intro b _
  rw [← sub_eq_add_neg]; split_ifs <;> simp


lemma fiber_card (S : Finset (ZMod n)) (a s : ZMod n) :
    ((S ×ˢ S).filter (fun x : ZMod n × ZMod n => a * x.1 - x.2 = s)).card =
      (S.filter (fun e => a * e - s ∈ S)).card := by
  classical
  apply Finset.card_nbij' (fun x => x.1) (fun e => (e, a * e - s))
  · intro x hx
    simp only [Finset.coe_filter, Set.mem_ofPred_eq, Finset.mem_product] at hx ⊢
    refine ⟨hx.1.1, ?_⟩
    rw [show a * x.1 - s = x.2 by rw [← hx.2]; ring]; exact hx.1.2
  · intro e he
    simp only [Finset.coe_filter, Set.mem_ofPred_eq, Finset.mem_product] at he ⊢
    exact ⟨⟨he.1, he.2⟩, by ring⟩
  · intro x hx
    simp only [Finset.coe_filter, Set.mem_ofPred_eq, Finset.mem_product] at hx
    ext
    · rfl
    · simp only; rw [← hx.2]; ring
  · intro e _; rfl

lemma one_rep (S : Finset (ZMod n))
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d) (z : ZMod n) (hz : z ≠ 0) :
    (S.filter (fun d' => z + d' ∈ S)).card = 1 := by
  classical
  obtain ⟨x, hx, y, hy, hxy⟩ := he z hz
  rw [Finset.card_eq_one]
  refine ⟨y, ?_⟩
  ext d'
  simp only [Finset.mem_filter, Finset.mem_singleton]
  constructor
  · rintro ⟨hd', hzd⟩
    have := hu _ hzd _ hd' _ hx _ hy (by rw [hxy]; ring) (by intro h; apply hz; linear_combination h)
    exact this.2
  · intro h
    rw [h]
    refine ⟨hy, ?_⟩
    rw [show z + y = x by rw [← hxy]; ring]; exact hx

lemma eq_case (T : Finset (ZMod n)) (m : ZMod n → ℕ) (hpos : 0 < ∑ s ∈ T, m s)
    (h : ∑ s ∈ T, m s * m s = (∑ s ∈ T, m s) * (∑ s ∈ T, m s)) :
    ∃ s ∈ T, m s = ∑ t ∈ T, m t := by
  by_contra hno
  push Not at hno
  set M := ∑ t ∈ T, m t
  obtain ⟨s0, hs0, hm0⟩ : ∃ s ∈ T, 0 < m s := by
    by_contra hc; push Not at hc
    have : M = 0 := Finset.sum_eq_zero (fun s hs => by have := hc s hs; omega)
    omega
  have hle : ∀ s ∈ T, m s ≤ M := fun s hs => Finset.single_le_sum (fun _ _ => Nat.zero_le _) hs
  have hlt : ∑ s ∈ T, m s * m s < ∑ s ∈ T, m s * M := by
    apply Finset.sum_lt_sum
    · intro s hs; exact Nat.mul_le_mul_left _ (hle s hs)
    · refine ⟨s0, hs0, ?_⟩
      exact Nat.mul_lt_mul_of_pos_left (lt_of_le_of_ne (hle s0 hs0) (hno s0 hs0)) hm0
  have h5 : ∑ s ∈ T, m s * M = M * M := by rw [← Finset.sum_mul]
  omega

/-- Hall's multiplier theorem for planar difference sets (combinatorial form): if a prime `p`
divides the order `|S| - 1` and is a unit mod `n`, then `p • S` is a translate of `S`. -/
lemma hall [NeZero n] (S : Finset (ZMod n))
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d)
    (p : ℕ) [hp : Fact p.Prime] (hpk : p ∣ S.card - 1) (hk2 : 2 ≤ S.card)
    (hn : n = S.card * S.card - S.card + 1) (hpu : IsUnit (p : ZMod n)) :
    ∃ s0, ∀ d ∈ S, (p : ZMod n) * d - s0 ∈ S := by
  classical
  set k := S.card with hkdef
  set a : ZMod n := (p : ZMod n)
  let c : ZMod n → ℕ := fun s => ((S ×ˢ S).filter (fun x : ZMod n × ZMod n => a * x.1 - x.2 = s)).card
  have hc1 : ∀ s, c s % p = 1 := by
    intro s
    have := hall_mod_p S hu he p hpk (by omega) s
    have h := congrArg ZMod.val this
    have : Fact (1 < p) := ⟨hp.out.one_lt⟩
    rwa [ZMod.val_natCast, ZMod.val_one] at h
  have hsum : ∑ s, c s = k * k := by
    rw [hkdef, ← Finset.card_product]
    exact (Finset.card_eq_sum_card_fiberwise (fun x _ => Finset.mem_univ _)).symm
  have hsq : ∑ s, c s * c s = k * (2 * k - 1) := by
    have h1 : ∑ s, c s * c s = ∑ x ∈ S ×ˢ S, c (a * x.1 - x.2) := by
      rw [← Finset.sum_fiberwise_of_maps_to (s := S ×ˢ S) (t := Finset.univ)
        (g := fun x : ZMod n × ZMod n => a * x.1 - x.2) (fun _ _ => Finset.mem_univ _)]
      apply Finset.sum_congr rfl
      intro s _
      rw [Finset.sum_congr rfl (g := fun _ => c s)]
      · rw [Finset.sum_const, smul_eq_mul]
      · intro x hx; rw [(Finset.mem_filter.mp hx).2]
    rw [h1, Finset.sum_product]
    have h2 : ∀ d ∈ S, ∑ d' ∈ S, c (a * d - d') = 2 * k - 1 := by
      intro d hd
      have h3 : ∀ d', c (a * d - d') = ∑ e ∈ S, if a * e - (a * d - d') ∈ S then 1 else 0 := by
        intro d'
        simp only [c]; rw [fiber_card, Finset.card_filter]
      simp only [h3]
      rw [Finset.sum_comm]
      have h4 : ∀ e ∈ S, ∑ d' ∈ S, (if a * e - (a * d - d') ∈ S then 1 else 0) =
          if e = d then k else 1 := by
        intro e he'
        rw [← Finset.card_filter]
        split_ifs with hed
        · rw [hed]; congr 1; ext d'; simp only [Finset.mem_filter]
          constructor
          · exact fun h => h.1
          · intro h; exact ⟨h, by rw [show a * d - (a * d - d') = d' by ring]; exact h⟩
        · have hz : a * (e - d) ≠ 0 := by
            intro h
            apply hed
            have := (hpu.mul_right_eq_zero).mp h
            exact sub_eq_zero.mp this
          rw [← one_rep S hu he _ hz]
          congr 1; ext d'; simp only [Finset.mem_filter]
          rw [show a * e - (a * d - d') = a * (e - d) + d' by ring]
      rw [Finset.sum_congr rfl h4, ← Finset.add_sum_erase _ _ hd, if_pos rfl]
      rw [Finset.sum_congr rfl (g := fun _ => 1)]
      · rw [Finset.sum_const, Finset.card_erase_of_mem hd, smul_eq_mul, mul_one]; omega
      · intro e he'; rw [if_neg (Finset.ne_of_mem_erase he')]
    rw [Finset.sum_congr rfl h2, Finset.sum_const, smul_eq_mul]
  -- write c s = p * m s + 1
  set m : ZMod n → ℕ := fun s => c s / p with hm
  have hcm : ∀ s, c s = p * m s + 1 := by
    intro s; have := Nat.div_add_mod (c s) p; rw [hc1 s] at this; simp only [hm]; omega
  have hcard : (Finset.univ : Finset (ZMod n)).card = n := by
    rw [Finset.card_univ, ZMod.card]
  set M := ∑ s, m s with hM
  set Q := ∑ s, m s * m s with hQ
  have hcardn : ∑ _s : ZMod n, (1 : ℕ) = n := by
    rw [Finset.sum_const, Finset.card_univ, ZMod.card, smul_eq_mul, mul_one]
  have e1 : p * M + n = k * k := by
    rw [← hsum]
    calc p * M + n = ∑ s, (p * m s + 1) := by
          rw [Finset.sum_add_distrib, ← Finset.mul_sum, hcardn]
      _ = ∑ s, c s := Finset.sum_congr rfl (fun s _ => (hcm s).symm)
  have e2 : p * p * Q + 2 * (p * M) + n = k * (2 * k - 1) := by
    rw [← hsq]
    calc p * p * Q + 2 * (p * M) + n = ∑ s, (p * p * (m s * m s) + 2 * (p * m s) + 1) := by
          rw [Finset.sum_add_distrib, Finset.sum_add_distrib, ← Finset.mul_sum, ← Finset.mul_sum,
            ← Finset.mul_sum, hcardn]
      _ = ∑ s, c s * c s := Finset.sum_congr rfl (fun s _ => by rw [hcm s]; ring)
  have hk1 : 1 ≤ k := by omega
  set K := k * k with hK
  have hKk : k ≤ K := Nat.le_mul_self k
  set j := k - 1 with hj
  have hkj : k = j + 1 := by omega
  have hKj : K = j * j + 2 * j + 1 := by rw [hK, hkj]; ring
  have e3 : k * (2 * k - 1) = j * (2 * j + 1) + (2 * j + 1) := by
    rw [hkj, show 2 * (j + 1) - 1 = 2 * j + 1 by omega]; ring
  have hpM : p * M = j := by
    have : j * j + 2 * j + 1 = j * j + j + (j + 1) := by ring
    omega
  have hpQ : p * p * Q = j * j := by
    have : j * (2 * j + 1) + (2 * j + 1) = 2 * (j * j) + 3 * j + 1 := by ring
    omega
  have hQM : Q = M * M := by
    have hp0 : 0 < p * p := Nat.mul_pos hp.out.pos hp.out.pos
    have : p * p * Q = p * p * (M * M) := by
      rw [hpQ, ← hpM]; ring
    exact Nat.eq_of_mul_eq_mul_left hp0 this
  have hMpos : 0 < M := by
    rcases Nat.eq_zero_or_pos M with h | h
    · rw [h] at hpM; omega
    · exact h
  obtain ⟨s0, _, hs0⟩ := eq_case Finset.univ m hMpos hQM
  refine ⟨s0, ?_⟩
  have hcs : c s0 = k := by rw [hcm, hs0, ← hM, hpM]; omega
  have : (S.filter (fun e => a * e - s0 ∈ S)).card = S.card := by
    rw [← fiber_card]; exact hcs
  exact Finset.filter_card_eq this

/-- A perfect difference set of the trusted kind has `|S|(|S|-1) = n - 1` distinct differences. -/
lemma count (S : Finset (ZMod n)) [NeZero n]
    (hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y')
    (he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d) :
    S.card * S.card - S.card = n - 1 := by
  classical
  rw [← Finset.offDiag_card]
  have h : (Finset.univ.filter (fun x : ZMod n => x ≠ 0)).card = n - 1 := by
    rw [Finset.filter_ne' Finset.univ (0 : ZMod n), Finset.card_erase_of_mem (Finset.mem_univ _),
      Finset.card_univ, ZMod.card]
  rw [← h]
  apply Finset.card_bij (fun q _ => q.1 - q.2)
  · intro q hq
    have := Finset.mem_offDiag.mp hq
    simpa [sub_eq_zero] using this.2.2
  · intro q hq r hr heq
    have hq' := Finset.mem_offDiag.mp hq
    have hr' := Finset.mem_offDiag.mp hr
    have := hu _ hq'.1 _ hq'.2.1 _ hr'.1 _ hr'.2.1 heq hq'.2.2
    exact Prod.ext this.1 this.2
  · intro d hd
    have hd' : d ≠ 0 := (Finset.mem_filter.mp hd).2
    obtain ⟨x, hx, y, hy, hxy⟩ := he d hd'
    refine ⟨(x, y), Finset.mem_offDiag.mpr ⟨hx, hy, ?_⟩, hxy⟩
    intro h; apply hd'; rw [← hxy]; simp only at h; rw [h, sub_self]

lemma lit_ne [NeZero n] (m : ℕ) (hm0 : 0 < m) (hmn : m < n) : (m : ZMod n) ≠ 0 := by
  rw [Ne, ZMod.natCast_eq_zero_iff]
  intro h
  exact absurd (Nat.le_of_dvd hm0 h) (by omega)

end SidonFourOrder23

open SidonFourOrder23 in
/-- Mueller's size-4 Sidon set {0,1,3,11} for Erdős 707 (MathOverflow answer 502053) lies in no
finite perfect difference set whose order |B| - 1 is divisible by 2 or by 3, for any modulus n
(formal-conjectures' definition, pinned commit 9097e2f). -/
theorem set_0_1_3_11_not_in_pds_of_order_div_two_or_three :
    ∀ (B : Set ℕ) (n : ℕ), IsPerfectDifferenceSet B n → B.Finite →
      (2 ∣ B.ncard - 1 ∨ 3 ∣ B.ncard - 1) → ¬ ({0, 1, 3, 11} : Set ℕ) ⊆ B := by
  classical
  intro B n hB hfin hdiv hA
  have hinj : ∀ a ∈ B, ∀ b ∈ B, ((a : ℕ) : ZMod n) = b → a = b := by
    intro a ha b hb h
    by_contra hab
    have := hB.mapsTo (show (a, b) ∈ B.offDiag from ⟨ha, hb, hab⟩)
    simp [h] at this
  set S : Finset (ZMod n) := hfin.toFinset.image (fun a : ℕ => (a : ZMod n)) with hSdef
  have hS : ∀ x, x ∈ S ↔ ∃ a ∈ B, (a : ZMod n) = x := by
    intro x; simp [hSdef]
  have hmem : ∀ a ∈ B, (a : ZMod n) ∈ S := fun a ha => (hS _).mpr ⟨a, ha, rfl⟩
  have hcard : S.card = B.ncard := by
    rw [Set.ncard_eq_toFinset_card B hfin, hSdef]
    apply Finset.card_image_of_injOn
    intro a ha b hb h
    exact hinj a (by simpa using ha) b (by simpa using hb) h
  have hu : ∀ x ∈ S, ∀ y ∈ S, ∀ x' ∈ S, ∀ y' ∈ S, x - y = x' - y' → x ≠ y → x = x' ∧ y = y' := by
    intro x hx y hy x' hx' y' hy' hxy hne
    obtain ⟨a, ha, rfl⟩ := (hS x).mp hx
    obtain ⟨b, hb, rfl⟩ := (hS y).mp hy
    obtain ⟨a', ha', rfl⟩ := (hS x').mp hx'
    obtain ⟨b', hb', rfl⟩ := (hS y').mp hy'
    have hab : a ≠ b := by rintro rfl; exact hne rfl
    have hab' : a' ≠ b' := by
      rintro rfl; apply hne; rw [← sub_eq_zero, hxy, sub_self]
    have := hB.injOn (show (a, b) ∈ B.offDiag from ⟨ha, hb, hab⟩)
      (show (a', b') ∈ B.offDiag from ⟨ha', hb', hab'⟩) (by simpa using hxy)
    simp only [Prod.mk.injEq] at this
    rw [this.1, this.2]; exact ⟨rfl, rfl⟩
  have he : ∀ d : ZMod n, d ≠ 0 → ∃ x ∈ S, ∃ y ∈ S, x - y = d := by
    intro d hd
    obtain ⟨⟨a, b⟩, hab, heq⟩ := hB.surjOn (show d ∈ {x : ZMod n | x ≠ 0} from hd)
    exact ⟨a, hmem a hab.1, b, hmem b hab.2.1, heq⟩
  have hn0 : n ≠ 0 := by
    rintro rfl
    obtain ⟨d, hd⟩ := Infinite.exists_notMem_finset
      ((S ×ˢ S).image (fun q : ZMod 0 × ZMod 0 => q.1 - q.2) ∪ {0})
    have hd0 : d ≠ 0 := by intro h; apply hd; simp [h]
    obtain ⟨x, hx, y, hy, hxy⟩ := he d hd0
    apply hd
    exact Finset.mem_union_left _ (Finset.mem_image.mpr ⟨(x, y), Finset.mem_product.mpr ⟨hx, hy⟩, hxy⟩)
  have : NeZero n := ⟨hn0⟩
  have hcount := count S hu he
  set k := S.card with hkdef
  have hnk : n = k * k - k + 1 := by omega
  have h0 := hmem 0 (hA (by simp)); have h1 := hmem 1 (hA (by simp))
  have h3 := hmem 3 (hA (by simp)); have h11 := hmem 11 (hA (by simp))
  push_cast at h0 h1 h3 h11
  have hk4 : 4 ≤ k := by
    have : ({0, 1, 3, 11} : Finset ℕ).card ≤ B.ncard := by
      rw [← Set.ncard_coe_finset]
      apply Set.ncard_le_ncard _ hfin
      intro x hx; apply hA; simpa using hx
    have hc : k = B.ncard := hcard
    simp at this; omega
  have hn13 : 13 ≤ n := by have := Nat.mul_le_mul_right k hk4; omega
  have hkk : k * k - k = k * (k - 1) := by rw [Nat.mul_sub_one]
  have hlit : ∀ m : ℕ, 0 < m → m < 13 → (m : ZMod n) ≠ 0 :=
    fun m hm hm13 => lit_ne m hm (by omega)
  have h2 : (2 : ZMod n) ≠ 0 := by exact_mod_cast hlit 2 (by norm_num) (by norm_num)
  have h3ne : (3 : ZMod n) ≠ 0 := by exact_mod_cast hlit 3 (by norm_num) (by norm_num)
  have h4 : (4 : ZMod n) ≠ 0 := by exact_mod_cast hlit 4 (by norm_num) (by norm_num)
  have h8 : (8 : ZMod n) ≠ 0 := by exact_mod_cast hlit 8 (by norm_num) (by norm_num)
  rcases hdiv with hd2 | hd3
  · -- order divisible by 2: 2 is a multiplier
    have hd2' : 2 ∣ k - 1 := by rw [hcard]; exact hd2
    have hcop : Nat.Coprime 2 n := by
      rw [Nat.Prime.coprime_iff_not_dvd Nat.prime_two]
      have : 2 ∣ k * (k - 1) := Dvd.dvd.mul_left hd2' k
      omega
    have hpu : IsUnit ((2 : ℕ) : ZMod n) := (ZMod.isUnit_iff_coprime 2 n).mpr hcop
    have : Fact (Nat.Prime 2) := ⟨Nat.prime_two⟩
    obtain ⟨s0, hs0⟩ := hall S hu he 2 hd2' (by omega) hnk hpu
    have m0 := hs0 0 h0; have m1 := hs0 1 h1; have m3 := hs0 3 h3
    push_cast at m0 m1 m3
    have e1 := hu _ m1 _ m0 _ h3 _ h1 (by ring) (by intro h; apply h2; linear_combination h)
    have hs : s0 = -1 := by linear_combination -e1.1
    rw [hs] at m3
    have e2 := hu _ h11 _ m3 _ m3 _ h3 (by ring) (by intro h; apply h4; linear_combination h)
    apply h4; linear_combination e2.1
  · -- order divisible by 3: 3 is a multiplier
    have hd3' : 3 ∣ k - 1 := by rw [hcard]; exact hd3
    have hcop : Nat.Coprime 3 n := by
      rw [Nat.Prime.coprime_iff_not_dvd Nat.prime_three]
      have : 3 ∣ k * (k - 1) := Dvd.dvd.mul_left hd3' k
      omega
    have hpu : IsUnit ((3 : ℕ) : ZMod n) := (ZMod.isUnit_iff_coprime 3 n).mpr hcop
    have : Fact (Nat.Prime 3) := ⟨Nat.prime_three⟩
    obtain ⟨s0, hs0⟩ := hall S hu he 3 hd3' (by omega) hnk hpu
    have m0 := hs0 0 h0; have m1 := hs0 1 h1; have m3 := hs0 3 h3
    push_cast at m0 m1 m3
    have e1 := hu _ m1 _ m0 _ h3 _ h0 (by ring) (by intro h; apply h3ne; linear_combination h)
    have hs : s0 = 0 := by linear_combination -e1.1
    rw [hs] at m3
    have e2 := hu _ m3 _ h1 _ h11 _ h3 (by ring) (by intro h; apply h8; linear_combination h)
    apply h2; linear_combination -e2.1
