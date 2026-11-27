# Usage: python3 check_ca.py ARRAY_FILE N t k v
#   e.g. python3 check_ca.py CA_216_3_11_5.txt 216 3 11 5   (plain Python 3, no other packages)
# Independent checker from the definition: an N x k array over {0..v-1} is a covering array
# of strength t if every choice of t columns shows all v^t tuples in some row.
import sys, itertools
path, N, t, k, v = sys.argv[1], *map(int, sys.argv[2:6])
raw = open(path, "rb").read()
text = raw.decode("ascii")  # refuse anything non-ascii
lines = [l for l in text.split("\n")]
if lines and lines[-1].strip() == "": lines = lines[:-1]
rows = []
for i, l in enumerate(lines):
    toks = l.split()
    assert len(toks) == k, f"row {i+1}: {len(toks)} entries, want {k}"
    r = []
    for x in toks:
        assert x in {str(s) for s in range(v)}, f"row {i+1}: bad symbol {x!r}"
        r.append(int(x))
    rows.append(tuple(r))
assert len(rows) == N, f"{len(rows)} rows, want {N}"
syms = set(s for r in rows for s in r); assert syms == set(range(v)), syms
bad = 0; checked = 0; minmult = None
for cols in itertools.combinations(range(k), t):
    seen = {}
    for r in rows:
        key = tuple(r[c] for c in cols); seen[key] = seen.get(key, 0) + 1
    checked += 1
    if len(seen) != v ** t:
        bad += 1
        if bad <= 5: print("MISSING in columns", cols, sorted(set(itertools.product(range(v), repeat=t)) - set(seen))[:5])
    m = min(seen.values()) if len(seen) == v**t else 0
    minmult = m if minmult is None else min(minmult, m)
dup = len(rows) - len(set(rows))
print(f"shape {len(rows)}x{k}, alphabet {sorted(syms)}, column triples checked {checked} (C({k},{t})), failing {bad}, duplicate rows {dup}, min coverage multiplicity {minmult}")
print("COVERING ARRAY OK" if bad == 0 else "NOT A COVERING ARRAY")
