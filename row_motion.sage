def kappa(L):
	Jirr = L.join_irreducibles()
	Mirr = L.meet_irreducibles()
	k = {j:[] for j in Jirr}
	for j in Jirr:
		jstar = L.lower_covers(j)[0]
		for m in Mirr:
			if L.meet(m,j) == jstar:
				k[j].append(m)
	return k

def kappaInverse(L):
	Mirr = L.meet_irreducibles()
	Jirr = L.join_irreducibles()
	ki = {m:[] for m in Mirr}
	for m in Mirr:
		mstar = L.upper_covers(j)[0]
		for j in Jirr:
			if L.join(j,m) == mstar:
				ki[m].append(j)
	return ki

def rowmotion(L):
	Row = {}
	k = kappa(L)
	for z in L:
		d = L.canonical_joinands(z)
		kd = [k[i] for i in d]
		Row[z] = L.meet(kd)
	return Row

def rowmotionToPerm(L):
	Row = rowmotion(L)
	return [Row[i] for i in sorted(Row.keys())]

# L = posets.TamariLattice(3).relabel().relabel(lambda n: n + 1)
# rowmotion(L)

L=CoxeterGroup(['A',2]).weak_lattice()
lower=dict([(l,Set(L.canonical_joinands(l))) for l in L])
J=L.join_irreducibles()
M=L.meet_irreducibles()
meet_to_join=dict([(m,L.meet([l for l in J if L.le(l,L.upper_covers(m)[0]) and not(L.le(l,m))])) for m in M])
upper=dict([(Set([meet_to_join[i] for i in L.canonical_meetands(l)]),l) for l in L])
def semi_dist_row(l):
   return upper[lower[l]]
from sage.combinat.cyclic_sieving_phenomenon import *
list(map(len,orbit_decomposition(L,semi_dist_row)))