def NiSpan(A,i,j):
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
	return Permutation(bruhatDecomp(A)).inverse().to_cycles()

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

import random
def random_linear_extension(P):
    H = P.hasse_diagram()
    pi = []
    while H:
        i = random.choice(H.sources())
        pi.append(i)
        H.delete_vertex(i)
    return pi

# L=posets.SymmetricGroupBruhatOrderPoset(5) 
# L=L.relabel()

# x=Permutation([i+1 for i in L.linear_extension()]).to_matrix()
# #print(x)
# y=x*L.lequal_matrix()*x.inverse()
# #print(x*y*x.inverse(),"\n\n")
# rowmotions=[]
# for _ in range(100):
#     o=random_linear_extension(L)
#     #display(o.plot())
#     q=Permutation([i+1 for i in o])
#     qm=q.to_matrix()
#     #print(q.to_matrix())
#     #print((qm.inverse()*y*qm).transpose())
#     p=CoxeterPerm((qm.inverse()*y.transpose()*qm))
#     pp=q.inverse()*p.inverse()*q
#     #print(o,pp,pp.cycle_tuples(),len(pp))
#     if pp not in rowmotions:
#         print(pp.cycle_tuples())
#         rowmotions+=[pp]