import sys, gmpy2
k=int(sys.argv[1]); L=[int(x) for x in open(sys.argv[2])]
bad=0
for N in L:
    rep=None
    y=1
    while k*2**y < N:
        x=1
        while k*2**y+2**x < N:
            p=N-2**x-k*2**y
            if p>2 and gmpy2.is_prime(p,50): rep=(p,x,y); break
            x+=1
        if rep: break
        y+=1
    if rep: bad+=1; print("REP",N,rep)
print("checked",len(L),"represented",bad)
