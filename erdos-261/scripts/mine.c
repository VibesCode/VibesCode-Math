// Own check of Erdos 261(ii): n/2^n = sum_{k in S} k/2^k, |S|>=2, S distinct positive integers.
// Every k in S exceeds n (k/2^k is decreasing for k>=2 and k/2^k > n/2^n for k<n; k=n leaves 0).
// Residual E_m = 2^m*(n/2^n - sum_{k in S, k<=m} k/2^k) is an integer; E_n = n;
// E_{m+1} = 2E_m or 2E_m-(m+1). Feasible only if 0 <= E_m <= m+1 (tail sum over k>m is < (m+2)/2^m, and
// finite tails are at most (m+2)/2^m - 1/2^M, so E_m <= m+1 when E_m>0). Success: E reaches 0.
// For n>=2 a single term k>n with k/2^k = n/2^n is impossible, so success means |S|>=2. n=1: check separately.
#include <stdio.h>
#include <stdlib.h>
typedef long long ll;
int main(int c,char**v){ ll A=atoll(v[1]),B=atoll(v[2]); ll worst=0,worstn=0,maxf=0; unsigned long long chk=0;
  ll *f=malloc(1024*8),*g=malloc(1024*8);
  for(ll n=A;n<=B;n++){ int nf=1; f[0]=n; ll m=n; int ok=0;
    while(nf>0){ int ng=0; ll m1=m+1;
      for(int i=0;i<nf;i++){ ll e=f[i]; ll c1=2*e, c2=2*e-m1;
        if(c2==0||c1==0){ ok=1; break; }
        if(c1<=m1+1){ int d=0; for(int j=0;j<ng;j++) if(g[j]==c1){d=1;break;} if(!d) g[ng++]=c1; }
        if(c2>0 && c2<=m1+1){ int d=0; for(int j=0;j<ng;j++) if(g[j]==c2){d=1;break;} if(!d) g[ng++]=c2; } }
      m=m1; if(ok) break; ll*t=f;f=g;g=t; nf=ng; if(nf>maxf) maxf=nf; if(nf>1000){fprintf(stderr,"frontier overflow\n");return 2;} }
    if(!ok){ printf("FAIL n=%lld\n",n); fflush(stdout); continue; }
    ll depth=m-n; chk=chk*1000003ULL+(unsigned long long)depth; if(depth>worst){worst=depth;worstn=n;} }
  printf("range [%lld,%lld] all ok unless FAIL above; worst n=%lld depth(levels)=%lld max frontier=%lld checksum=%llu\n",A,B,worstn,worst,maxf,chk); }
