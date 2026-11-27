# Compares the canonical Pell class representatives from lmm.py with a saved list (k4_canon_1000.log, made by k4_canon.py with PARI). Usage: python3 k4_canon_compare.py k4_canon_1000.log
from lmm import classes
from math import isqrt
def sign(x,y,D):  # sign of x + y sqrt D, exact
    if x>=0 and y>=0: return 1 if (x or y) else 0
    if x<=0 and y<=0: return -1
    # opposite signs: compare x^2 vs D y^2
    if x>0: return 1 if x*x>D*y*y else -1
    return 1 if D*y*y>x*x else -1
def canon(k):
    T=(k-4)**3
    if isqrt(k)**2==k: return None
    B,(a,b)=classes(k,-T); out=set()
    for x,y in B:
        if sign(x,y,k)<0: x,y=-x,-y
        # alpha>0 norm -T; canonical: Y>=0 and Y' of alpha/eta < 0
        for _ in range(100000):
            if x<0: x,y=x*a+k*y*b, x*b+y*a        # times eta
            elif x*a-k*y*b>=0: x,y=x*a-k*y*b, -x*b+y*a   # divide by eta
            else: break
        out.add((x,y))
    return sorted(out)
import sys
if __name__=="__main__":
    theirs={}
    for l in open(sys.argv[1]):
        p=l.split()
        if p[1]=="square": theirs[int(p[0])]=None
        else: theirs[int(p[0])]=sorted(tuple(map(int,q.split(","))) for q in p[2].split(";")) if len(p)>2 else []
    bad=0; tot=0
    for k in range(5,1001):
        c=canon(k); tot+=0 if c is None else len(c)
        if c!=theirs.get(k): bad+=1; print("DIFF",k,c,theirs.get(k))
    print("checked k=5..1000, classes total",tot,"differences",bad)
