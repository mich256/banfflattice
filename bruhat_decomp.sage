def NiSpan(A,i,j):
	n = A.ncols()
	if j == 0:
		return True
	c = A.column(i)[j:]
	if i == 0:
		if c == 0:
			return False
		return True
	B = A.delete_rows([0..(j-1)]).delete_columns([i..(n-1)])
	try:
		B.solve_right(c)
		return False
	except ValueError:
		return True

def bruhatDecomp(A):
	p = []
	n = A.ncols()
	for i in range(n):
		for j in range(n):
			if NiSpan(A,i,n-j-1):
				p.append(n-j)
				break
	return p

def CoxeterPerm(A):
	return Permutation(bruhatDecomp(A)).inverse()


# L=posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)
# W=L.lequal_matrix().transpose()
# P=CoxeterPerm(W)
# display(P)
# plot(L)

# Here how to get all Coxeter permutations of all linear extensions of a given poset:
# L= posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)                                                                                                                                                       L= posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)
# O=L.linear_extensions()
# OO=[L.linear_extension(x).to_poset() for x in O]
# OO2=[CoxeterPerm(x.lequal_matrix().transpose()) for x in OO]
# display(OO2)
# plot(L)