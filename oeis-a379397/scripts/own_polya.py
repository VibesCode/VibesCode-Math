import numpy as np, sys, re, math
from sympy.utilities.iterables import partitions
N=int(sys.argv[1]); M=int(round(N**(1/3)))+2
M=max(c for c in range(M+1) if c**3<=N)
tot=np.zeros(N+1,dtype=np.uint64)
F=math.factorial(9)
def mulsparse(d,i):
    out=np.zeros(N+1,dtype=np.uint64)
    for c in range(M+1):
        s=i*c**3
        if s>N: break
        out[s:]+=d[:N+1-s]
    return out
for lam in partitions(9):
    z=1
    for i,m in lam.items(): z*=i**m*math.factorial(m)
    d=np.zeros(N+1,dtype=np.uint64); d[0]=1
    for i,m in lam.items():
        for _ in range(m): d=mulsparse(d,i)
    tot+=d*np.uint64(F//z)
assert (tot%np.uint64(F)==0).all()
r=tot//np.uint64(F)
print("r(0)",r[0])
res={}
for k in range(1,11):
    s=[n for n in range(1,N+1) if r[n]==k]; res[k]=s
    print(k,len(s),s[-1] if s else None)
# OEIS entries in text format (https://oeis.org/A379397/internal etc.), saved as A379396.txt ... A379400.txt
import sys as _sys
D=(_sys.argv[2] if len(_sys.argv)>2 else '.')+'/'
for k,a in zip(range(1,6),range(379396,379401)):
    t=open(D+'A%d.txt'%a).read()
    data=[]
    for l in t.splitlines():
        m=re.match(r'%[STU] A\d+ (.*)',l)
        if m: data+= [int(x) for x in m.group(1).split(',') if x.strip()]
    if k==1: data=[x for x in data if x>0]
    print(k,"match",data==res[k],len(data))
