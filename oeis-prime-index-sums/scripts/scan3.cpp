// Batch 2, engine 1 (primesieve). Predicates on consecutive primes, index k, sum S, and 70/120-prime window sums.
// args: lo hi k0 S0   (k0 = pi(lo), S0 = sum of primes <= lo). Index of a hit = the k named in each sequence.
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
#include <cmath>
#include <vector>
typedef unsigned __int128 u128; typedef uint64_t u64;
static u128 parse(const char*s){u128 v=0; while(*s) v=v*10+(*s++-'0'); return v;}
static inline u64 mod128(u128 x,u64 d){ u64 hi=(u64)(x>>64), lo=(u64)x, r; hi%=d; __asm__("divq %4":"=a"(lo),"=d"(r):"a"(lo),"d"(hi),"r"(d)); return r; }
static bool qr64[64],qr63[63],qr65[65],qr11[11];
static bool isq(u128 x, u128* rt=0){ if(!qr64[(unsigned)(x&63)]) return false; if(!qr63[mod128(x,63)]||!qr65[mod128(x,65)]||!qr11[mod128(x,11)]) return false;
  long double r=sqrtl((long double)x); u128 s=(u128)r; if(s>2) s-=2; while((s+1)*(s+1)<=x) s++; while(s*s>x) s--; if(rt) *rt=s; return s*s==x; }
static bool isprime64(u64 n){ if(n<2) return false; for(u64 d=2;d*d<=n;d++) if(n%d==0) return false; return true; }
#define OUT(name,idx,pv) { printf(name " k=%llu p=%llu\n",(unsigned long long)(idx),(unsigned long long)(pv)); fflush(stdout);} 
int main(int c,char**v){
  for(int i=0;i<64;i++)qr64[(i*i)%64]=1; for(int i=0;i<63;i++)qr63[(i*i)%63]=1; for(int i=0;i<65;i++)qr65[(i*i)%65]=1; for(int i=0;i<11;i++)qr11[(i*i)%11]=1;
  u64 lo=strtoull(v[1],0,10),hi=strtoull(v[2],0,10),k=strtoull(v[3],0,10); u128 S=parse(v[4]);
  // history: the last 121 primes <= lo, gathered by iterating back
  std::vector<u64> hist; { primesieve::iterator b(lo+1); u64 q; while(hist.size()<121 && (q=b.prev_prime())>=2) hist.push_back(q); }
  // ring: window of last W primes; we keep a deque-like vector with absolute positions
  const int W1=70,W2=120; std::vector<u64> ring(256,0); u64 pos=k; // ring[(index)&255] = prime with that index
  for(size_t i=0;i<hist.size();i++) ring[(k-i)&255]=hist[i];
  u128 w1=0,w2=0; for(int i=0;i<W1 && (u64)i<hist.size();i++) w1+=hist[i]; for(int i=0;i<W2 && (u64)i<hist.size();i++) w2+=hist[i];
  primesieve::iterator it(lo+1); u64 p;
  while((p=it.next_prime())<=hi){
    k++; S+=p; ring[k&255]=p; u64 pm1=ring[(k-1)&255], pm2=ring[(k-2)&255];
    // window sums ending at k: start index k-W+1
    w1+=p; if(k>W1) w1-=ring[(k-W1)&255]; w2+=p; if(k>W2) w2-=ring[(k-W2)&255];
    if(k>=W1 && isq(w1)) OUT("A166255",k-W1+1,ring[(k-W1+1)&255]);
    if(k>=W2 && isq(w2)) OUT("A166261",k-W2+1,ring[(k-W2+1)&255]);
    if(k%2==0 && mod128(S,k)==k/2) OUT("A263076",k,p);
    if(k>=2){ u64 j=k-1; // pairs (p_j, p_{j+1}) = (pm1, p)
      if(((u128)pm1+p)%(2*j+1)==0) OUT("A278693",j,pm1);
      if(isq((u128)pm1*pm1+(u128)p*p-1)) OUT("A160054",j,pm1);
      if(isq((u128)pm1+2*(u128)p)) OUT("A064504",j,pm1);
      { u128 a=(u128)j*p, b=(u128)(j+1)*pm1; if(a>=b && (a==b || isq(a-b))) OUT("A067805",j,pm1); } }
    if(k>=3 && p-pm2==8 && isq((u128)pm2+7)) OUT("A158470",k-1,ring[(k-1)&255]);
    { u128 r; if(isq((u128)k+p,&r) && isprime64((u64)r)) OUT("A104911",k,p); }
  }
  printf("# END k=%llu\n",(unsigned long long)k); }
