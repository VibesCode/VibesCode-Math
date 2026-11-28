# Own check of C2: R(n) = P(n)/lcm(n+1..n+k) directly over one period L = lcm(1..k-1) (plus spot checks of periodicity),
# all ratios rho = R_i/R_j > 1, each solved by mine.solve up to X <= 10^100, every product solution tested for equal lcm;
# plus direct lcm brute force for n <= 1000.
import sys, math, random, time
from fractions import Fraction as Fr
import mine
def lcmw(n,k):
    l=1
    for i in range(1,k+1): l=math.lcm(l,n+i)
    return l
k=int(sys.argv[1]); t=time.time()
L=1
for i in range(1,k): L=math.lcm(L,i)
Rv=set()
for n in range(L): Rv.add(mine.P(n,k)//lcmw(n,k))
random.seed(k); bad=0
for _ in range(300):
    n=random.randrange(L,10**30); 
    if mine.P(n,k)//lcmw(n,k)!=mine.P(n%L,k)//lcmw(n%L,k): bad+=1
rat=sorted({Fr(a,b) for a in Rv for b in Rv if a>b})
eq=[]; prodsols=0
for r in rat:
    s,sm,nd,cd,C=mine.solve(k,r.numerator,r.denominator,10**100,1000,260)
    for (n,m) in s:
        prodsols+=1
        if lcmw(n,k)==lcmw(m,k): eq.append((n,m))
# direct brute force small n
direct=[]
Rmax=max(Rv)
for n in range(0,1001):
    ln=lcmw(n,k); m=n+k
    while True:
        lm=lcmw(m,k)
        if lm==ln: direct.append((n,m))
        if mine.P(m,k)//Rmax > ln: break
        m+=1
print(f"677 k={k}: period {L}, |R| {len(Rv)}, periodicity spot-check bad {bad}, ratios {len(rat)}, product sols (m>=n+k) {prodsols}, equal-lcm {eq}, direct n<=1000 {direct}; {time.time()-t:.0f}s",flush=True)
