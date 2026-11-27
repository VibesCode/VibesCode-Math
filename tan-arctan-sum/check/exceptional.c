/* List Ono's exceptional set E = {n>=5 : |x_n| > n/2 + 1} for n <= N, by summing atan(k) in long double
   (angle reduced mod pi, Kahan-compensated). Flags borderline n where the margin is < 1e-6 relative. Floating point:
   this only locates E; it proves nothing about integrality. */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
int main(int c,char**v){ long N=atol(v[1]); long double PI=3.14159265358979323846264338327950288L;
  long double s=0, comp=0;
  for(long k=1;k<=N;k++){ long double y=atanl((long double)k)-comp; long double t=s+y; comp=(t-s)-y; s=t;
    if(s>PI){ s-=PI; } long double x=tanl(s), thr=(long double)k/2+1;
    if(k>=5 && fabsl(x)>thr*(1-1e-6L)) printf("%ld x=%.6Le thr=%.1Lf %s\n",k,x,thr, fabsl(x)>thr*(1+1e-6L)?"in E":"BORDERLINE"); }
}
