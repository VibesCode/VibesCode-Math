# Q(X) = #squarefree <= X = sum_{d<=sqrt X} mu(d) floor(X/d^2);  S(X) = sum of squarefree <= X = sum mu(d) d^2 T(floor(X/d^2)), T(m)=m(m+1)/2.
import sys, math
def mobius_upto(n):
    mu=[1]*(n+1); isp=bytearray([1])*(n+1)
    for p in range(2,n+1):
        if isp[p]:
            for j in range(p,n+1,p):
                if j>p: isp[j]=0
                mu[j]=-mu[j]
            for j in range(p*p,n+1,p*p): mu[j]=0
    return mu
X=[int(float(a)) if 'e' in a else int(a) for a in sys.argv[1:]]
r=math.isqrt(max(X)); mu=mobius_upto(r)
for x in X:
    Q=0; S=0
    for d in range(1,math.isqrt(x)+1):
        if mu[d]:
            m=x//(d*d); Q+=mu[d]*m; S+=mu[d]*d*d*m*(m+1)//2
    print(x,Q,S)
