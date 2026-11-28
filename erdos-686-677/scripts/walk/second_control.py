import sys,random; sys.path.insert(0,'.')
from second import *
random.seed(7); ok=0; T=200
for _ in range(T):
    k=random.randint(3,9); n=random.randint(k+4,3000); m=random.randint(n+k,int(n*2.5)+k)
    rho=Fr(prodk(m,k),prodk(n,k))
    sols,_=walk(rho.numerator,rho.denominator,k,k+3,10**5)
    ok+= (n,m) in sols
print("second program planted:",T,"found",ok)
# brute vs walk on small integer targets
mism=0;tot=0
for k in range(3,7):
    for N in range(2,41):
        b=[x for x in brute(N,1,k,3000) if 2*x[0]+k+1>2*(k+3)]
        w,_=walk(N,1,k,k+3,2*3000+k+1)
        w=[x for x in w if x[0]<=3000]
        tot+=len(b); mism+= set(b)!=set(w)
print("brute vs walk k=3..6 N=2..40 n<=3000: sols",tot,"mismatch",mism)
