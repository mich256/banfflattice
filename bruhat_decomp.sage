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

def product(p1,p2):
	L = cartesian_product((p1,p2),order='product')
	d = {i: [j for j in L if p1.covers(i[0],j[0]) and i[1]==j[1] 
	or p2.covers(i[1],j[1]) and i[0]==j[0]] for i in L}
	return Poset(d)

import random
def random_linear_extension(P):
    H = P.hasse_diagram()
    pi = []
    while H:
        i = random.choice(H.sources())
        pi.append(i)
        H.delete_vertex(i)
    return pi