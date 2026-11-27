// A245212 search by odd part: for odd m <= M, test every k >= 0 for a(2^k m) = sigma(2^k m),
// using the exact reduction 2^(k+1) * (v - k*u) = u + v, u = G(m) - m*tau(m), v = m*tau(m) - sigma(m),
// G(m) = sum_{d|m} d*tau(d). Also tallies the parity obstruction (u odd).
#include <stdio.h>
#include <stdlib.h>
typedef unsigned long long u64; typedef __int128 i128;
int main(int c,char**v){ long M=atol(v[1]);
 unsigned *tau=calloc(M+1,4); u64 *sig=calloc(M+1,8),*G=calloc(M+1,8);
 for(long d=1;d<=M;d+=2) for(long m=d;m<=M;m+=2*d){sig[m]+=d;tau[m]++;}
 for(long d=1;d<=M;d+=2){u64 w=(u64)d*tau[d]; for(long m=d;m<=M;m+=2*d) G[m]+=w;}
 long hits=0, uodd=0, eqval=0, tot=0; double bestrel=1e9; long bestm=0,bestk=0;
 for(long m=3;m<=M;m+=2){ tot++;
  i128 T=(i128)m*tau[m], u=(i128)G[m]-T, vv=T-(i128)sig[m];
  if(u&1) uodd++;
  for(long k=0;;k++){ i128 lhs_inner=vv-(i128)k*u; if(lhs_inner<=0) break;
    if(k>120) break;
    i128 L=((i128)1<<(k+1))*lhs_inner, R=u+vv;
    if(L==R){hits++; printf("HIT m=%ld k=%ld\n",m,k);}
    // relative miss of alpha*u = beta*v, alpha=1+k*2^(k+1), beta=2^(k+1)-1
    i128 N=(i128)1<<(k+1); i128 A=(1+k*N)*u, B=(N-1)*vv; i128 D=A>B?A-B:B-A;
    double rel=(double)D/(double)A; if(rel<bestrel){bestrel=rel;bestm=m;bestk=k;}
    if(((i128)1<<(k+1)) > 4*R) break;
  }
 }
 printf("M=%ld odd m tested %ld hits %ld u-odd(parity kills) %ld closest m=%ld k=%ld rel=%.3e\n",M,tot,hits,uodd,bestm,bestk,bestrel);
}
