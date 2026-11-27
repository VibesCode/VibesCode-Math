#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
typedef uint64_t u64; typedef unsigned __int128 u128;
int main(int argc,char**argv){
  if(argc<2){fprintf(stderr,"usage: N\n");return 1;}
  u64 N=strtoull(argv[1],0,10);
  uint32_t *spf=calloc(N+1,4);
  for(u64 i=2;i<=N;i++) if(!spf[i]) for(u64 j=i;j<=N;j+=i) if(!spf[j]) spf[j]=i;
  u64 *phi=malloc((N+1)*8),*sig=malloc((N+1)*8);
  phi[1]=1;sig[1]=1; u64 maxsig=1;
  for(u64 n=2;n<=N;n++){
    u64 m=n,p=spf[n],ph=1,sg=1;
    while(m>1){p=spf[m];u64 pk=1,s=1;ph*=p-1;m/=p;
      while(m%p==0){m/=p;ph*=p;}
      /* recompute p-power sum */
      u64 t=n;int e=0;while(t%p==0){t/=p;e++;}
      pk=1;s=1;for(int i=0;i<e;i++){pk*=p;s+=pk;}
      sg*=s;}
    phi[n]=ph;sig[n]=sg;if(sg>maxsig)maxsig=sg;
  }
  u64 need=(N+1>maxsig+1?N+1:maxsig+1);
  double k=(double)need+10; u64 lim=(u64)(k*(log(k)+log(log(k)))*1.02)+100;
  if(lim<400000) lim=400000;
  /* odd-only sieve */
  u64 half=lim/2+1; unsigned char*comp=calloc(half,1);
  for(u64 i=1;(2*i+1)*(2*i+1)<=lim;i++) if(!comp[i]){u64 p=2*i+1;for(u64 j=(p*p-1)/2;j<half;j+=p)comp[j]=1;}
  u64 cap=need+10; uint32_t*pr=malloc((cap+1)*4); u64 cnt=0;
  pr[++cnt]=2;
  for(u64 i=1;i<half;i++) if(!comp[i]){u64 p=2*i+1;if(p>lim)break;if(cnt<cap)pr[++cnt]=p; else cnt++;}
  if(cnt<need){fprintf(stderr,"FATAL: only %llu primes, need %llu\n",(unsigned long long)cnt,(unsigned long long)need);abort();}
  printf("N=%llu maxsigma=%llu need_prime_index=%llu sieve_limit=%llu primes_found=%llu\n",(unsigned long long)N,(unsigned long long)maxsig,(unsigned long long)need,(unsigned long long)lim,(unsigned long long)cnt);
  #define G(i) ((u64)pr[(i)+1]-pr[(i)])
  printf("S1:");for(u64 n=1;n<=N;n++) if(G(n)==phi[n])printf(" %llu",(unsigned long long)n);printf("\n");
  printf("S2:");for(u64 n=1;n<=N;n++) if(G(sig[n])==phi[n])printf(" %llu",(unsigned long long)n);printf("\n");
  /* pi(396737) */
  u64 P=0,kk=0;for(u64 i=1;i<=cnt&&i<=cap;i++){if(pr[i]<=396737)P=i; if(!kk&&pr[i]>=396738)kk=i;}
  printf("pi(396737)=%llu\nsmallest k with prime(k)>=396738: k=%llu prime(k)=%u\n",(unsigned long long)P,(unsigned long long)kk,pr[kk]);
  u64 a1=0,b1=1,n1=0,a2=0,b2=1,n2=0;
  for(u64 n=101;n<=N;n++){
    u64 g=G(n); if((u128)g*b1>(u128)a1*phi[n]){a1=g;b1=phi[n];n1=n;}
    u64 h=G(sig[n]); if((u128)h*b2>(u128)a2*phi[n]){a2=h;b2=phi[n];n2=n;}
  }
  printf("max g(n)/phi(n), n in [101,N]: %llu/%llu at n=%llu\n",(unsigned long long)a1,(unsigned long long)b1,(unsigned long long)n1);
  printf("max g(sigma(n))/phi(n), n in [101,N]: %llu/%llu at n=%llu\n",(unsigned long long)a2,(unsigned long long)b2,(unsigned long long)n2);
  u64 fails=0;
  for(u64 n=2;n<=N;n++) if(!((u128)sig[n]*phi[n]<(u128)n*n)){fails++;printf("FAIL sigma*phi>=n^2 at n=%llu\n",(unsigned long long)n);}
  printf("sigma*phi<n^2 failures for 2<=n<=N: %llu\n",(unsigned long long)fails);
  return 0;
}
