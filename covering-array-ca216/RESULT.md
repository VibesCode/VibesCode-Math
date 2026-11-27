# A covering array CA(216; 3, 11, 5): CAN(3, 11, 5) ≤ 216

## The result

[`CA_216_3_11_5.txt`](CA_216_3_11_5.txt) is an explicit covering array with **216 rows, 11 columns, 5 symbols and strength 3**. For every choice of 3 of the 11 columns, each of the 5³ = 125 possible triples of symbols appears in at least one row. So **CAN(3, 11, 5) ≤ 216**.

This improves the smallest value we could find for CAN(3, 11, 5): **218**, from C. Dzoba (October 2026, github.com/dzoba/covering-arrays-2026). Colbourn's November 2024 table lists 225.

**Status:**
- An **upper bound only**. Nothing is claimed about a lower bound or about optimality.
- The array was found by computer search.
- It is **verified by exhaustive checking with independent programs**, not by a proof assistant. There is no Lean for this result.

## The file

- 216 lines, one row per line. Each row has 11 symbols from {0, 1, 2, 3, 4}, separated by spaces. All rows are distinct.
- SHA-256: `d06c03e81d9a78fbcdd3c7e9434972cb61ef4533b42417d2b852031e1653badb` (also in [`CA_216_3_11_5.txt.sha256`](CA_216_3_11_5.txt.sha256)).

## Check it yourself

```
python3 scripts/check_ca.py CA_216_3_11_5.txt 216 3 11 5
```

[`scripts/check_ca.py`](scripts/check_ca.py) is plain Python 3 with no other packages. It reads the file strictly and checks all C(11, 3) = 165 column triples. Expected output:

```
shape 216x11, alphabet [0, 1, 2, 3, 4], column triples checked 165 (C(11,3)), failing 0, duplicate rows 0, min coverage multiplicity 1
COVERING ARRAY OK
```

[`scripts/check_ca_np.py`](scripts/check_ca_np.py) is a second implementation, using numpy. It also reports 0 failing triples.

The checkers do reject arrays that fail. Deleting any one row breaks the array (43 to 53 failing triples in the trials run), and so does changing a single entry. `check.sh` reruns the check together with one such negative control.

## Prior values and sources

- **218:** C. Dzoba, CA(218; 3, 11, 5), in github.com/dzoba/covering-arrays-2026 (repository created October 2026; the array is dated 2026-10-18). We checked that array with the checker above, and it is valid.
- **225:** Colbourn's covering array tables, November 2024 snapshot. That table has no row for 11 columns; the 225 comes from its 12-column row.
- The ca-tools table (github.com/chrispbsmolen/ca-tools, read 2026-11-27) has no entry at or below 224 for strength 3, 5 symbols and 11 or more columns.

**Sources we could not read:**
- Colbourn's live tables at Arizona State University, which now need a login. An archived copy could not be reached either.
- Arxiv and Zenodo, which blocked automated access.
- Older papers on strength-3 arrays, which we did not read in full.

A value below 218 could be listed in one of these, so the claim is only that 216 improves the smallest value we found.

## Rebuild

From the repository root, `bash check.sh` reruns this check with the others.
