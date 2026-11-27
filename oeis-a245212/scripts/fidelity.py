# Small-case fidelity check for statement.lean: direct definition of a(n) as in formal-conjectures,
# for n <= 20000 whose odd part is squarefree, a(n) == sigma(n) exactly at powers of 2.
import math
N=20000
def divs(n): return [d for d in range(1,n+1) if n%d==0]
tau={}; 
for n in range(1,N+1): tau[n]=0
for d in range(1,N+1):
    for j in range(d,N+1,d): tau[j]+=1
def a(n): return n*tau[n]-sum(d*tau[d] for d in divs(n) if d<n)
def sqfree(m): return all(m%(p*p) for p in range(2,math.isqrt(m)+1))
cnt=0; eqs=[]
for n in range(1,N+1):
    m=n
    while m%2==0: m//=2
    if not sqfree(m): continue
    cnt+=1
    if a(n)==sum(divs(n)): eqs.append(n)
print("n<=%d with squarefree odd part: %d; a(n)=sigma(n) at"%(N,cnt), eqs)
print("first values a(1..5):",[a(n) for n in range(1,6)],"(formal-conjectures tests: 1,3,5,7,9)")
assert all(e&(e-1)==0 for e in eqs) and len(eqs)==15
