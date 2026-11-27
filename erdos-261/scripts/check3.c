// check3: same independent check as check2.c (walk with parent pointers, reconstruct S, verify
// n*2^(M-n) == sum_{k in S} k*2^(M-k) mod two primes), but the modular sum uses a running power of 2
// (O(depth) instead of O(|S| log M)) and prints progress. Assert <= 4 states per level, |S| >= 2.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <string.h>
typedef unsigned __int128 u128;
static const uint64_t P1=2305843009213693951ULL, P2=4611686018427387847ULL;
static uint64_t mulm(uint64_t a,uint64_t b,uint64_t p){return (u128)a*b%p;}
typedef struct {long v; int par; char take;} St;
int main(int c,char**v){ long a=atol(v[1]),b=atol(v[2]); long cap=atol(v[3]);
  St *L=malloc(sizeof(St)*4*(size_t)(cap+2)); int *cnt=malloc(sizeof(int)*(size_t)(cap+2)); long bad=0;
  unsigned char *in=malloc((size_t)cap+2);
  for(long n=a;n<=b;n++){
    cnt[0]=1; L[0].v=n; L[0].par=-1; long m=n; long lev=0; int hitidx=-1;
    while(lev<cap){ int k=0; St *cur=L+4*lev, *nx=L+4*(lev+1);
      for(int i=0;i<cnt[lev];i++){ long e=cur[i].v; long cand[2]={2*e,2*e-(m+1)};
        for(int t=0;t<2;t++){ long x=cand[t]; if(x<0||x>m+3) continue; int d=0; for(int j=0;j<k;j++) if(nx[j].v==x){d=1;break;}
          if(!d){ if(k>=4){printf("MORE THAN 4 STATES n=%ld\n",n);exit(1);} nx[k].v=x; nx[k].par=i; nx[k].take=t; k++; } } }
      lev++; m++; cnt[lev]=k; for(int j=0;j<k;j++) if(nx[j].v==0){hitidx=j;break;} if(hitidx>=0) break; }
    if(hitidx<0){printf("NOHIT %ld\n",n); fflush(stdout); bad++; continue;}
    memset(in,0,(size_t)lev+1); long ns=0; int idx=hitidx;
    for(long l=lev;l>0;l--){ St s=L[4*l+idx]; if(s.take){in[l]=1; ns++;} idx=s.par; }
    long M=n+lev; int ok = ns>=2;
    for(int q=0;q<2 && ok;q++){ uint64_t p=q?P2:P1; uint64_t r=1, rhs=0;   // r = 2^(M-k), k from M down to n
      for(long l=lev;l>=0;l--){ long kk=n+l; if(l>0 && in[l]) rhs=(rhs+mulm((uint64_t)kk%p,r,p))%p;
        if(l==0){ uint64_t lhs=mulm((uint64_t)n%p,r,p); if(lhs!=rhs) ok=0; }
        r=(r<<1)%p; } }
    if(!ok){printf("BAD %ld\n",n); fflush(stdout); bad++;}
    if(n%10000==0){printf("at %ld bad=%ld\n",n,bad); fflush(stdout);}
  }
  printf("CHECK3 %ld..%ld bad=%ld\n",a,b,bad); }
