# Non-vacuity: genuine planar difference sets satisfy formal-conjectures' IsPerfectDifferenceSet (offDiag -> nonzero residues, a bijection)
def is_pds(D, n):
    D = list(D); diffs = [(a - b) % n for a in D for b in D if a != b]
    return all(d != 0 for d in diffs) and len(diffs) == len(set(diffs)) and set(diffs) == set(range(1, n))
for D, n in [({0,1,3}, 7), ({0,1,3,9}, 13), ({3,6,7,12,14}, 21), ({0,1,3,8,12,18}, 31), ({1,2,4,8,16,32,64,55,...} if False else {0,1,3,7,15,31,36,54,63}, 73)]:
    print(sorted(D), n, "order", len(D)-1, "PDS:", is_pds(D, n))
