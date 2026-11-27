#include <bits/stdc++.h>
int main(){const int N=10000000;std::vector<int> ph(N+1);for(int i=0;i<=N;i++)ph[i]=i;for(int i=2;i<=N;i++)if(ph[i]==i)for(int j=i;j<=N;j+=i)ph[j]-=ph[j]/i;
for(int n=1;n<=N;n++){long long p=1;for(int m=n;m;m/=10)p*=m%10;if(p==ph[n])printf("%d\n",n);}}
