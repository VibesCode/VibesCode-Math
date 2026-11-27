# A covering array CA(179; 3, 39, 4): CAN(3, 39, 4) ≤ 179

## The result

[`CA_179_3_39_4.txt`](CA_179_3_39_4.txt) is an explicit covering array with **179 rows, 39 columns, 4 symbols and strength 3**: for every choice of 3 of the 39 columns, each of the 4³ = 64 possible triples of symbols appears in at least one row.

So **CAN(3, 39, 4) ≤ 179**. The best known upper bound was 180.

**Status:** an **upper bound only**. Nothing is claimed about a lower bound or about optimality. The array was found by computer search. It is **verified by exhaustive checking with independent programs**, not by a proof assistant (no Lean for this result).

This is a record for one entry of the covering array tables. It is real but modest: one row fewer than the previous best.

## The file

- 179 lines, one row per line, 39 symbols from {0, 1, 2, 3} separated by spaces. All rows are distinct.
- SHA-256: `89c5d1e1d935d09cc6e5ebeeedbf83bf221d75adc4e3fdaf4ef4574d095d26b7` (also in [`CA_179_3_39_4.txt.sha256`](CA_179_3_39_4.txt.sha256)).

## Check it yourself

```
python3 scripts/check_ca.py CA_179_3_39_4.txt 179 3 39 4
```

[`scripts/check_ca.py`](scripts/check_ca.py) is plain Python 3 with no other packages, and it runs in under a second. It reads the file strictly (ASCII only; each row must have exactly 39 entries from {0, 1, 2, 3}). Then it checks all C(39, 3) = 9139 column triples and prints `COVERING ARRAY OK` only if every triple shows all 64 patterns. Expected output:

```
shape 179x39, alphabet [0, 1, 2, 3], column triples checked 9139 (C(39,3)), failing 0, duplicate rows 0, min coverage multiplicity 1
COVERING ARRAY OK
```

[`scripts/check_ca_np.py`](scripts/check_ca_np.py) is a second implementation that uses numpy and codes each triple as a base-4 number. It reports 0 failing triples of 9139. A separate C checker, written independently of both, also reports 0 failing triples.

The checkers can fail. Deleting any one row, or changing a single entry, produces failing triples (between 39 and 500 in the trials run). `check.sh` reruns the check and one such negative control.

## Prior record and sources

- **180:** Seonbin Kim, November 2026 (github.com/seankim-business/ca-180-3-39-4). It is listed as VERIFIED in the ca-tools covering array table (github.com/chrispbsmolen/ca-tools, `table/ca_table.csv`), merged on 2026-11-15.
- **186:** Charles Colbourn's covering array tables, in the November 2024 snapshot held in ca-tools.
- On 2026-11-27 at 12:35 UTC, the ca-tools table had no entry with 179 or fewer rows for strength 3, 4 symbols and 39 or more columns. A search of GitHub and the web found no CA(179; 3, 39, 4). Colbourn's live tables at Arizona State University could not be read (they now need a login), so an update there after November 2024 is unchecked. It would also have to beat 180.

These tables change often, so this record may already have been improved.

## Rebuild

From the repository root, `bash check.sh` reruns this check with the others.
