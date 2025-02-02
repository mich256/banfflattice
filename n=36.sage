n=36

def LinPLUfacofcoxeter(P):
    U=P.lequal_matrix()
    C=-U.inverse()*U.transpose()
    W=C.LU()
    L=W[1]
    return(L)

def givelatticeminusoneelement(W):
    L=W[0]
    t=W[1]
    UU=[p for p in L if not p==t]
    P=L.subposet(UU)
    return(P)



def giveallelementsnotmeetorjoin(L):
    U=L.list()
    T1=L.join_irreducibles()
    T2=L.meet_irreducibles()
    r1=L.bottom()
    r2=L.top()
    UU=[p for p in U if not (p in T1) and not (p in T2) and not (p==r1) and not (p==r2)]
    return(UU)

def giveauslanderregularpoints(L):
    U=giveallelementsnotmeetorjoin(L)
    UU=[p for p in U if LinPLUfacofcoxeter(givelatticeminusoneelement([L,p]))==identity_matrix(len(givelatticeminusoneelement([L,p])))]
    return(UU)

L=posets.RandomLattice(n,0.7,properties=['distributive']);
L=L.relabel()
display(giveauslanderregularpoints(L))
plot(L,figsize=30)