import sys
cnf,model,out=sys.argv[1:4]
A=[int(l) for l in open(cnf+".elems")]
pos={int(t) for l in open(model) for t in l.split() if int(t)>0}
K=[a for i,a in enumerate(A) if i+1 in pos]
open(out,"w").write("\n".join(map(str,K))+"\n"); print(len(K),"kept")
