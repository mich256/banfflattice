import numpy
import math

#R = PolynomialRing(QQ, [var('x%d'%i) for i in range(n)] + [var('y%d'%i) for i in range(n)])

def schedule(w):
	n = w.size()
	r = w.runs()
	v = w.inverse()
	r.append([0])
	s = [0]*n
	for j in range(len(r)-1):
		for i in r[j]:
			s[v(i)-1] = len([k for k in r[j] if k > i]) + len([k for k in r[j+1] if k < i])
	return s

def monobasis(n):
	return sum([math.prod(schedule(w)) for w in Permutations(n)])