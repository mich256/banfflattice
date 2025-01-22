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

def ccv(P):
	R.<q,t> = QQ[]
	return sum([q^(len(P.lower_covers(i)))*t^(len(P.upper_covers(i))) for i in P])

def ccv_coxeter(P):
	w = CoxeterPerm(P.lequal_matrix().transpose())
	return all([len(P.lower_covers(w(i))) == len(P.upper_covers(i)) for i in P])

def mp_to_jp(L):
	w = CoxeterPerm(L.lequal_matrix().transpose())
	jp = L.join_primes()
	mp = L.meet_primes()
	return all([w(m) in jp for m in mp])