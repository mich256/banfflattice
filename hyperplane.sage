def subset_to_vector(n,s):
	return [1 if (i+1) in s else 0 for i in range(n)]

def hyper(n,k):
	S = Subsets(list(range(1,n+1)),k)
	x = ['x_%d'%i for i in range(1,n+1)]
	H = HyperplaneArrangements(QQ, tuple(x))
	c = binomial(k,2)
	return H([[tuple(subset_to_vector(n,s)), c] for s in S])