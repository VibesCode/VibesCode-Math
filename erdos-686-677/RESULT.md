# Erdős problems 686 and 677: search bounds

- [Erdős problem 686](https://www.erdosproblems.com/686) asks which integers N ≥ 2 can be written as (m+1)(m+2)…(m+k) / ((n+1)(n+2)…(n+k)) with m ≥ n + k. The cases N = 4 and N = 25 are open.
- [Erdős problem 677](https://www.erdosproblems.com/677) asks whether lcm(n+1, …, n+k) = lcm(m+1, …, m+k) is impossible for m ≥ n + k.

Both problems are open, and the site notes they cannot be settled by a finite computation. What follows are search bounds, not proofs.

## The result

For N = 4 and N = 25 and every 3 ≤ k ≤ 20, the equation (m+1)…(m+k) = N(n+1)…(n+k) has no solution with m ≥ n+k and n + (k+1)/2 ≤ 10^1000. For every 3 ≤ k ≤ 16, no two disjoint windows of k consecutive integers with n + (k+1)/2 ≤ 10^100 have equal lcm. These are computer-assisted search bounds from independent programs (continued fractions with the Worley–Dujella theorem; exact Stern–Brocot walks), not proofs; both problems remain open. Prior work: for odd k = 5..13 a larger bound (10^10000) was already reported by hyun-J-O/erdos-problems with the same method; small k are settled or claimed (N = 4, k ≤ 4; N = 25, k = 2, 4; forum claims for k = 6, 8, 12); for 677, k = 3 is settled (Chan, arXiv:2408.01306), k = 5 is claimed proved (k4its1t/erdos-677-length-five, unrefereed, with a search to 10^100000) and k = 6 is claimed proved (MaxwellLaw/erdos-677-research, unrefereed), the reduction to products is prior work, and the previous largest search is laaielichter/erdos-677 (k ≤ 100, m+k ≤ 10^8). New here, as far as we found: N = 25, k = 3, and k = 6..20 even plus k = 15, 17, 19 for both N, and the 677 range k = 7..16 to 10^100.

**Status:** **computer-assisted** search bounds, **not formally verified**, with no Lean. For odd k = 5..13 our 686 bound is weaker than the one already published, and for 677 the cases k = 5 and 6 are claimed proved elsewhere, so ours adds nothing there.

## How the search works

Write P(t) = (t+1)…(t+k), X = n + (k+1)/2 (the centre of the window), M = m + (k+1)/2, h = (k−1)/2 and S₂ = (k³ − k)/12. Both problems reduce to v·P(m) = u·P(n) with m ≥ n + k for a fixed ratio ρ = u/v > 1. Let c = ρ^(1/k).

1. **A centred inequality.** Expanding log P(t) around the centre, the odd terms cancel, so P(t) = T^k·exp(g(T)) with g(T) negative and increasing towards 0. From this, any solution with X > X₀ satisfies 0 < c − M/X < B/X², where B = (c·S₂/2k)·(1/(1 − h²/X₀²) − 1/c²). Multiplying through by s = 2 when k is even makes M/X a fraction of integers. So M/X must be an unusually good rational approximation of c from below.
2. **Small X.** Each factor (m+i)/(n+i) decreases in i, which gives a narrow band c(n+1) − 1 < m < c(n+k) − k for m. All small cases are searched directly, either through this band or by brute force.
3. **Large X, two ways.**
   - *Continued fractions:* by Worley's theorem in Dujella's form (arXiv:cs/0402052, Theorem 1), every fraction that close to c is built from consecutive convergents with small coefficients. Each candidate is then tested exactly.
   - *Stern–Brocot walk:* a walk down the Stern–Brocot tree drops a subtree only when exact integer comparisons of k-th powers show that no fraction in it can be close enough to c. This needs no cited theorem, and it is exact even when c is rational.
4. **From 677 to products.** Let R(n) = P(n)/lcm(n+1..n+k). Only prime powers below k contribute to R, so R is periodic modulo lcm(1, …, k−1). Its finitely many values are found by computing one full period. Equal lcms force P(m)/P(n) = R(m)/R(n), so every ratio of two R-values is solved as above, and each product solution is tested for equal lcm. This reduction is prior work. Its periodicity goes back to Farhi and Kane.

## Evidence: three programs

- **Continued fractions**, in [`scripts/cf/`](scripts/cf/): [`ratio_cf.py`](scripts/cf/ratio_cf.py), with drivers [`run686.py`](scripts/cf/run686.py) and [`run677.py`](scripts/cf/run677.py). It covers small X with the band search to X ≤ 10^4, and large X with continued fractions and Worley's theorem.
  - Logs: [`logs/cf-run686-1000.log`](logs/cf-run686-1000.log), [`logs/cf-run677.log`](logs/cf-run677.log) and [`logs/cf-run677b.log`](logs/cf-run677b.log).
  - Controls: [`control.py`](scripts/cf/control.py) checks that the band and the continued fractions agree. [`control3.py`](scripts/cf/control3.py) plants 300 random solutions, and all 300 are found.
  - The rule that decides when to stop enumerating convergents was not checked independently. The bounds therefore also rest on the other two programs, which do not use it.
- **Stern–Brocot walk**, in [`scripts/walk/`](scripts/walk/): [`second.py`](scripts/walk/second.py) with [`second_run.py`](scripts/walk/second_run.py). It uses a looser constant with a rational upper bound for c, exact brute force for X ≤ 3000, and the walk above that.
  - For 677 it computes R by a counting formula. That formula matches P/lcm on every n of a full period and 2000 more.
  - Logs: [`logs/walk-second686.log`](logs/walk-second686.log) (N = 4), [`logs/walk-second686-25a.log`](logs/walk-second686-25a.log) and [`logs/walk-second686-25b.log`](logs/walk-second686-25b.log) (N = 25), and [`logs/walk-second677.log`](logs/walk-second677.log).
  - Control: [`second_control.py`](scripts/walk/second_control.py) plants 200 solutions and finds all 200, and agrees with brute force on 12 small solutions.
- **A third program**, in [`scripts/third/`](scripts/third/), was written separately from the other two. [`mine.py`](scripts/third/mine.py) uses an exact band search for small n, then a Stern–Brocot walk with its own constant and exact integer tests. [`mine677.py`](scripts/third/mine677.py) computes R directly over one period, spot-checks periodicity at 300 random n up to 10^30, solves every ratio to X ≤ 10^100, and brute-forces lcms directly for n ≤ 1000.
  - Logs: [`logs/third-run686.txt`](logs/third-run686.txt) and [`logs/third-run677.txt`](logs/third-run677.txt).
  - All 36 cases of 686 have no solution with m ≥ n + k. The only solutions it reports are overlapping ones for N = 4 when k is divisible by 3, such as (n, m) = (0, 1) for k = 3. Those have m < n + k, so the problem excludes them. All 14 widths of 677 are empty.

All three programs agree on every case. `check.sh` reruns the planted-solution controls of the first two programs, the third program for N = 4, k = 3 up to X ≤ 10^50 (where it must find only the overlapping (0, 1)), and its 677 run for k = 7. The full runs take from minutes (continued fractions) to about 1.5 hours (walk), in plain Python 3 with no packages.

## Prior work and freshness

- **686.**
  - hyun-J-O/erdos-problems reports no solution for N ∈ {4, 25, 49, 64, 81} and odd k = 5, 7, 9, 11, 13 with n + (k+1)/2 < 10^10000, and up to 10^100000 for N = 4, k = 5. It uses the same method.
  - kdahab2000/erdos-169-686-certificates searched k = 3 for n ≤ 5·10^6, and k ≤ 200 for n ≤ 5·10^4.
  - The google-deepmind/formal-conjectures project records N = 4 with k = 2, 3 as solved. An open pull request there (#7915) gives Lean proofs for N = 25 with k = 2, and for N = 4 and N = 25 with k = 4.
  - The problem's forum lists claims for k = 6, 8 and 12. We could not read the forum.
- **677.**
  - k = 3 is settled (T. H. Chan, arXiv:2408.01306).
  - k = 4 is claimed in hyun-J-O/erdos-problems.
  - k = 5 is claimed proved in k4its1t/erdos-677-length-five, including a continued-fraction search to 10^100000. Its Lean formalization is partial. The claim is unrefereed.
  - k = 6 is claimed proved in MaxwellLaw/erdos-677-research. This claim is also unrefereed.
  - laaielichter/erdos-677 checked 3 ≤ k ≤ 100 with m + k ≤ 10^8.
- Searches on 2026-11-28 found no bound at our size for even k = 6..20, for odd k = 15, 17, 19, for N = 25 with k = 3, or for the 677 range k = 7..16. Nothing has been posted to erdosproblems.com.
