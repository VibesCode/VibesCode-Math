# Huber's Sidon problem for multinomial coefficients: s(16) = 83 certified, s(17) = 96

**Status: two new exact values, by a certified finite computation.** This is not a theorem about s(n) in general.

## The problem

F. Huber, "Large Sidon Subsets and Pair-Sum Multiplicities of Distinct Multinomial Coefficients", [arXiv:2608.02667](https://arxiv.org/abs/2608.02667) (v2, Aug 2026), and OEIS [A398429](https://oeis.org/A398429) (Felix Huber, Aug 2026).

- M_n is the set of **distinct** values n!/(p₁!⋯p_t!) over all partitions p₁ + ⋯ + p_t = n, p₁ ≥ ⋯ ≥ p_t ≥ 1. It includes 1 and n!. |M_16| = 157 and |M_17| = 193.
- A set S of integers is **Sidon** if every equality x + y = u + v with x, y, u, v ∈ S is trivial ({x, y} = {u, v}). Equal summands are allowed, so 2a = b + c is a collision.
- s(n) is the size of a largest Sidon subset of M_n.

Huber computed s(1), …, s(16) (ending 66, 83) by SAT solving in Maple, and found a Sidon subset of M_17 with 89 elements. The paper says that "no solver-independent certificate for the SAT optimality computations is presently included". Its Question 14.3 asks: "Determine s(17) and compute further exact values."

## The result

- **s(17) = 96.** This answers the first part of Huber's Question 14.3 and extends A398429 by one term.
- **s(16) = 83, now with a checkable certificate.** Huber's value, independently confirmed.

## What is checked how

| Claim | How it is checked |
| --- | --- |
| s(16) ≥ 83, s(17) ≥ 96 | **Kernel-checked in Lean 4.** Explicit Sidon sets of sizes 83 and 96, each element with a partition certifying membership in M_n: [`VibesCodeMath/HuberSidon/`](../VibesCodeMath/HuberSidon/). `Verify.lean` restates both with Mathlib's `Nat.factorial` and the definitions written out, and prints `[propext, Classical.choice, Quot.sound]`. The checks run by `decide +kernel`, without `native_decide`. |
| s(16) ≤ 83, s(17) ≤ 96 | **Certified by SAT proof checkers, not by Lean.** The statement "M_n has no Sidon subset of size s + 1" is encoded as a CNF formula, which the solver reports unsatisfiable. The proof of unsatisfiability is then verified by an independent proof checker. |

The upper bounds use three CNF encodings written separately, two solvers and two proof checkers:

| Encoding | n = 16 (no Sidon set of size 84) | n = 17 (no Sidon set of size 97) |
| --- | --- | --- |
| 1: delete-variables over the "active" elements, one clause per inclusion-minimal collision, at most τ − 1 deletions (Sinz counter); `code/inst.py`, `code/cnf.py` | CaDiCaL: UNSAT; proof checked by drat-trim (DRAT) and lrat-check (LRAT): VERIFIED | CaDiCaL: UNSAT; 1.8 GB LRAT proof checked by lrat-check: VERIFIED (twice, on separate runs) |
| 2: keep-variables over all of M_n, M_n built from products of binomials, every collision with no minimality filter, at least L kept (totalizer); `code/enc2.py` | kissat: UNSAT; DRAT proof checked by drat-trim: VERIFIED | kissat: UNSAT; 3.7 GB DRAT proof checked by drat-trim: VERIFIED |
| 3: keep-variables, one clause per nontrivial collision, cardinality network (pysat); `code/check_independent.py` | CaDiCaL: UNSAT; 1.6 GB LRAT proof checked by lrat-check: VERIFIED | CaDiCaL: UNSAT (proof not kept: it outgrew the disk) |

Why UNSAT gives the upper bound (encoding 1): a Sidon set A ⊆ M_n with |A| = s + 1 makes D = M_n \ A meet every collision, since every collision contains a minimal one, with at most τ − 1 deleted active elements, where τ = |M_n| − s. That satisfies the CNF. Encodings 2 and 3 say "at least s + 1 kept, no collision fully kept" directly.

Also: every s(n) for 5 ≤ n ≤ 15 was reproduced by encodings 1 and 2, with every UNSAT proof DRAT-checked (`code/run_ctl.sh`, `code/run2.sh`). The witnesses for those n are in `witnesses/`.

## Regenerate and verify the upper-bound proofs

The proof files are gigabytes, so they are not in the repository. The CNF files are (`cnf/`), and the generators reproduce them byte for byte. SHA-256 of the CNFs and of our proof files are in `certs/sha256.txt`. A solver run on another machine or build may produce a different, equally valid proof.

Tools, built from source at the commits in `certs/tool-commits.txt`: CaDiCaL `e4d9bd9`, kissat `8af8e56`, drat-trim and lrat-check `2e3b2dc`.

```bash
cd huber-sidon/code
python3 cnf.py 17 96 c17-k96.cnf        # encoding 1, n = 17: at most 96 deletions (|M_17| = 193); same bytes as cnf/c17-k96.cnf
cadical -q --lrat=true --no-binary c17-k96.cnf p17.lrat     # UNSAT, about 7 minutes, proof about 1.8 GB
lrat-check c17-k96.cnf p17.lrat                              # c VERIFIED, about 30 s (see certs/lc17.log)

python3 enc2.py 17 97 e17-uns.cnf       # encoding 2, n = 17: at least 97 kept; same bytes as cnf/e17-uns.cnf
kissat -q --no-binary e17-uns.cnf q17.drat                   # UNSAT, about 19 minutes, proof about 3.7 GB
drat-trim e17-uns.cnf q17.drat -t 100000                     # s VERIFIED, about 33 minutes (see certs/dt-e17.log)

python3 cnf.py 16 73 c16-uns.cnf        # n = 16: at most 73 deletions (|M_16| = 157); same bytes as cnf/c16-uns.cnf
cadical -q --lrat=true --no-binary c16-uns.cnf p16.lrat && lrat-check c16-uns.cnf p16.lrat   # see certs/lc16.log
```

Witnesses: `python3 code/check.py 17 witnesses/s17.txt` regenerates M_17 and checks membership and that all pair sums are distinct. `witnesses/s17-alt-enc2.txt` is a second, different 96-element Sidon set found with encoding 2. Rerun the Lean check with `lake build` from the repository root.

Run times on a 4-core cloud machine: n = 16, under a minute per solver. n = 17: 6–7 minutes (CaDiCaL), 19 minutes (kissat). Memory under 1 GB.

## Files

- `witnesses/`: optimal Sidon sets for 5 ≤ n ≤ 17, a second one for n = 17, and a 119-element set for n = 18 (a lower bound only).
- `code/`: the M_n generator and collision hypergraph (`inst.py`), encodings 1–3 (`cnf.py`, `enc2.py`, `check_independent.py`), witness extraction (`wit.py`, `wit2.py`, `solvewit.sh`), the witness checker (`check.py`) and the run scripts.
- `cnf/`: the CNF files used, SAT and UNSAT instances for n = 16 and 17.
- `certs/`: solver and checker logs, SHA-256 hashes, tool commits.

## Credits and novelty

The problem, the definitions, the values through n = 16, the bound s(17) ≥ 89 and the active-vertex reduction are Felix Huber's (arXiv:2608.02667, OEIS A398429). The paper credits no earlier source for the question. We found no value of s(17) above 89 and no certificate for s(16) anywhere: not in the OEIS entry, arXiv, citing papers (none were found), GitHub, MathOverflow/math.SE or the web, as of Nov 27 2026.

Solvers and checkers: CaDiCaL and kissat (Biere et al.), drat-trim and lrat-check (Heule et al.).

## What is open

- s(18): a 119-element Sidon subset of M_18 exists (`witnesses/s18-lower119.txt`, |M_18| = 243), so s(18) ≥ 119. No certified upper bound yet.
- Huber's asymptotic questions (14.1, 14.2, 14.4, 14.5) are untouched.
