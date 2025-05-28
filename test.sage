L=posets.SymmetricGroupBruhatOrderPoset(5) 
L=L.relabel()

x=Permutation([i+1 for i in L.linear_extension()]).to_matrix()
#print(x)
y=x*L.lequal_matrix()*x.inverse()
#print(x*y*x.inverse(),"\n\n")
rowmotions=[]
for _ in range(100):
    o=random_linear_extension(L)
    #display(o.plot())
    q=Permutation([i+1 for i in o])
    qm=q.to_matrix()
    #print(q.to_matrix())
    #print((qm.inverse()*y*qm).transpose())
    p=CoxeterPerm((qm.inverse()*y.transpose()*qm))
    pp=q.inverse()*p.inverse()*q
    #print(o,pp,pp.cycle_tuples(),len(pp))
    if pp not in rowmotions:
        print(pp.cycle_tuples())
        rowmotions+=[pp]

n=10
posets = [(p.with_bounds()).relabel() for p in Posets(n-2)]
ml = [LatticePoset(p) for p in posets if p.is_lattice()]
cml = [p for p in ml if p.is_modular() and not p.is_vertically_decomposable() and not p.is_distributive()]
for M in cml:
	M = M.relabel(lambda n: n+1)
	M = M.linear_extension(rank_respecting_linear_extension(M)).to_poset()
	ccv(M)
	M.plot()
	#bruhat_decomposition(M.lequal_matrix().transpose())

dim = 4
FF = FiniteField(2)
VS = VectorSpace(FF,dim)
SS = {}
SS[0] = set([VS.subspace([])])
for dim in range(1,dim+1):
    new_subspaces = set()
    for v in VS:
        for ss in SS[dim-1]:
            new_ss = ss + VS.subspace([v])
            if new_ss.dimension() == dim:
                new_subspaces.add(new_ss)
    SS[dim] = new_subspaces
ground_set = reduce(lambda x,y:x.union(y),SS.values())
L = LatticePoset((ground_set,lambda x,y: x.is_subspace(y))).relabel()
L.plot()


n = 8
posets = [(p.with_bounds()).relabel() for p in Posets(n-2)]
modularlattices = [LatticePoset(p) for p in posets if p.is_lattice() and LatticePoset(p).is_modular()]
for M in modularlattices:
	w = Permutation(CoxeterPerm(M.lequal_matrix().transpose()))
	if all([i < 3 for i in w.cycle_type()]):
		plot(M)
		print(w)

n=10
posets = [(p.with_bounds()).relabel() for p in Posets(n-2)]
trimlattices = [LatticePoset(p) for p in posets if p.is_lattice() and LatticePoset(p).is_trim() and not LatticePoset(p).is_distributive()]
all([conj_Colin(L) for L in trimlattices])


n=7
posets = [(p.with_bounds()).relabel() for p in Posets(n-2)]
modularlattices = [LatticePoset(p) for p in posets if p.is_lattice() and LatticePoset(p).is_modular() and not LatticePoset(p).is_distributive()]
for M in modularlattices:
	M = M.relabel().relabel(lambda n: n+1)
	plot(M)
	print(CoxeterPerm(M.lequal_matrix().transpose()))

n=9
posets = [(p.with_bounds()).relabel() for p in Posets(n-2)]
lattices = [LatticePoset(p) for p in posets if p.is_lattice() and not LatticePoset(p).is_distributive()]
for M in lattices:
	M = M.relabel().relabel(lambda n: n+1)
	O=M.linear_extensions()
	OO=[M.linear_extension(x).to_poset() for x in O]
	all([mp_to_jp(x) for x in OO])

L=posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)
W=L.lequal_matrix().transpose()
P=CoxeterPerm(W)
display(P)
plot(L)

Here how to get all Coxeter permutations of all linear extensions of a given poset:
L= posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)
O=L.linear_extensions()
OO=[L.linear_extension(x).to_poset() for x in O]
OO2=[CoxeterPerm(x.lequal_matrix().transpose()) for x in OO]
display(OO2)
plot(L)

p2 = posets.DiamondPoset(5)
p1 = posets.ChainPoset(2)
L = product(p1,p2)
L.lequal_matrix().transpose()

posets = [p for p in Posets(n-2)]
dissectiveposets = [p.with_bounds() for p in posets if LatticePoset(p.completion_by_cuts()).is_distributive() and not p.is_lattice()]