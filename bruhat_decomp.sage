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