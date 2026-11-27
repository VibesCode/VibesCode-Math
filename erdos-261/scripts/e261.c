// Complete search for Erdos 261(ii): n/2^n = sum_{k in S} k/2^k, S finite, |S|>=2, all k>n necessarily.
// State E_m = 2^m (n/2^n - partial sum over chosen k<=m). E_n=n; E_{m+1} in {2E, 2E-(m+1)} within [0, m+3].
#include <stdio.h>
#include <stdlib.h>
int main(int argc,char**argv){
  long a=atol(argv[1]), b=atol(argv[2]); long cap=atol(argv[3]);
  long worstd=0,worstn=0; int maxst=0; long fails=0;
  long *S=malloc(sizeof(long)*100000),*T=malloc(sizeof(long)*100000);
  for(long n=a;n<=b;n++){
    int ns=1; S[0]=n; long m=n; int hit=0;
    while(m-n<cap){
      int nt=0;
      for(int i=0;i<ns;i++){ long e=S[i]; long x=2*e, y=x-(m+1);
        if(x<=m+3) T[nt++]=x; if(y>=0 && y<=m+3) T[nt++]=y; }
      // dedupe (small)
      int k=0; for(int i=0;i<nt;i++){int d=0; for(int j=0;j<k;j++) if(T[j]==T[i]){d=1;break;} if(!d) T[k++]=T[i];}
      m++; long*t=S;S=T;T=t; ns=k; if(ns>maxst) maxst=ns;
      for(int i=0;i<ns;i++) if(S[i]==0){hit=1;break;}
      if(hit) break;
    }
    if(!hit){fails++; printf("NOHIT n=%ld within %ld levels\n",n,cap); fflush(stdout); continue;}
    if(m-n>worstd){worstd=m-n;worstn=n; printf("worst n=%ld depth=%ld\n",n,worstd); fflush(stdout);}
  }
  printf("DONE %ld..%ld worst depth %ld at n=%ld, max states %d, nohit %ld\n",a,b,worstd,worstn,maxst,fails);
}
