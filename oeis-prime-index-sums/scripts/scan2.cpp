// Pass B slim (engine 1, primesieve): scan primes in (lo,hi] with known prefix state at lo; test many OEIS predicates.
// args: lo hi k0 S0 Q0 E0 O0 pprev   (k0 = pi(lo); S0,Q0 sums of p,p^2 for p<=lo; E0/O0 sums over even/odd global index; pprev = largest prime <= lo)
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
typedef unsigned __int128 u128; typedef uint64_t u64;
static u128 parse(const char*s){u128 v=0; while(*s) v=v*10+(*s++-'0'); return v;}
static void pr(u128 v){ char b[64]; int i=63; b[i]=0; if(!v){printf("0");return;} while(v){b[--i]='0'+(int)(v%10); v/=10;} printf("%s",b+i); }
static inline u64 mod128(u128 x,u64 d){ u64 hi=(u64)(x>>64), lo=(u64)x, r; hi%=d; __asm__("divq %4":"=a"(lo),"=d"(r):"a"(lo),"d"(hi),"r"(d)); return r; }
static bool qr64[64],qr63[63],qr65[65],qr11[11];
static bool isq(u128 x){ if(!qr64[(unsigned)(x&63)]) return false; if(!qr63[mod128(x,63)]||!qr65[mod128(x,65)]||!qr11[mod128(x,11)]) return false;
  long double r=sqrtl((long double)x); u128 s=(u128)r; if(s>2) s-=2; while((s+1)*(s+1)<=x) s++; while(s*s>x) s--; return s*s==x; }
#define HIT(name) { printf(name " k=%llu p=%llu\n",(unsigned long long)k,(unsigned long long)p); fflush(stdout);} 
int main(int c,char**v){
  for(int i=0;i<64;i++)qr64[(i*i)%64]=1; for(int i=0;i<63;i++)qr63[(i*i)%63]=1; for(int i=0;i<65;i++)qr65[(i*i)%65]=1; for(int i=0;i<11;i++)qr11[(i*i)%11]=1;
  u64 lo=strtoull(v[1],0,10),hi=strtoull(v[2],0,10),k=strtoull(v[3],0,10); u128 S=parse(v[4]),Q=parse(v[5]),E=parse(v[6]),O=parse(v[7]); u64 pp=strtoull(v[8],0,10);
  primesieve::iterator it(lo+1); u64 p;
  while((p=it.next_prime())<=hi){
    k++; S+=p; u128 p2=(u128)p*p; Q+=p2;
    // A175897 for n=k-1: (k-1)*pp + k*p square
    if(k>1 && isq((u128)(k-1)*pp+(u128)k*p)) { printf("A175897 k=%llu p=%llu\n",(unsigned long long)(k-1),(unsigned long long)pp); fflush(stdout);} 
    u128 kp=(u128)k*p; if(isq(kp+k)) HIT("A073614");
    if(isq(S)) HIT("A033997"); if(isq(S+1)) HIT("A264858");
    u64 sk=mod128(S,k), sk1=mod128(S,k+1);
    if(sk1==0) HIT("A098074"); if((sk1+1)%(k+1)==0) HIT("A158682");
    if(mod128((u128)sk*sk,k)==0) HIT("A111452");
    if((mod128(Q,k+1)+1)%(k+1)==0) HIT("A153022");
    if(mod128(Q,p)==0) HIT("A077022");
    if(k&1){ O+=p; u64 j=(k+1)/2; if(mod128(O,j)==0) { printf("A263549 j=%llu p=%llu\n",(unsigned long long)j,(unsigned long long)p); fflush(stdout);} }
    else { E+=p; u64 j=k/2; if(mod128(E,j)==0) { printf("A263546 j=%llu p=%llu\n",(unsigned long long)j,(unsigned long long)p); fflush(stdout);} }
    pp=p;
  }
  printf("# END lo=%llu hi=%llu k=%llu S=",(unsigned long long)lo,(unsigned long long)hi,(unsigned long long)k); pr(S); printf(" Q="); pr(Q); printf(" E="); pr(E); printf(" O="); pr(O); printf(" last=%llu\n",(unsigned long long)pp); }
