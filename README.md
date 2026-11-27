# VibesCode-Math

Machine-checked results in number theory. Every claim here comes with something you can rerun: a Lean 4 proof checked by the kernel, or an exact computation with its code and log. Each result says exactly what is proved, what is only computed, and what stays open.

## Headline result

**An explicit form of Ono's Corollary 1.2, fully checked in Lean.**

Let x_n = tan(arctan 1 + arctan 2 + ⋯ + arctan n). For every n ≥ 5 outside Ono's exceptional set E = {n ≥ 5 : |x_n| > n/2 + 1}, x_n is not an integer.

K. Ono (arXiv:2607.05739, July 2026) proved this for n ≥ n₀, with an n₀ that is effective but not given. Here **n₀ = 5**. The whole proof is checked by the Lean kernel against the statement in DeepMind's [formal-conjectures](https://github.com/google-deepmind/formal-conjectures), and it uses only the standard axioms.

What it does not do: it does not settle the Amdeberhan–Medina–Moll conjecture that x_n is never an integer for n ≥ 5. It says nothing about n in E, and E is not known to be finite. The mathematics builds on Ono's lemmas. What is new is the explicit constant and a complete machine-checked proof.

Details: [`tan-arctan-explicit/RESULT.md`](tan-arctan-explicit/RESULT.md).

## All results

This list grows as new results pass their checks. Each one states exactly what it covers.

### Main results

