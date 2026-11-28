// seg3 = seg2 (own segmented sieve, Newton isqrt, no primesieve) + exact quadratic-residue
// pre-filters mod 64, 63, 65, 11 (tables built by squaring every residue) and an odd-only sieve.
// For primes p in (LO, HI], with k0 = pi(LO) given, report m = pi(p) with m*(p+1) a square (A073614).
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdint.h>
typedef unsigned __int128 u128;
static u128 isqrt128(u128 x){ if(x<2) return x; int b=(x>>64)? 128-__builtin_clzll((uint64_t)(x>>64)) : 64-__builtin_clzll((uint64_t)x);
  u128 r=(u128)1<<((b+1)/2); for(;;){ u128 y=(r+x/r)>>1; if(y>=r) return r; r=y; } }
static char q64[64],q63[63],q65[65],q11[11];
int main(int argc,char**argv){
  uint64_t LO=strtoull(argv[1],0,10), HI=strtoull(argv[2],0,10), k=strtoull(argv[3],0,10);
  for(int i=0;i<64;i++) q64[(i*i)%64]=1; for(int i=0;i<63;i++) q63[(i*i)%63]=1;
  for(int i=0;i<65;i++) q65[(i*i)%65]=1; for(int i=0;i<11;i++) q11[(i*i)%11]=1;
  if(LO<2 && HI>=2){ k++; u128 v=(u128)k*3; u128 r=isqrt128(v); if(r*r==v) printf("hit m=%llu p=2\n",(unsigned long long)k); }
  uint64_t start = (LO<3)? 3 : ((LO%2)? LO+2 : LO+1);   // first odd number > LO, at least 3
  uint64_t sq=1; while(sq*sq<=HI) sq++;
  char *small=calloc(sq+1,1); uint32_t *pr=malloc(sizeof(uint32_t)*sq); int np=0;
  for(uint64_t i=3;i<=sq;i+=2) if(!small[i]){ pr[np++]=i; for(uint64_t j=i*i;j<=sq;j+=2*i) small[j]=1; }
  const uint64_t SEG=1<<23; char *seg=malloc(SEG); // index t <-> x = a + 2t
  for(uint64_t a=start;a<=HI;a+=2*SEG){ uint64_t b=a+2*(SEG-1); if(b>HI) b=HI; if(b%2==0) b--; uint64_t len=(b-a)/2+1; memset(seg,0,len);
    for(int i=0;i<np;i++){ uint64_t p=pr[i]; if(p*p>b) break; uint64_t s=((a+p-1)/p)*p; if(s<p*p) s=p*p; if(s%2==0) s+=p;
      for(uint64_t j=(s-a)/2;j<len;j+=p) seg[j]=1; }
    for(uint64_t t=0;t<len;t++) if(!seg[t]){ uint64_t x=a+2*t; if(x<3) continue; k++;
      uint64_t y=x+1;
      if(!q64[((k%64)*(y%64))%64]) continue; if(!q63[((k%63)*(y%63))%63]) continue;
      if(!q65[((k%65)*(y%65))%65]) continue; if(!q11[((k%11)*(y%11))%11]) continue;
      u128 v=(u128)k*y; u128 r=isqrt128(v); if(r*r==v){ printf("hit m=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)x); fflush(stdout);} }
  }
  printf("END hi=%llu pi=%llu\n",(unsigned long long)HI,(unsigned long long)k); return 0; }
