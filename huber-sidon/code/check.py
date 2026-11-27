# Independent witness checker. Regenerates M_n a different way (multinomials via products of binomials over
# compositions sorted into partitions by a set of tuples), then checks the given set is in M_n and Sidon
# (all a+b, a<=b, distinct). Usage: python check.py n setfile   (setfile: one integer per line)
import sys
from math import comb
def Mset(n):
    out=set()
    def rec(rem, maxp, val):
        if rem==0: out.add(val); return
        for p in range(min(rem,maxp),0,-1):
            rec(rem-p, p, val*comb(rem,p))
    rec(n,n,1); return out
n=int(sys.argv[1]); A=[int(l) for l in open(sys.argv[2]) if l.strip()]
Mn=Mset(n)
assert len(A)==len(set(A)), "duplicates"
assert all(a in Mn for a in A), "element not in M_n"
sums={}
for i,a in enumerate(A):
    for b in A[i:]:
        s=a+b
        assert s not in sums, f"collision {a}+{b} = {sums[s][0]}+{sums[s][1]}"
        sums[s]=(a,b)
print(f"OK n={n} |M_n|={len(Mn)} |A|={len(A)} Sidon")
