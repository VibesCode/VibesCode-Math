// Pass A: for chunk (lo,hi] of primes: count, sum p, sum p^2, sum of p at local odd positions (1st,3rd,..) . u128 printed.
#include <primesieve.hpp>
#include <cstdio>
#include <cstdlib>
#include <cstdint>
typedef unsigned __int128 u128;
static void pr(u128 v){ char b[64]; int i=63; b[i]=0; if(!v){printf("0");return;} while(v){b[--i]='0'+(int)(v%10); v/=10;} printf("%s",b+i); }
int main(int c,char**v){ uint64_t lo=strtoull(v[1],0,10),hi=strtoull(v[2],0,10);
  primesieve::iterator it(lo+1); uint64_t p,n=0; u128 S=0,Q=0,Sodd=0;
  while((p=it.next_prime())<=hi){ n++; S+=p; Q+=(u128)p*p; if(n&1) Sodd+=p; }
  printf("%llu %llu %llu ",(unsigned long long)lo,(unsigned long long)hi,(unsigned long long)n); pr(S); printf(" "); pr(Q); printf(" "); pr(Sodd); printf("\n"); }
