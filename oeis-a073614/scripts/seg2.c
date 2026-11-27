// Independent second scan (own segmented sieve, Newton isqrt, no primesieve):
// for primes p in (LO, HI], with k0 = pi(LO) given, report m with m*(p+1) square (A073614).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
typedef unsigned __int128 u128;
static u128 isqrt128(u128 x){ if(x<2) return x; u128 r=(u128)1<<((128-__builtin_clzll((uint64_t)(x>>64)|1)+ (x>>64?64:0))/2+1); if(!(x>>64)){ uint64_t lo=(uint64_t)x; int b=64-__builtin_clzll(lo); r=(u128)1<<((b+1)/2);} 
  for(;;){ u128 y=(r+x/r)>>1; if(y>=r) return r; r=y; } }
int main(int argc,char**argv){
  uint64_t LO=strtoull(argv[1],0,10), HI=strtoull(argv[2],0,10), k=strtoull(argv[3],0,10);
  uint64_t sq=1; while(sq*sq<=HI) sq++;
  char *small=calloc(sq+1,1); uint32_t *pr=malloc(sizeof(uint32_t)*sq); int np=0;
  for(uint64_t i=2;i<=sq;i++) if(!small[i]){ pr[np++]=i; for(uint64_t j=i*i;j<=sq;j+=i) small[j]=1; }
  const uint64_t SEG=1<<24; char *seg=malloc(SEG);
  for(uint64_t a=LO+1;a<=HI;a+=SEG){ uint64_t b=a+SEG-1; if(b>HI) b=HI; memset(seg,0,b-a+1);
    for(int i=0;i<np;i++){ uint64_t p=pr[i]; if(p*p>b) break; uint64_t s=((a+p-1)/p)*p; if(s<p*p) s=p*p; for(uint64_t j=s;j<=b;j+=p) seg[j-a]=1; }
    for(uint64_t x=a;x<=b;x++) if(!seg[x-a] && x>1){ k++; u128 v=(u128)k*(x+1); u128 r=isqrt128(v); if(r*r==v) { printf("hit m=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)x); fflush(stdout);} }
  }
  printf("END hi=%llu pi=%llu\n",(unsigned long long)HI,(unsigned long long)k); return 0; }
