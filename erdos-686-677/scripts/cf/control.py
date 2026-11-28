# Controls: (1) every brute-force solution lies in the ratio band; (2) CF method finds exactly the band solutions above X0.
import sys; sys.path.insert(0,'.')
from ratio_cf import *
import time
# (1) plain double loop, no band
bad=0; tot=0
for k in range(2,7):
    for n in range(0,300):
        pn=P(n,k)
        for m in range(n+k,1500):
            pm=P(m,k)
            if pm%pn==0:
                N=pm//pn
                if N<=60:
                    tot+=1; c=N**(1/k)
                    if not (m>c*(n+1)-1 and m<c*(n+k)-k): bad+=1
print("control1: integer-ratio solutions N<=60 (k=2..6,n<300,m<1500):",tot,"outside band:",bad)
# (2)
t=time.time(); mism=0; found=0
for k in range(3,8):
    for N in range(2,61):
        X0=k+3
        bs=[s for s in band(N,1,k,20000) if s[0]+(k+1)/2>X0]
        cs,info=cf_search(N,1,k,X0,6)
        if cs is None: continue
        cs=[s for s in cs if s[0]<=20000]
        found+=len(bs)
        if set(bs)!=set(cs): mism+=1; print("MISMATCH",k,N,bs,cs)
print("control2: band (n<=20000) vs CF, k=3..7, N=2..60: solutions",found,"mismatches",mism,"time %.0fs"%(time.time()-t))
