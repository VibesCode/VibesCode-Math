# Control 3: plant a solution. Random (n,m), rho = P(m)/P(n) reduced; the CF method (X0 = k+3) must return (n,m).
import sys,random; sys.path.insert(0,'.')
from ratio_cf import *
from fractions import Fraction as F
random.seed(1); ok=0; miss=[]; tried=0
for trial in range(300):
    k=random.randint(3,9); n=random.randint(k+4,5000); m=random.randint(n+k,int(n*2.5)+k)
    rho=F(P(m,k),P(n,k)); tried+=1
    cs,info=cf_search(rho.numerator,rho.denominator,k,k+3,5)
    if cs is not None and (n,m) in cs: ok+=1
    else: miss.append((k,n,m,info))
print("planted",tried,"found",ok,"missed",miss[:5])
