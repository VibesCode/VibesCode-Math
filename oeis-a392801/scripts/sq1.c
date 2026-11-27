// A392801: k such that the sum of the first k squarefree numbers is a square.
// Scan squarefree x in [1, N]; running k and 128-bit sum S; report k when S is a square.
// Segmented sieve: mark multiples of p^2 for primes p <= sqrt(N). Prints Q(N) and S at the end.
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
#include <math.h>
typedef unsigned __int128 u128;
static char q64[64],q63[63],q65[65],q11[11];
static void pr128(u128 v){ char b[50];int k=0; do{b[k++]='0'+(int)(v%10);v/=10;}while(v); while(k) putchar(b[--k]); }
static u128 parse128(const char*p){ u128 v=0; while(*p) v=v*10+(*p++-'0'); return v; }
// usage: sq1 LO HI Q(LO) S(LO)   scans squarefree x in (LO, HI]
int main(int c,char**v){ uint64_t LO=strtoull(v[1],0,10), N=strtoull(v[2],0,10), REP=0;
  for(int i=0;i<64;i++)q64[(i*i)%64]=1; for(int i=0;i<63;i++)q63[(i*i)%63]=1;
  for(int i=0;i<65;i++)q65[(i*i)%65]=1; for(int i=0;i<11;i++)q11[(i*i)%11]=1;
  uint64_t r=(uint64_t)sqrt((double)N)+2; char*cmp=calloc(r+1,1); uint64_t*P=malloc(8*(r+1)); int np=0;
  for(uint64_t i=2;i<=r;i++) if(!cmp[i]){ P[np++]=i; for(uint64_t j=i*i;j<=r;j+=i) cmp[j]=1; }
  const uint64_t SEG=1<<24; char*s=malloc(SEG); uint64_t k=strtoull(v[3],0,10); u128 S=parse128(v[4]); uint64_t nextrep=REP;
  for(uint64_t a=LO+1;a<=N;a+=SEG){ uint64_t b=a+SEG-1; if(b>N) b=N; memset(s,0,b-a+1);
    for(int i=0;i<np;i++){ uint64_t q=P[i]*P[i]; if(q>b) break; uint64_t st=((a+q-1)/q)*q; for(uint64_t j=st;j<=b;j+=q) s[j-a]=1; }
    for(uint64_t x=a;x<=b;x++) if(!s[x-a]){ k++; S+=x;
      if(!q64[(unsigned)(S&63)]) continue; if(!q63[(unsigned)(S%63)]||!q65[(unsigned)(S%65)]||!q11[(unsigned)(S%11)]) continue;
      long double d=sqrtl((long double)S); u128 t=(u128)d; while(t*t>S) t--; while((t+1)*(t+1)<=S) t++;
      if(t*t==S){ printf("hit k=%llu x=%llu S=",(unsigned long long)k,(unsigned long long)x); pr128(S); printf(" root="); pr128(t); putchar('\n'); fflush(stdout);} }
    if(REP && b>=nextrep){ printf("# reached %llu Q=%llu S=",(unsigned long long)b,(unsigned long long)k); pr128(S); putchar('\n'); fflush(stdout); nextrep+=REP; }
  }
  printf("END N=%llu Q=%llu S=",(unsigned long long)N,(unsigned long long)k); pr128(S); putchar('\n'); return 0; }
