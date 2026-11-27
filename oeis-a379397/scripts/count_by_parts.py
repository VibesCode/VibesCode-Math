import numpy as np
N=5929981+1
cubes=[c**3 for c in range(1,int(round(N**(1/3)))+2) if c**3<N]
dp=np.zeros((10,N),dtype=np.int64); dp[0,0]=1
for c in cubes:
    for j in range(1,10):
        dp[j,c:]+=dp[j-1,:N-c]
r=dp[1:10].sum(axis=0)        # 1..9 parts
le8=dp[0:9].sum(axis=0)        # 0..8 parts
print("not sum of <=8 positive cubes (m>=1):",[m for m in range(1,N) if le8[m]==0][:10])
for k in range(1,21):
    B=240+(9*k+1)**3; S=[n for n in range(1,min(N,B)) if r[n]==k]
    big=np.nonzero(r[B:]==k)[0] if B<N else []
    print(k,B,len(S),S[-1] if S else None, "beyond-bound hits:",len(big))
    if 2<=k<=5: open(f"terms_{k}.txt","w").write(",".join(map(str,S)))
