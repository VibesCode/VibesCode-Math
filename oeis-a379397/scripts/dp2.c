/* Program 3: C DP, recursion on the largest part (Robert Israel's recurrence, bottom-up):
   W[c][t][n] = # multisets of <= t positive cubes, all <= c^3, sum n.
   W[c][t][n] = sum_{j=0..t, j c^3 <= n} W[c-1][t-j][n - j c^3]. Keeps two layers. */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc,char**argv){ long N=atol(argv[1]); int C=1; while((long)(C+1)*(C+1)*(C+1)<=N) C++;
  long long *A=calloc(10*(N+1),8),*B=calloc(10*(N+1),8);
  for(int t=0;t<10;t++) A[t*(N+1)+0]=1;               /* c = 0: only n = 0 */
  for(int c=1;c<=C;c++){ long q=(long)c*c*c; memset(B,0,10*(N+1)*8);
    for(int t=0;t<10;t++) for(long n=0;n<=N;n++){ long long s=0;
      for(int j=0;j<=t && j*q<=n;j++) s+=A[(t-j)*(N+1)+n-j*q]; B[t*(N+1)+n]=s; }
    long long*T=A;A=B;B=T; }
  for(int k=1;k<=atoi(argv[2]);k++){ long c=0,last=-1; for(long n=1;n<=N;n++) if(A[9*(N+1)+n]==k){c++;last=n;}
    printf("LAST %d %ld %ld\n",k,c,last); }
  long bad=0; for(long n=1;n<=N;n++) if(A[8*(N+1)+n]==0) printf("NOT8 %ld\n",n);
  return 0; }
