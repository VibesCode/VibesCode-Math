import math
def phi_f(n):
    r=n;p=2;m=n
    while p*p<=m:
        if m%p==0:
            while m%p==0:m//=p
            r-=r//p
        p+=1
    if m>1:r-=r//m
    return r
def run(F,K=125):
    sols=[]
    lg=math.log10
    for k in range(1,K):
        cnt={d:0 for d in range(1,10)}
        def go(d,left,logP,S):
            if logP+left*lg(9)+lg(9*k) < (k-1)-1e-9: return
            if d==10:
                if left: return
                P=1
                for x in cnt: P*=x**cnt[x]
                m=F(P,S)
                if len(str(m))==k and sorted(str(m))==sorted(''.join(str(x)*cnt[x] for x in cnt)): sols.append(m)
                return
            for c in range(left+1):
                cnt[d]=c; go(d+1,left-c,logP+c*lg(d),S+c*d)
            cnt[d]=0
        go(1,k,0.0,0)
    return sorted(sols)
print('A120121',run(lambda P,S:phi_f(P*S)))
print('A120122',run(lambda P,S:phi_f(P)*S))
print('A120123',run(lambda P,S:P*phi_f(S)))
