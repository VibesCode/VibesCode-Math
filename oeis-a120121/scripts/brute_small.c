/* Direct brute force over m = 1..N (no multiset reduction), as a sanity check of the definitions. */
#include <stdio.h>
#include <stdlib.h>
static long phi(long n){ if(n==0) return 0; long r=n,x=n; for(long p=2;p*p<=x;p++) if(x%p==0){ while(x%p==0) x/=p; r-=r/p;} if(x>1) r-=r/x; return r; }
int main(int argc,char**argv){ long N=atol(argv[1]);
 for(long m=1;m<=N;m++){ long P=1,S=0,t=m; while(t){ P*=t%10; S+=t%10; t/=10; }
  if(phi(P*S)==m) printf("A120121 %ld\n",m);
  if(phi(P)*S==m) printf("A120122 %ld\n",m);
  if(P*phi(S)==m) printf("A120123 %ld\n",m); } }
