import copy

def bruhat_decomposition(A):
	B = copy.deepcopy(A)
	B = matrix(QQ, B)
	n = B.ncols()
	U = identity_matrix(QQ, n)
	V = zero_matrix(QQ, n)
	P = []
	for i in range(n):
		for j in range(n):
			if B[n-j-1,i] != 0:
				break
		P.append(n-j-1)
		V[:,n-j-1] = B[:,i]
		for k in range(i+1,n):
			m = B[n-j-1,k]/B[n-j-1,i]
			U[i,k] = m
			for l in range(n-j):
				B[l,k] = B[l,k] - m * B[l,i]
	return Permutation([i+1 for i in P])


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
		D = A.delete_rows(list(range(j+1))).delete_columns(list(range(i+1,n)))
		print('blue weights: ', kernel(D.transpose()).basis()[0])
		#print('red weights: ', kernel(B).basis()[0])
		return True

def coxeter_permutation(A):
	p = []
	n = A.ncols()
	for i in range(n):
		for j in range(n):
			if not_in_span(A,i,n-j-1):
				p.append(n-j)
				break
	return Permutation(p)

def cox_lattice(L):
	return coxeter_permutation(L.lequal_matrix().transpose()).cycle_tuples()
	# w = bruhat_decomposition(L.lequal_matrix().transpose())
	# r = L.rank()
	# for i in L:
	# 	if L.rank(i) + L.rank(w(i)) != r:
	# 		print(i,w(i))
	# 		L.plot()
	# return w.cycle_tuples()

def ccv(P):
	w = bruhat_decomposition(P.lequal_matrix().transpose())
	return all([len(P.lower_covers(w(i))) == len(P.upper_covers(i)) for i in P])

def rank_compl(P):
	w = bruhat_decomposition(P.lequal_matrix().transpose())
	n = P.rank()
	return all(P.rank(w(i))+P.rank(i) == P.rank() for i in P)

def mp_to_jp(L):
	w = bruhat_decomposition(L.lequal_matrix().transpose())
	jp = L.join_primes()
	mp = L.meet_primes()
	return all([w(m) in jp for m in mp])

def tracking_rank(L):
	w = bruhat_decomposition(L.lequal_matrix().transpose())
	return [[L.rank(i) for i in cycle] for cycle in w.cycle_tuples()]


def product(p1,p2):
	L = cartesian_product((p1,p2),order='product')
	d = {i: [j for j in L if p1.covers(i[0],j[0]) and i[1]==j[1] 
	or p2.covers(i[1],j[1]) and i[0]==j[0]] for i in L}
	return Poset(d)

def rank_respecting_linear_extension(P):
    """
    Given a poset or lattice P, return a linear extension
    that respects the rank (i.e., increasing rank order).
    """
    if not P.is_ranked():
        raise ValueError("The poset must be ranked to respect rank.")

    # Group elements by rank
    max_rank = max(P.rank(x) for x in P)
    elements_by_rank = [[] for _ in range(max_rank + 1)]
    
    for x in P:
        r = P.rank(x)
        elements_by_rank[r].append(x)

    # For each rank group, sort topologically within the group
    # and concatenate them in order of increasing rank
    linear_extension = []
    for group in elements_by_rank:
        subposet = P.subposet(group)
        linear_extension.extend(subposet.linear_extension())

    return linear_extension

import random
def random_linear_extension(P):
    H = P.hasse_diagram()
    pi = []
    while H:
        i = random.choice(H.sources())
        pi.append(i)
        H.delete_vertex(i)
    return pi