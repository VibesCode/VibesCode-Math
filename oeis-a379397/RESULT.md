# OEIS A379397–A379400 are finite, and their listed terms are complete

A *representation* of n ≥ 1 is a multiset of 1 to 9 positive integers whose cubes sum to n (order ignored, repeats allowed). Write r(n) for the number of representations. For k = 2, 3, 4, 5 the OEIS sequences A379397, A379398, A379399, A379400 (Patrick De Geest, Dec 2024) list the n with r(n) = k: "Numbers that can be written in exactly k different ways as a sum of at most nine positive third powers". This reading matches the PARI program in the entries (David A. Corneth), which runs over nondecreasing 9-tuples with zeros as padding.

## The result

**A379397–A379400 are finite and their listed terms are complete:**

| Sequence | k | Terms | Last term |
| --- | --- | --- | --- |
| A379397 | 2 | 58 | 239 |
| A379398 | 3 | 61 | 303 |
| A379399 | 4 | 66 | 455 |
| A379400 | 5 | 54 | 429 |

In particular this proves Charles R Greathouse IV's conjecture (A379399, Dec 2024) that 455 is the last term of A379399.

For each k, every n with exactly k representations is below 240 + (9k+1)³. The reason is Dickson's theorem: every positive integer except 23 and 239 is a sum of at most eight positive cubes. So any larger n has a representation that contains c³, for each c = 1, …, 9k+1. One representation has at most nine distinct parts, so n has more than k representations. An exhaustive count below that bound finishes the proof.

This is a direct extension of Alper Ferudun's argument for the k = 1 sequence A379396 (OEIS comment, Oct 21 2026), which uses c = 1, …, 10. The same method shows completeness for every k ≤ 20 (table below).

## What rests on what

1. **Counting step: checked in Lean 4 + Mathlib.** [`VibesCodeMath/OeisA379397/Reduction.lean`](../VibesCodeMath/OeisA379397/Reduction.lean) proves `exactly_k_bounded`: if `DicksonEight` holds, then any n with exactly k representations satisfies n < 240 + (9k+1)³. Dickson's theorem is the **explicit hypothesis** `DicksonEight`. It is cited, not proved in Lean. `#print axioms` shows only `propext`, `Classical.choice` and `Quot.sound`.
2. **Dickson's theorem: cited.** L. E. Dickson, "All integers except 23 and 239 are sums of eight cubes", Bull. Amer. Math. Soc. 45 (1939) 588–591. We read the statement in S. Siksek, "Every integer greater than 454 is the sum of at most seven positive cubes", arXiv:1505.00647 (2015), where cubes are non-negative, so it means at most eight positive cubes. Siksek's theorem gives a second route: it covers m > 454, and our count confirms that the only m ≤ 5,929,981 that are not sums of at most eight positive cubes are 23 and 239.
3. **Finite part: exact computation.** r(n) is computed exactly for every n ≤ 5,929,981 = 240 + 181³, the bound for k = 20. Several independently written programs (below) agree with each other and with the OEIS data term by term.

## Programs ([`scripts/`](scripts/))

| Program | Method | Range and log |
| --- | --- | --- |
| `dp.py` | multiset DP by number of parts, pure Python | n ≤ 100,000: `dp-100000.log` |
| `dp_np.py` | the same recurrence, vectorised with numpy | n ≤ 5,929,981: `np-k20.log` |
| `enum.c` | brute-force enumeration of nondecreasing tuples | n ≤ 100,000: `enum-100000.log` |
| `dp2.c` | recursion on the largest part (Robert Israel's recurrence) | n ≤ 100,000 and n ≤ 5,929,981: `dp2-100000.log`, `dp2-k20.log` |
| `own_polya.py` | Pólya cycle index (h₉ of the cube multiset), arithmetic mod 2⁶⁴, compares with the OEIS data | n ≤ 100,000 |
| `count_by_parts.py` | a further numpy DP by number of parts, written separately | n ≤ 5,929,981 |

Up to 100,000 (beyond 240 + 46³ = 97,576, the k = 5 bound) the term lists for k = 1, …, 5 are identical across programs and equal the OEIS data, including A379396. Up to 5,929,981 the last term and count agree for every k ≤ 20.

Rerun, for example:

```bash
python3 oeis-a379397/scripts/dp_np.py 5929981 20      # compare with np-k20.log
cc -O2 -o dp2 oeis-a379397/scripts/dp2.c && ./dp2 5929981 20   # compare with dp2-k20.log
```

## Bonus: complete lists for every k ≤ 20

Largest n with exactly k representations (number of such n in brackets). Each list is complete by the same argument.

k = 1: 53 (32), 2: 239 (58), 3: 303 (61), 4: 455 (66), 5: 429 (54), 6: 492 (60), 7: 556 (57), 8: 708 (50), 9: 697 (56), 10: 771 (60), 11: 806 (60), 12: 797 (47), 13: 923 (53), 14: 1005 (51), 15: 1021 (56), 16: 1220 (57), 17: 1239 (50), 18: 1301 (52), 19: 1428 (47), 20: 1391 (49).

## Credits and status

The sequences are Patrick De Geest's, with programs and comments by David A. Corneth, Robert Israel and Charles R Greathouse IV. The idea is Alper Ferudun's argument for A379396, extended here from k = 1 to every k. This is a small result: an easy extension of a known argument, together with the exhaustive count that closes each case. We found no earlier proof for k ≥ 2 (search of the OEIS entries, GitHub and the web, Nov 27 2026).
