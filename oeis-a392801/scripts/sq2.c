// Independent second scan for A392801: squarefree x in (LO,HI], running k and sum S from (Q0,S0); report k when S is a square.
// Differs from sq1.c: bitset sieve over odd p^2 plus a separate x%4 test, filters mod 256,9,5,7,13,17, Newton root.
// Differs from xs.c: the 128-bit value is built from two 64-bit words by hand (no __int128 products),
// filters are mod 256, 9, 5, 7, 13, 17 (tables by squaring), and the root comes from a double estimate
// refined by integer Newton steps with an exact final check.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
#include <string.h>
typedef unsigned __int128 u128;
static void mul64(uint64_t a,uint64_t b,uint64_t*hi,uint64_t*lo){ uint64_t a0=a&0xffffffff,a1=a>>32,b0=b&0xffffffff,b1=b>>32;
  uint64_t p00=a0*b0,p01=a0*b1,p10=a1*b0,p11=a1*b1; uint64_t mid=(p00>>32)+(p01&0xffffffff)+(p10&0xffffffff);
  *lo=(mid<<32)|(p00&0xffffffff); *hi=p11+(p01>>32)+(p10>>32)+(mid>>32); }
static char t256[256],t9[9],t5[5],t7[7],t13[13],t17[17];
static u128 parse128(const char*p){ u128 v=0; while(*p) v=v*10+(*p++-'0'); return v; }
static void pr128(u128 v){ char b[50];int k=0; do{b[k++]='0'+(int)(v%10);v/=10;}while(v); while(k) putchar(b[--k]); }
static int issq(u128 a){ if(!t256[(unsigned)(a&255)]) return 0; if(a<2) return 1;
  if(!t9[(unsigned)(a%9)]||!t5[(unsigned)(a%5)]||!t7[(unsigned)(a%7)]||!t13[(unsigned)(a%13)]||!t17[(unsigned)(a%17)]) return 0;
  u128 r=(u128)sqrt((double)a)+1; for(int it=0;it<200;it++){ u128 q=(r+a/r)>>1; if(q>=r) break; r=q; }
  while(r*r>a) r--; while((r+1)*(r+1)<=a) r++; return r*r==a; }
int main(int c,char**v){ uint64_t LO=strtoull(v[1],0,10),HI=strtoull(v[2],0,10),k=strtoull(v[3],0,10); u128 S=parse128(v[4]);
  for(int i=0;i<256;i++)t256[(i*i)&255]=1; for(int i=0;i<9;i++)t9[i*i%9]=1; for(int i=0;i<5;i++)t5[i*i%5]=1;
  for(int i=0;i<7;i++)t7[i*i%7]=1; for(int i=0;i<13;i++)t13[i*i%13]=1; for(int i=0;i<17;i++)t17[i*i%17]=1;
  uint64_t r=1; while(r*r<=HI) r++; uint8_t*cp=calloc(r+1,1); uint64_t*P=malloc(8*(r+1)); int np=0;
  for(uint64_t i=3;i<=r;i+=2) if(!cp[i]){ P[np++]=i; for(uint64_t j=i*i;j<=r;j+=2*i) cp[j]=1; }
  const uint64_t W=1<<26; uint64_t *bits=malloc(W/8);
  for(uint64_t a=LO+1;a<=HI;a+=W){ uint64_t b=a+W-1; if(b>HI) b=HI; uint64_t len=b-a+1; memset(bits,0,(len+63)/64*8);
    for(int i=0;i<np;i++){ uint64_t q=P[i]*P[i]; if(q>b) break; uint64_t st=a%q? a+(q-a%q) : a; for(uint64_t j=st;j<=b;j+=q){ uint64_t t=j-a; bits[t>>6]|=1ULL<<(t&63);} }
    for(uint64_t t=0;t<len;t++){ uint64_t x=a+t; if((x&3)==0) continue; if(bits[t>>6]>>(t&63)&1) continue;
      k++; S+=x; if(issq(S)){ printf("hit k=%llu x=%llu S=",(unsigned long long)k,(unsigned long long)x); pr128(S); putchar('\n'); fflush(stdout);} } }
  printf("END N=%llu Q=%llu S=",(unsigned long long)HI,(unsigned long long)k); pr128(S); putchar('\n'); return 0; }