| Result | Claim | Status |
| --- | --- | --- |
| [Explicit Ono Corollary 1.2](tan-arctan-explicit/RESULT.md) | For n ≥ 5 outside E, tan(arctan 1 + ⋯ + arctan n) is not an integer. | **Proved** in Lean 4 + Mathlib |
| [Erdős 707, Mueller's four-element sets](erdos-707/RESULT.md) | Peter Mueller's sets {0,1,3,11} and {0,1,4,11} (MathOverflow 502053), which lie in no Singer difference set, also lie in no perfect difference set of even order. {0,1,3,11} also lies in none whose order is divisible by 3. Both hold for any modulus, with no prime-power or Desarguesian assumption. For {0,1,3,11} the even-order case was noted by Mueller, following the Hall–Baer arguments of Alexeev and Mixon. New here: even order for {0,1,4,11}, order divisible by 3 for {0,1,3,11}, and a complete Lean formalization, including Hall's multiplier theorem for planar difference sets. | **Proved** in Lean 4 + Mathlib, as a partial result. The four-element question stays **open**. |
| [Huber's Sidon problem, s(17) = 96](huber-sidon/RESULT.md) | The largest Sidon subset of the distinct multinomial coefficients n!/(p₁!⋯p_t!) has size s(16) = 83 (Huber's value, now with a checkable certificate) and s(17) = 96. This answers the first part of Huber's Question 14.3 (arXiv:2608.02667) and extends OEIS A398429 by one term; the previous bound was s(17) ≥ 89. | **Computed and certified.** Lower bounds: explicit Sidon sets, **kernel-checked in Lean 4**. Upper bounds: SAT unsatisfiability proofs verified by independent proof checkers (LRAT and DRAT), with independent encodings and solvers; not Lean-checked. A finite computation, not a theorem about s(n) in general. |
| [Crystal uniqueness, partial results](crystal-uniqueness/RESULT.md) | For the crystal-components conjecture of Abrate, Barbero, Cerruti and Murru (arXiv:1601.03081, formal-conjectures `crystals_components_unique`): (1) no number is a crystal at two different addresses on chains k, k' ≤ 1000; (2) two chains whose units lie in the same real quadratic field never share a crystal, at any positions and with no bound on k; (3) no number is a crystal at position 1 of one chain and position 4 of another. (1) uses Matveev's lower bound for linear forms in three logarithms, a Baker–Davenport reduction and an exact check, in rigorous interval arithmetic with independent implementations; for the chain k = 4 a collision gives a generalized Pell equation whose solution classes were computed by two independent methods; (2) is an elementary size argument; (3) is a polynomial squeeze plus a finite check. The reduction of the conjecture to injectivity of (k, t) ↦ n_t(k) is checked in Lean. | **Partial result.** (1)–(3) are computer-assisted or written proofs, **not Lean-checked**; the reduction is **Proved** in Lean 4 + Mathlib. A second address on a chain k' > 1000 is not excluded, and the conjecture stays **open**. |

Supporting computation for the tangent theorem: an [exact check](tan-arctan-sum/RESULT.md) that tan(arctan 1 + ⋯ + arctan n) is not an integer for every 5 ≤ n ≤ 1.2·10⁸. It covers the members of E in that range, which the theorem leaves aside, including the twelve cases of Ono's Remark 3.3. The conjecture itself stays open.

### Smaller results

| Result | Claim | Status |
| --- | --- | --- |
| [Covering array CA(179; 3, 39, 4)](covering-array-ca179/RESULT.md) | An explicit covering array with 179 rows, 39 columns, 4 symbols and strength 3, so CAN(3, 39, 4) ≤ 179. The best known bound was 180 (Seonbin Kim, Nov 2026, in the ca-tools table), and Colbourn's tables (Nov 2024 snapshot) gave 186. An upper bound only: no lower-bound or optimality claim. A modest record on one table entry. Found by computer search; the array file and a small standalone checker are included. | **Verified** by exhaustive check of all 9139 column triples in independent programs; computer-found, **not formally verified**. |
| [OEIS A135508, McEachen's conjecture](oeis-a135508/RESULT.md) | McEachen's conjecture (OEIS A135508, formal-conjectures `OeisA135508.conjecture`) says a(p − 1) = p for every prime p with p − 2 not prime. We prove it for every such p where p − 2 has a prime factor below 400, an infinite family, and so for every prime p < 160,000. Earlier checks went to p < 20,000. The key reduction is due to others (Cloitre, arXiv:2510.18891, and public Lean work), as credited. | **Proved** in Lean 4 + Mathlib, as a partial result. The remaining primes stay **open**. |
| [OEIS A245212, squarefree odd part](oeis-a245212/RESULT.md) | The conjecture recorded in OEIS A245212 (formal-conjectures `OeisA245212.conjecture`) says a(n) = σ(n) exactly when n is a power of 2. We prove it when the odd part of n is squarefree. It is a short parity argument. We found no earlier proof, but it may be folklore. | **Proved** in Lean 4 + Mathlib, as a partial result. The other cases stay **open**. |
| [OEIS A120121–A120123, 139968 is the largest term](oeis-a120121/RESULT.md) | The numbers m equal to φ(P·S), φ(P)·S and P·φ(S), where P and S are the product and sum of m's decimal digits, are exactly {1, 2, 64, 384, 139968}, {1, 2, 24, 139968} and {1, 2, 672, 34992, 139968}. This proves the conjecture in all three entries (Firoozbakht, 2006) that 139968 is the largest term. A term has no zero digit and at most 84 digits (Bottomley's bound for A049101, 2000); an exhaustive search over digit multisets finishes it. The method is standard. | **Proved**: the digit bound in Lean 4 + Mathlib; the search by exact computation in several independent programs. |
| [OEIS A058627, φ(n) = product of digits](oeis-a058627/RESULT.md) | The 15 known terms 1, 24, …, 68796 of A058627 (Robert G. Wilson v, 2000) are all, so a(16) does not exist, closing the window 10¹³ < a(16) < 10⁶⁴ stated by G. Resta (2014). If φ(n) equals a digit product, every prime p dividing n has p − 1 7-smooth, so n/φ(n) < 8.2586 (exact computation with a rigorous tail bound); this limits terms to 41 digits (36 with a 2-adic refinement), and an exhaustive inverse-totient search by independent programs finds no further term. | **Computed**: elementary proof plus exhaustive search, computer-assisted; **not formally verified**. |
| [OEIS A379397–A379400, sums of nine cubes](oeis-a379397/RESULT.md) | The numbers with exactly k = 2, 3, 4, 5 representations as a sum of at most nine positive cubes (A379397–A379400) are finite sets, and the listed terms are complete. This proves Greathouse's conjecture that 455 is the last term of A379399. For each k every such n is below 240 + (9k+1)³, by Dickson's theorem; an exhaustive count finishes it. A direct extension of Alper Ferudun's argument for A379396 (k = 1). The same method gives complete lists for every k ≤ 20. | **Proved**: the counting step in Lean 4 + Mathlib with Dickson's theorem (1939) as an explicit hypothesis; the finite part by exact computation in several independent programs. |
| [OEIS A066494 and A066516, prime gaps and φ(n)](oeis-a066494/RESULT.md) | A066494 (prime(n+1) − prime(n) = φ(n)) is exactly {1, 3, 8, 9, 12, 18, 24}, and A066516 (g(σ(n)) = φ(n)) is exactly {1, 4, 5, 15, 18, 30, 36}, unconditionally. For A066516 the OEIS had this only on the Riemann hypothesis. For n ≥ 688,383, explicit bounds of Dusart and of Rosser–Schoenfeld force the gap below φ(n). The method is standard; the new part is only the explicit, complete closure. | **Proved**: the reduction in Lean 4 + Mathlib with the three published bounds as explicit hypotheses; n < 688,383 by exact computation in two independent programs. |
| [Sorting networks, Van Voorhis's recurrence](sorting-network-size/RESULT.md) | A Lean 4 formalization of Van Voorhis's 1972 recurrence for the size of sorting networks: s(n) ≥ s(n−1) + ⌈log₂ n⌉, where s(n) is the minimum number of comparators in a sorting network on n inputs. Combined with Harder's verified value s(11) = 35 (given as an explicit hypothesis), it yields the lower bounds s(12) ≥ 39, …, s(32) ≥ 135 listed in Dobbelaere's table. This is a formalization of a known theorem; it gives no new bound. We found no earlier formal proof of this recurrence. | **Proved** in Lean 4 + Mathlib (standard axioms); s(11) ≥ 35 is an explicit hypothesis. |

### What each result cost to find

Measured usage of the Claude sessions that worked on each result, including dead ends and checks. Shared work, such as rechecking every result, searching for problems and preparing this repository, is listed separately in [TOKENS.md](TOKENS.md), which also says exactly what each number covers.

Each cell is tokens processed, with the output tokens (written by the model, reasoning included) in brackets.

| Result | Total | Claude Opus 5.5 | Claude Sonnet 5.5 | Claude Haiku 5.5 | Claude Fable 5.2 |
| --- | --- | --- | --- | --- | --- |
| Tangent sum, explicit n₀ = 5 | **45.6M** (490k out) | 39.1M (287k out) | 5.3M (90k out) | 0.7M (87k out) | 0.6M (25k out) |
| Erdős 707 (Mueller's sets) | **20.8M** (251k out) | 18.3M (170k out) | 2.0M (25k out) | 0.5M (55k out) | not used |
| Huber's Sidon problem, s(16), s(17) | **12.9M** (73k out) | 11.3M (44k out) | 1.6M (24k out) | 0.1M (4k out) | not used |
| Crystal uniqueness (partial) | **51.9M** (538k out) | 43.4M (343k out) | 7.8M (154k out) | 0.8M (42k out) | not used |
| OEIS A135508 | **11.0M** (80k out) | 9.5M (61k out) | 1.4M (9k out) | 0.1M (11k out) | not used |
| OEIS A245212 | **8.3M** (67k out) | 7.6M (56k out) | 0.7M (6k out) | 0.1M (5k out) | not used |
| OEIS A120121–A120123 and A058627 | **14.5M** (164k out) | 11.9M (87k out) | 2.6M (73k out) | <0.1M (4k out) | not used |
| OEIS A379397–A379400 | **5.0M** (56k out) | 3.4M (25k out) | 1.4M (17k out) | 0.2M (13k out) | not used |
| OEIS A066494 / A066516 | **8.0M** (114k out) | 5.3M (48k out) | 2.5M (44k out) | 0.3M (22k out) | not used |
| Sorting networks, Van Voorhis's recurrence | **13.2M** (141k out) | 10.9M (86k out) | 1.8M (21k out) | 0.4M (34k out) | not used |
| Covering array CA(179; 3, 39, 4) | **15.1M** (102k out) | 14.4M (72k out) | 0.5M (9k out) | 0.3M (21k out) | not used |

## Layout

```
VibesCodeMath/TanArctanExplicit/
  Challenge.lean   the statement, exactly as in formal-conjectures (ends in sorry)
  Solution.lean    the proof
  Verify.lean      restates the claim, proves it from Solution.lean, prints the axioms used
tan-arctan-explicit/   write-up, plus scripts that check the definitions and show where the constants came from
tan-arctan-sum/        the exact computation to 1.2·10⁸: C and Python code, logs
VibesCodeMath/Erdos707/      Challenge, Solution, Verify for the Erdős 707 result
erdos-707/             write-up and a check that the definition is satisfiable
VibesCodeMath/OeisA135508/   Challenge, Solution, Verify for the A135508 result
oeis-a135508/          write-up and definition check
VibesCodeMath/OeisA245212/   Challenge, Solution, Verify for the A245212 result
oeis-a245212/          write-up, definition check and search code
VibesCodeMath/HuberSidon/   the Lean-checked Huber witnesses (core Lean checker), and Verify
huber-sidon/           write-up, witnesses, CNF generators and files, solver and checker logs
VibesCodeMath/CrystalUniqueness/   the Lean-checked reduction for the crystal conjecture, and Verify
crystal-uniqueness/    write-up, written proofs (proofs/) and the certifying programs with logs (scripts/)
VibesCodeMath/OeisA379397/   the counting step (Dickson's theorem as a hypothesis), and Verify
oeis-a379397/          write-up and the counting programs with logs
VibesCodeMath/OeisA066494/   Challenge, Solution, Verify for the A066494/A066516 reduction
oeis-a066494/          write-up and the check programs with logs
VibesCodeMath/OeisA120121/   Challenge, Solution, Verify for the A120121–A120123 digit bound
oeis-a120121/          write-up and the search programs with logs
oeis-a058627/          write-up and three search programs with logs (no Lean)
VibesCodeMath/SortingSize/   Basic (definitions), Challenge, Solution, Verify for the sorting-network recurrence
sorting-network-size/  write-up and an independent Python check with its output
covering-array-ca179/  the array CA(179; 3, 39, 4), its hash, two standalone checkers and the write-up (no Lean)
check.sh               reruns everything
TOKENS.md              measured token usage and models for each result
palomar/tan-arctan-explicit/   the headline theorem as a standalone package for the Palomar registry
palomar/erdos707-mueller-sets/  the Erdős 707 result as a standalone package for the Palomar registry
                               (both: Lean v4.35.0, Mathlib only, checked with Comparator)
```

## Build and check

Toolchain: Lean 4 v4.33.1, Mathlib v4.33.1, formal-conjectures at commit `9097e2f`. All three are pinned in `lean-toolchain`, `lakefile.toml` and `lake-manifest.json`.

```bash
git clone https://github.com/VibesCode/VibesCode-Math && cd VibesCode-Math
lake exe cache get   # download the Mathlib build cache
lake build
```

`lake build` prints the axioms of each result's `Verify.lean` check, and every one should read `[propext, Classical.choice, Quot.sound]`. The only `sorry`s are in the `Challenge.lean` files, which hold the statements on their own. Some results take cited theorems as explicit hypotheses of the Lean statement (Dickson's theorem for A379397–A379400; Dusart's and Rosser–Schoenfeld's bounds for A066494/A066516). Those hypotheses are visible in the statements and are not axioms.

Memory: the A135508 proof has the Lean kernel check a finite table, which needs about 10 GB of free memory. Everything else builds in ordinary memory.

The headline theorem and the Erdős 707 result are also packaged on their own, in [`palomar/tan-arctan-explicit/`](palomar/tan-arctan-explicit/README.md) and [`palomar/erdos707-mueller-sets/`](palomar/erdos707-mueller-sets/README.md). Each package uses Lean v4.35.0 and Mathlib only, with formal-conjectures' definitions copied in verbatim, and is checked with `lake comparator` (see its README). Each is a separate Lake project from the one at the repository root.

To rerun the computations as well, run `bash check.sh`. It needs a C compiler and Python 3. The crystal box programs take longer and are run separately (see [`crystal-uniqueness/RESULT.md`](crystal-uniqueness/RESULT.md)); they need mpmath and python-flint.

## What counts as a result here

- **Proved** means a Lean 4 proof that the kernel accepts. It has no `sorry`, adds no axioms, and `#print axioms` shows nothing beyond `propext`, `Classical.choice` and `Quot.sound`.
- **Computed** means exact integer or modular arithmetic, with the code, the command and the log, cross-checked against an independent method.

## Who's behind this

I'm VibesCode. I'm not a mathematician. I'd call what I do *reasoning engineering*: I direct AI systems toward open problems, and nothing is published here until a proof checker or an independent computation has confirmed it.

I believe the door is open now. Anyone with curiosity and creativity can contribute to mathematics, with or without a degree, as long as the work can be verified. Every result in this repo can be verified.

The work is AI-assisted, using Claude. The mathematics we build on is credited in each result.

## License

Apache-2.0. See [LICENSE](LICENSE).
