def bruhat_decomposition(A):
	n = A.ncols()
	I = matrix.identity(QQ, n)
	U = I
	B = A
	V = Matrix(QQ, n, n, 0)
	pi = Matrix(ZZ, n, n, 0)
	for i in range(n):
		j = max([k for k in range(n) if B[k, i] != 0])
		pi[j, i] = 1
		for t in range(n):
			V[t, j] = B[t, i]
		for k in range(i+1, n):
			m = B[j, k]/B[j, i]
			U[i, k] = m
			for l in range(j-1):
				B[l, k] = B[l, k] - m* B[l, i]
			B[j, k] = 0
	return V, pi, U

def bigrassmannian(n,a,b,c):
	if a > b or b > c or a >c:
		raise ValueError
	return Permutation([1..a]+[(b+1)..c]+[(a+1)..b]+[(c+1)..n])

def layered(n, J):
	i = min(J)
	r = [1..i-1]
	while i < n:
		if i in J:
			k = 1
			while i+k in J:
				k += 1
			r += list(reversed([i..(i+k)]))
			i += k+1
		else:
			k = 1
			while i+k not in J:
				k += 1
			r += [i..(i+k-1)]
	if n-1 not in J:
		r.append(n)
	return Permutation(r)

def not_in_span(A,i,j):
	n = A.ncols()
	if j == 0:
		return True
	c = A.column(i)[j:]
	if i == 0:
		if c == 0:
			return False
		return True
	B = A.delete_rows(list(range(j))).delete_columns(list(range(i,n)))
	try:
		B.solve_right(c)
		return False
	except ValueError:
		return True

def coxeter_permutation(A):
	p = []
	n = A.ncols()
	for i in range(n):
		for j in range(n):
			if not_in_span(A,i,n-j-1):
				p.append(n-j)
				break
	return Permutation(p).inverse()

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

def is_indecomposable(L):
	if len(L.subdirect_decomposition()) == 1:
		return True
	return False

import random
def random_linear_extension(P):
    H = P.hasse_diagram()
    pi = []
    while H:
        i = random.choice(H.sources())
        pi.append(i)
        H.delete_vertex(i)
    return pi