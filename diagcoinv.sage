import numpy
import math

n = 6

R = PolynomialRing(QQ, [var('x%d'%i) for i in range(n)] + [var('y%d'%i) for i in range(n)])

def gtau(tau):
	return math.prod([math.prod([var('y%d'%tau(j+1)) for j in range(tau(i))]) for i in tau.descents()])

def witau(tau):
	n = tau.size()
	temp = tau.descents()
	dp = [0] + temp + [n]
	k = len(temp)
	t2 = []
	for m in range(1,k+1):
		t2 += [dp[m]-i + len([j for j in range(dp[m]+1,dp[m+1]+1) if tau(j) < tau(i)]) for i in range(dp[m-1]+1,dp[m]+1)]
	t2 += [n-i for i in range(dp[k]+1,n)]
	return t2

def monobasis(n):
	return sum([math.prod(witau(tau)) for tau in Permutations(n)])
