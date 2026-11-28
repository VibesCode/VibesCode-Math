// Own exhaustive check: odd N with 2k+3 < N < LIM that are NOT p + 2^x + k*2^y (p odd prime, x,y >= 1).
// Odd-only prime bitset up to LIM by segmented Eratosthenes; then each N tries all (x,y) until a prime is found.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
#include <pthread.h>
typedef unsigned long long u64;
static u64 LIM; static uint64_t *bits; static int NK; static u64 KS[64]; static int T;
#define ISP(n) ((bits[(n)>>7]>>(((n)>>1)&63))&1)   /* n odd */
static uint32_t *bp; static int nbp;
static void *sieve(void*arg){ long t=(long)arg; u64 W=1ULL<<27; // numbers per segment (multiple of 128)
  unsigned char *s=malloc(W/2);
  for(u64 lo=(u64)t*W; lo<LIM; lo+=(u64)T*W){ u64 hi=lo+W; if(hi>LIM) hi=LIM; memset(s,1,W/2);
    for(int i=0;i<nbp;i++){ u64 p=bp[i]; if(p*p>=hi) break; u64 f=p*p; if(f<lo){ f=((lo+p-1)/p)*p; } if(!(f&1)) f+=p; for(u64 j=f;j<hi;j+=2*p) s[(j-lo)>>1]=0; }
    if(lo==0){ s[0]=0; } // 1 is not prime
    for(u64 j=0;j<(hi-lo)/2;j++) if(s[j]){ u64 n=lo+2*j+1; bits[n>>7]|=1ULL<<((n>>1)&63);} }
  free(s); return 0; }
static u64 nextN; static pthread_mutex_t mu=PTHREAD_MUTEX_INITIALIZER;
static void *work(void*_){ const u64 CH=1ULL<<24;
  for(;;){ pthread_mutex_lock(&mu); u64 a=nextN; nextN+=CH; pthread_mutex_unlock(&mu); if(a>=LIM) break; u64 b=a+CH>LIM?LIM:a+CH;
    for(int ki=0;ki<NK;ki++){ u64 k=KS[ki]; u64 n0=a; if(n0<2*k+4) n0=2*k+4; if(!(n0&1)) n0++;
      for(u64 N=n0;N<b;N+=2){ int ok=0;
        for(u64 py=2; k*py+2 < N && !ok; py<<=1){ u64 r=N-k*py; // need r - 2^x odd prime >=3
          for(u64 px=2; px+3<=r; px<<=1){ u64 p=r-px; if(ISP(p)){ ok=1; break; } } }
        if(!ok){ pthread_mutex_lock(&mu); printf("EXC k=%llu N=%llu\n",k,N); fflush(stdout); pthread_mutex_unlock(&mu);} } } }
  return 0; }
int main(int c,char**v){ LIM=strtoull(v[1],0,10); T=atoi(v[2]); NK=c-3; for(int i=0;i<NK;i++) KS[i]=strtoull(v[3+i],0,10);
  bits=calloc(LIM/128+2,8); u64 R=(u64)sqrtl((long double)LIM)+2; char*cp=calloc(R+1,1); bp=malloc(4*R);
  for(u64 i=3;i<=R;i+=2) if(!cp[i]){ bp[nbp++]=i; for(u64 j=i*i;j<=R;j+=2*i) cp[j]=1; }
  pthread_t th[64]; for(long t=0;t<T;t++) pthread_create(&th[t],0,sieve,(void*)t); for(int t=0;t<T;t++) pthread_join(th[t],0);
  u64 cnt=0; for(u64 i=0;i<LIM/128+2;i++) cnt+=__builtin_popcountll(bits[i]); printf("odd primes below %llu: %llu\n",LIM,cnt); fflush(stdout);
  nextN=0; for(int t=0;t<T;t++) pthread_create(&th[t],0,work,0); for(int t=0;t<T;t++) pthread_join(th[t],0); printf("END LIM=%llu\n",LIM); }
