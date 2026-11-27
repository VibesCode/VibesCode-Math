from fractions import Fraction as F
import gmpy2, math
L=10**12
sm=[]
p2=1
while p2<L:
    p3=p2
    while p3<L:
        p5=p3
        while p5<L:
            p7=p5
            while p7<L: sm.append(p7); p7*=7
            p5*=5
        p3*=3
    p2*=2
sm.sort()
S=sum(F(1,s) for s in sm)
t=F(35,8)-S
primes=[s+1 for s in sm if gmpy2.is_prime(s+1,30)]
num=1;den=1
for p in primes: num*=p; den*=p-1
prod=F(num,den)
Cub=prod*(1+2*t)
print("smooth<1e12:",len(sm),"primes:",len(primes),"t=",float(t),"prod=",float(prod),"C<=",float(Cub), Cub<F(82586,10000))
# Lemma 4 cap: largest k with 10^(k-1) <= 8.2586*9^k
print("k cap:",max(k for k in range(1,100) if 10**(k-1)*10000<=82586*9**k))
# Lemma 5: g(v)=2R(v)(8/9)^(v/3); max over v<=400
odd=[p for p in primes if p>2]
best=(0,0); R=F(1)
for v in range(0,401):
    if v>0: R*=F(odd[v-1],odd[v-1]-1)
    g=2*float(R)*(8/9)**(v/3)
    if g>best[0]: best=(g,v)
print("max g",best, "k cap from Lemma5:", max(k for k in range(1,100) if (10/9)**k<=10*best[0]*(1+1e-12)))
