"""Engine checks for the Van Voorhis recurrence (independent of the Lean proof).
1. Exact s(n) for n <= 6 by BFS over sets of reachable 0-1 output vectors (standard comparators).
2. Random networks: Kraft sum over tokens ending at a common wire <= 1; deepest token >= ceil(log2 n) for sorting nets.
3. Strip + untangle on random sorting networks: the reduced network on n-1 wires sorts and has size L - depth."""
import itertools, random, math
def clog2(n): return 0 if n<=1 else (n-1).bit_length()
def apply(c,v):
    a,b=c; v=list(v); x,y=v[a],v[b]; v[a],v[b]=min(x,y),max(x,y); return tuple(v)
def ev(N,v):
    for c in N: v=apply(c,v)
    return v
def sorts(N,n):
    return all(list(ev(N,v))==sorted(v) for v in itertools.product((0,1),repeat=n))
def exact_s(n, cap=20):
    comps=[(a,b) for a in range(n) for b in range(a+1,n)]
    start=frozenset(itertools.product((0,1),repeat=n)); target=n+1
    if len(start)==target: return 0
    layer={start}; seen={start}
    for d in range(1,cap):
        nxt=set()
        for S in layer:
            for c in comps:
                T=frozenset(apply(c,v) for v in S)
                if len(T)==target: return d
                if T not in seen: seen.add(T); nxt.add(T)
        layer=nxt
    return None
def track(N,p):
    t=0
    for (a,b) in N:
        if p in (a,b): p=a; t+=1
    return p,t
s={}
for n in range(1,7):
    s[n]=exact_s(n); print("s(%d) = %s"%(n,s[n]))
for n in range(2,7):
    print("n=%d: s(n)=%d >= s(n-1)+clog2(n)=%d : %s"%(n,s[n],s[n-1]+clog2(n),s[n]>=s[n-1]+clog2(n)))
random.seed(1); bad=0; tested=0
for trial in range(4000):
    n=random.randint(2,7); L=random.randint(0,30)
    N=[]
    for _ in range(L):
        a,b=random.sample(range(n),2); N.append((min(a,b),max(a,b)) if random.random()<0.7 else (a,b))
    for q in range(n):
        ks=sum(0.5**track(N,w)[1] for w in range(n) if track(N,w)[0]==q)
        if ks>1+1e-12: bad+=1
    std=all(a<b for a,b in N)
    if std and sorts(N,n):
        tested+=1
        if max(track(N,w)[1] for w in range(n))<clog2(n): bad+=1
        if any(track(N,w)[0]!=0 for w in range(n)): bad+=1
print("random Kraft/depth checks: %d failures; %d random sorting networks tested"%(bad,tested))
# sorting nets from greedy random completion, then strip test
def random_sorting(n):
    N=[]
    while not sorts(N,n):
        a,b=sorted(random.sample(range(n),2)); N.append((a,b))
    return N
fails=0
for trial in range(300):
    n=random.randint(2,6); N=random_sorting(n)
    for w in range(n):
        # simulate: token = -inf at w; record surviving comparators acting on the other values with relabelling
        pos=w; others={i:i for i in range(n) if i!=w}  # wire -> original label of value
        red=[]; t=0
        for (a,b) in N:
            if pos in (a,b):
                t+=1
                if pos==b: others[b]=others.pop(a); pos=a
            else: red.append((others[a],others[b]))
        # red is a generalized network on labels; check it sorts after the final relabelling
        lab=sorted(i for i in range(n) if i!=w); idx={l:k for k,l in enumerate(lab)}
        R=[(idx[a],idx[b]) for a,b in red]
        final=[idx[others[i]] for i in range(1,n)]   # output wire i (i>=1) holds value-label final[i-1]
        ok=True
        for v in itertools.product((0,1),repeat=n-1):
            o=ev(R,v); out=[o[final[i]] for i in range(n-1)]
            if out!=sorted(out): ok=False;break
        if not ok or len(R)+t!=len(N) or pos!=0: fails+=1
print("strip checks on 300 random sorting networks, all wires: %d failures"%fails)
