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

def is_sym(f):
	d = f.dict()
	keys = d.keys()
	for k in keys:
		t = type(k)
		kk = t(tuple(reversed(k)),len(k))
		try:
			if d[kk] != d[k]:
				return False
		except KeyError:
			return False
	return True

def jp_to_mp(L):
	w = CoxeterPerm(L.coxeter_transformation())
	jp = L.join_primes()
	mp = L.meet_primes()
	return all([w(m) in jp for m in mp]) and all([w(j) in mp for j in jp])