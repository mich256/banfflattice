def subspace_lattice(d,p):
    VS = VectorSpace(FiniteField(p),d)
    SS = {}
    SS[0] = set([VS.subspace([])])
    for dim in range(1,d+1):
        new_subspaces = set()
        for v in VS:
            for ss in SS[dim-1]:
                new_ss = ss + VS.subspace([v])
                if new_ss.dimension() == dim:
                    new_subspaces.add(new_ss)
        SS[dim] = new_subspaces
    ground_set = reduce(lambda x,y:x.union(y),SS.values())
    L = LatticePoset((ground_set,lambda x,y: x.is_subspace(y))).relabel()
    return L.relabel().relabel(lambda n: n + 1)

# dim = 3
# FF = FiniteField(2)
# VS = VectorSpace(FF,dim)
# SS = {}
# SS[0] = set([VS.subspace([])])
# for dim in range(1,dim+1):
#     new_subspaces = set()
#     for v in VS:
#         for ss in SS[dim-1]:
#             new_ss = ss + VS.subspace([v])
#             if new_ss.dimension() == dim:
#                 new_subspaces.add(new_ss)
#     SS[dim] = new_subspaces
# ground_set = reduce(lambda x,y:x.union(y),SS.values())
# L = LatticePoset((ground_set,lambda x,y: x.is_subspace(y))).relabel()
# L=L.relabel().relabel(lambda n: n + 1)
# O=L.linear_extensions()
# L.show()
# x=Permutation([i for i in L.linear_extension()]).to_matrix()#make sure your poset vertices [1..n]; RandomLattice does 0..(n-1), RandomPoset does 1..n
# y=x*L.lequal_matrix()*x.inverse()
