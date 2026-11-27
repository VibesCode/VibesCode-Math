import numpy as np
N=1000000
# phi and sigma via sieve over divisors (own method: multiplicative via smallest prime factor)
phi=np.arange(N+1,dtype=np.int64)
for p in range(2,N+1):
    if phi[p]==p:
        phi[p::p]-=phi[p::p]//p
sig=np.zeros(N+1,dtype=np.int64)
for d in range(1,N+1): sig[d::d]+=d
M=int(sig.max())+2
L=int(M*(np.log(M)+np.log(np.log(M))))+1000
s=np.ones(L+1,dtype=bool); s[:2]=False
for i in range(2,int(L**.5)+1):
    if s[i]: s[i*i::i]=False
pr=np.nonzero(s)[0]; assert len(pr)>M
g=lambda k: pr[k]-pr[k-1]   # prime(k+1)-prime(k), pr 0-indexed: prime(k)=pr[k-1]
n=np.arange(1,N+1)
A=n[(pr[n]-pr[n-1])==phi[1:]]
S=sig[1:]
B=n[(pr[S]-pr[S-1])==phi[1:]]
print("A066494 n<=1e6:",A.tolist()); print("A066516 n<=1e6:",B.tolist(),"max sigma",M)
