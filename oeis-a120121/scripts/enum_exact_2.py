# Exhaustive search over digit multisets, digits chosen 9 -> 1, exact integer prune, totient from sympy. Usage: python3 enum_exact_2.py
from math import prod
from sympy import totient
import sys
sys.setrecursionlimit(10000)
def phi(x): return 0 if x==0 else int(totient(x))
hits={1:set(),2:set(),3:set()}; nodes=0
def counts(m):
    c=[0]*10
    for ch in str(m): c[int(ch)]+=1
    return c
for k in range(1,85):
    lowm=10**(k-1)
    def rec(d,left,P,S,c):
        global nodes
        if d==0:
            if left: return
            nodes+=1
            for t,F in ((1,phi(P*S)),(2,phi(P)*S),(3,P*phi(S))):
                if F>=lowm and F<10*lowm and counts(F)==[0]+c[1:]: hits[t].add(F)
            return
        # remaining 'left' digits use values <= d
        if P*d**left*(S+d*left) < lowm: return
        if d==1:
            c[1]=left; rec(0,0,P,S+left,c); c[1]=0; return
        for x in range(left,-1,-1):
            c[d]=x; rec(d-1,left-x,P*d**x,S+d*x,c)
        c[d]=0
    rec(9,k,1,0,[0]*10)
print("nodes",nodes)
for t in (1,2,3): print(t,sorted(hits[t]))
