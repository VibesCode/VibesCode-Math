import sys,time; sys.path.insert(0,'.')
from second import *
from math import lcm
what=sys.argv[1]
if what=='686':
    Ns=[int(x) for x in sys.argv[2].split(',')] if len(sys.argv)>2 else (4,25)
    ks=range(int(sys.argv[3]),int(sys.argv[4])+1) if len(sys.argv)>4 else range(3,21)
    for N in Ns:
        for k in ks:
            t=time.time(); b=brute(N,1,k,3000); w,nodes=walk(N,1,k,3000,2*10**1000)
            print(f"686 N={N} k={k}: brute X<=3000 {b}; walk 3000<X<=10^1000 {w}; nodes {nodes}; {time.time()-t:.1f}s",flush=True)
else:
    for k in range(3,17):
        t=time.time(); L=lcm(*range(1,k)) if k>2 else 1
        Rs=set(); bad=0
        for n in range(L):
            r=Rcount(n,k); Rs.add(r)
            if r!=prodk(n,k)//lcm(*range(n+1,n+k+1)): bad+=1
        # formula is periodic mod L by construction; spot-check the identity beyond one period too
        for n in range(L,L+2000):
            if Rcount(n,k)!=prodk(n,k)//lcm(*range(n+1,n+k+1)): bad+=1
        ratios=sorted({Fr(a,b) for a in Rs for b in Rs if a>b})
        sols=[]
        for rho in ratios:
            u,v=rho.numerator,rho.denominator
            sols+= [(rho,x) for x in brute(u,v,k,1000)]
            w,_=walk(u,v,k,1000,2*10**100); sols+=[(rho,x) for x in w]
        eq=[x for _,x in sols if lcm(*range(x[0]+1,x[0]+k+1))==lcm(*range(x[1]+1,x[1]+k+1))]
        print(f"677 k={k}: |R-values| {len(Rs)} (formula vs lcm mismatches over full period: {bad}); ratios {len(ratios)}; product-ratio sols {len(sols)}; equal-lcm {eq}; {time.time()-t:.0f}s",flush=True)
