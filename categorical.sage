load('bruhat_decomp.sage')

def reflections(P):
	temp = []
	n = P.cardinality()
	M = P.lequal_matrix()
	B = M + M.transpose()
	for i in range(n):
		c = [0]*(i)+[1]+[0]*(n-1-i)
		c = matrix(c).transpose()
		temp.append(matrix.identity(n) - c * matrix(B[i]))
	return temp