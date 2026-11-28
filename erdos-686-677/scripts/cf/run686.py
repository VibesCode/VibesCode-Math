import sys,time; sys.path.insert(0,'.')
from ratio_cf import *
X0=10**4; D=int(sys.argv[1])
for N in (4,25):
    for k in range(3,int(sys.argv[2])+1):
        t=time.time()
        b=band(N,1,k,X0)
        cs,info=cf_search(N,1,k,X0,D)
        print(f"N={N} k={k}: band n<={X0}: {b}; CF X in ({X0},10^{D}]: {cs} {info} {time.time()-t:.1f}s",flush=True)
