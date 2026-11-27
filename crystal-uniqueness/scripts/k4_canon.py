# Prints canonical class representatives of Y^2 - k w^2 = -(k-4)^3 from k4_iv.py (PARI). Usage: python3 k4_canon.py 5 1000
import sys, math
sys.argv=[sys.argv[0]]+sys.argv[1:]
import k4_iv as K
from mpmath import iv
iv.dps=200
def canon(k):
    T=(k-4)**3
    if K.isq(k): return None
    (a,b),B,fu=K.classes(k,T)
    sk=iv.sqrt(k); eta=a+b*sk; rT=iv.sqrt(T); out=set()
    for (y,w) in B:
        Y,W=y,w
        for _ in range(10000):
            v=Y+W*sk
            if K.hi(v)<K.lo(rT): Y,W=Y*a+k*W*b, Y*b+W*a
            elif K.lo(v)>=K.hi(rT*eta): Y,W=Y*a-k*W*b, -Y*b+W*a
            else: break
        out.add((Y,W))
    return sorted(out)
lo_,hi_=int(sys.argv[1]),int(sys.argv[2])
for k in range(lo_,hi_+1):
    c=canon(k)
    print(k, "square" if c is None else len(c), "" if c is None else ";".join(f"{y},{w}" for y,w in c), flush=True)
