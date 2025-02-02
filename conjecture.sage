def kappa(L):
	atoms = L.upper_covers(L.bottom())
	coatoms = L.lower_covers(L.top())
	return {j:m for j in atoms for m in coatoms if not L.is_lequal(j,m)}

def conj_Colin(L):
	ka = kappa(L)
	coatoms = L.lower_covers(L.top())
	for j,m in ka.items():
		for y in L.open_interval(j, L.top()):
			temp = L.meet(m, y)
			if all([L.is_lequal(temp, em) for em in coatoms]):
				for x in coatoms:
					if x != m and not L.is_lequal(y, x):
						print(j,m,y,x)
						return False
	return True