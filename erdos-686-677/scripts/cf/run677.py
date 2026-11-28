# Erdos 677 via the ratio: lcm(n+1..n+k)=lcm(m+1..m+k) => P(m)/P(n) = R(m)/R(n), R = product/lcm (k-smooth, periodic mod lcm(1..k-1)).
import sys,time; sys.path.insert(0,'.')
from ratio_cf import *
from math import lcm
from fractions import Fraction as F
def R(n,k): return P(n,k)//lcm(*range(n+1,n+k+1))
X0=int(sys.argv[1]); D=int(sys.argv[2]); K=int(sys.argv[3])
# control: rational targets, band vs CF
mism=0; nsol=0
for k in (3,4,5,6):
    for u in range(2,13):
        for v in range(1,u):
            if gcd(u,v)!=1: continue
            b=[s for s in band(u,v,k,5000) if 2*s[0]+k+1>2*(k+3)]
            cs,_=cf_search(u,v,k,k+3,5)
            if cs is None: continue
            cs=[s for s in cs if s[0]<=5000]; nsol+=len(b)
            if set(b)!=set(cs): mism+=1; print("MISMATCH",k,u,v,b,cs)
print("control: rational targets u/v<=12, k=3..6, n<=5000: solutions",nsol,"mismatches",mism,flush=True)
for k in range(int(sys.argv[4]) if len(sys.argv)>4 else 3,K+1):
    t=time.time(); L=lcm(*range(1,k))
    Rs=sorted({R(n,k) for n in range(L)})
    # periodicity check on a further stretch
    assert all(R(n,k)==R(n%L,k) for n in range(L,L+3000)), "period fail"
    ratios=sorted({F(a,b) for a in Rs for b in Rs if a>b})
    hits=[]; prodsols=[]
    for rho in ratios:
        u,v=rho.numerator,rho.denominator
        b=band(u,v,k,X0)
        cs,info=cf_search(u,v,k,X0,D)
        if cs is None: print("  rational c for",rho,info,"C",constants(u,v,k,X0)[1]); cs=[]
        for (n,m) in b+cs:
            prodsols.append((rho,n,m))
            if lcm(*range(n+1,n+k+1))==lcm(*range(m+1,m+k+1)): hits.append((n,m))
    print(f"k={k}: R-values {Rs}; ratios {len(ratios)}; product-ratio solutions {prodsols[:8]}{'...' if len(prodsols)>8 else ''} (count {len(prodsols)}); EQUAL-LCM {hits}; {time.time()-t:.0f}s",flush=True)
