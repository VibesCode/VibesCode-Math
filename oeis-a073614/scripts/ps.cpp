// One pass over primes p_k <= LIMIT: A264858 (S_k+1 square, S_k = sum of first k primes) and A073614 (k*(p_k+1) square).
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cmath>
#include <cstdint>
typedef unsigned __int128 u128;
static bool qr64[64], qr63[63], qr65[65], qr11[11];
static bool isq(u128 x, u128 *root){
  if(!qr64[(unsigned)(x&63)]) return false;
  if(!qr63[(unsigned)(x%63)] || !qr65[(unsigned)(x%65)] || !qr11[(unsigned)(x%11)]) return false;
  long double r=sqrtl((long double)x); u128 s=(u128)r; if(s>2) s-=2; while((s+1)*(s+1)<=x) s++; while(s*s>x) s--;
  if(s*s==x){*root=s; return true;} return false; }
static void pr(u128 v){ char b[64]; int i=63; b[i]=0; if(!v){printf("0");return;} while(v){b[--i]='0'+(int)(v%10); v/=10;} printf("%s",b+i); }
int main(int argc,char**argv){
  for(int i=0;i<64;i++) qr64[(i*i)%64]=1; for(int i=0;i<63;i++) qr63[(i*i)%63]=1; for(int i=0;i<65;i++) qr65[(i*i)%65]=1; for(int i=0;i<11;i++) qr11[(i*i)%11]=1;
  uint64_t LIMIT=strtoull(argv[1],0,10), REPORT=strtoull(argv[2],0,10);
  primesieve::iterator it; uint64_t p; u128 S=0, r; uint64_t k=0; uint64_t next=REPORT;
  while((p=it.next_prime())<=LIMIT){ k++; S+=p;
    if(isq(S+1,&r)){ printf("A264858 k=%llu p=%llu S+1=",(unsigned long long)k,(unsigned long long)p); pr(S+1); printf(" =("); pr(r); printf(")^2\n"); fflush(stdout);}
    if(isq((u128)k*(p+1),&r)){ printf("A073614 m=%llu p=%llu m(p+1)=(",(unsigned long long)k,(unsigned long long)p); pr(r); printf(")^2\n"); fflush(stdout);}
    if(p>=next){ printf("# reached p=%llu k=%llu S=",(unsigned long long)p,(unsigned long long)k); pr(S); printf("\n"); fflush(stdout); next+=REPORT; }
  }
  printf("# END limit=%llu pi=%llu S=",(unsigned long long)LIMIT,(unsigned long long)k); pr(S); printf("\n"); return 0; }
