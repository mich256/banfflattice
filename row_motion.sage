def kappa(L):
	Jirr = L.join_irreducibles()
	k = {}
	arblin = L.linear_extension()
	for j in Jirr:
		for z in reversed(arblin):
			if L.meet(z,j) == L.lower_covers(j)[0]:
				k[j] = z
				break
	return k

def kappaInverse(L):
	Mirr = L.meet_irreducibles()
	ki = {}
	arblin = L.linear_extension()
	for m in Mirr:
		for z in arblin:
			if L.join(z,m) == L.upper_covers(j)[0]:
				ki[m] = z
				break
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