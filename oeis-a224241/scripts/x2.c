// A224241: k such that k^2 XOR (k+1)^2 and k^2 XOR (k+2)^2 are both squares. Scan k in [LO,HI).
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
typedef unsigned __int128 u128;
static char q64[64],q63[63],q65[65],q11[11];
static int issq(u128 a){
  if(!q64[(unsigned)(a&63)]) return 0;
  if(!q63[(unsigned)(a%63)]||!q65[(unsigned)(a%65)]||!q11[(unsigned)(a%11)]) return 0;
  long double d=sqrtl((long double)a); u128 r=(u128)d; while(r*r>a) r--; while((r+1)*(r+1)<=a) r++; return r*r==a; }
int main(int c,char**v){ uint64_t LO=strtoull(v[1],0,10),HI=strtoull(v[2],0,10);
  for(int i=0;i<64;i++)q64[(i*i)%64]=1; for(int i=0;i<63;i++)q63[(i*i)%63]=1;
  for(int i=0;i<65;i++)q65[(i*i)%65]=1; for(int i=0;i<11;i++)q11[(i*i)%11]=1;
  for(uint64_t k=LO;k<HI;k++){ u128 K=k; u128 a=K*K, b=(K+1)*(K+1), c2=(K+2)*(K+2);
    if(issq(a^b) && issq(a^c2)){ printf("hit k=%llu\n",(unsigned long long)k); fflush(stdout);} }
  printf("END [%llu,%llu)\n",(unsigned long long)LO,(unsigned long long)HI); return 0; }
