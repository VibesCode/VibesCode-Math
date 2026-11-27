// Independent second scan for A226472 (n^2 XOR n(n+1)/2 a square), n in [LO,HI).
// Differs from xs.c: the 128-bit value is built from two 64-bit words by hand (no __int128 products),
// filters are mod 256, 9, 5, 7, 13, 17 (tables by squaring), and the root comes from a double estimate
// refined by integer Newton steps with an exact final check.
#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <math.h>
typedef unsigned __int128 u128;
static void mul64(uint64_t a,uint64_t b,uint64_t*hi,uint64_t*lo){ uint64_t a0=a&0xffffffff,a1=a>>32,b0=b&0xffffffff,b1=b>>32;
  uint64_t p00=a0*b0,p01=a0*b1,p10=a1*b0,p11=a1*b1; uint64_t mid=(p00>>32)+(p01&0xffffffff)+(p10&0xffffffff);
  *lo=(mid<<32)|(p00&0xffffffff); *hi=p11+(p01>>32)+(p10>>32)+(mid>>32); }
static char t256[256],t9[9],t5[5],t7[7],t13[13],t17[17];
static unsigned modw(uint64_t hi,uint64_t lo,unsigned m){ // (hi*2^64+lo) mod m
  uint64_t r=hi%m; for(int i=0;i<64;i++){ r=(r*2+((lo>>(63-i))&1))%m; } return (unsigned)r; }
int main(int c,char**v){ uint64_t LO=strtoull(v[1],0,10),HI=strtoull(v[2],0,10);
  for(int i=0;i<256;i++)t256[(i*i)&255]=1; for(int i=0;i<9;i++)t9[i*i%9]=1; for(int i=0;i<5;i++)t5[i*i%5]=1;
  for(int i=0;i<7;i++)t7[i*i%7]=1; for(int i=0;i<13;i++)t13[i*i%13]=1; for(int i=0;i<17;i++)t17[i*i%17]=1;
  for(uint64_t n=LO;n<HI;n++){ uint64_t sh,sl,th,tl; mul64(n,n,&sh,&sl);
    uint64_t x=n,y=n+1; if(x%2==0) x/=2; else y/=2; mul64(x,y,&th,&tl);   // T = n(n+1)/2 exactly
    uint64_t ah=sh^th, al=sl^tl;
    if(!t256[al&255]) continue;
    // cheap residues: 2^64 mod m precomputed would be faster, but keep it simple and exact
    u128 a=((u128)ah<<64)|al;
    if(!t9[(unsigned)(a%9)]||!t5[(unsigned)(a%5)]||!t7[(unsigned)(a%7)]||!t13[(unsigned)(a%13)]||!t17[(unsigned)(a%17)]) continue;
    if(a<2){ printf("hit n=%llu\n",(unsigned long long)n); continue; }
    u128 r=(u128)sqrt((double)a)+1; for(int it=0;it<100;it++){ u128 q=(r+a/r)>>1; if(q>=r) break; r=q; }
    while(r*r>a) r--; while((r+1)*(r+1)<=a) r++;
    if(r*r==a){ printf("hit n=%llu\n",(unsigned long long)n); fflush(stdout);} }
  printf("END [%llu,%llu)\n",(unsigned long long)LO,(unsigned long long)HI); return 0; }
