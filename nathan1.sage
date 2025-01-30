for _ in range(100):
    G=random_acyclic(6,.4)
    P=make_flip_poset(G)
    try:
        L=LatticePoset(P)
        #L.show()
        if L.is_semidistributive():
            continue
        else:
            break
    except:
        continue
print(L.is_trim(),L.is_semidistributive())
L.show(figsize=10)

for _ in range(10):
    G=random_acyclic(9,.5)
    P=make_flip_poset(G)
    try:
        L=LatticePoset(P)
        L.show()
        break
    except:
        continue
print(L.is_trim())

def random_acyclic(n, p):
    g = graphs.RandomGNP(n, p)
    h = DiGraph()
    h.add_edges(((u, v) if u < v else (v, u)) for u, v in g.edge_iterator(labels=False))
    return h

def make_flip_poset(G):
#given a directed graph G, return the corresponding independence poset
    edges=[]
    els=Set([])
    last=[]
    new=[minimal_trip(G)]
    while new!=[]:
        last=new
        els=els.union(Set(last))
        new=[]
        for a in last:
            for i in a[1]:
                b=flip(G,a,i)
                edges.append([a,b])
                if b not in new:
                    new=new+[b]
    return Poset((list(els),edges))
def make_flip_tree(G):
#given a directed graph G, return the corresponding flip tree
    edges=[]
    els=Set([])
    last=[]
    new=[(min_ind(),-1)]
    while new!=[]:
        last=new
        els=els.union(Set(last))
        new=[]
        for a in last:
            for i in a[0][1]:
                j=Q.linear_extension().index(i)
                if a[1]==-1 or j>a[1]:
                    b=tog(a[0],i)
                    edges.append([a,(b,j)])
                    if b not in new:
                        new=new+[(b,j)]
    return Poset((list(els),edges))
def rowmotion(L,x):
#compute rowmotion on the trip x
    lower=dict([(l,l[0]) for l in L])
    upper=dict([(l[1],l) for l in L])
    return upper[lower[x]]

def flip_up(G,du,j):
#given a directed graph G, a trip (D,U) and an element j in u, return flip_j(D,U)
    a=du[0]
    b=du[1]
    if j not in b:
        return du
    elif j in b:
        return flip(G,du,j)
def flip_down(G,du,j):
#given a directed graph G, a trip (D,U) and an element j in d, return flip_j(D,U)
    a=du[0]
    b=du[1]
    if j not in a:
        return du
    elif j in a:
        return flip(G,du,j)
def flip(G,du,j):
#given a directed graph G, a trip (D,U) and an element j of G, return flip_j(D,U)
    H=DiGraph(G)
    H.reverse_edges([i[:-1] for i in H.edges()])
    P=Poset(G)
    Q=Poset(H)
    a=du[0]
    b=du[1]
    if j not in b and j not in a:
        return du
    elif j in b:
        a2=Set([k for k in a if not(Q.le(k,j))]+[j])
        b2=Set([k for k in b if not(Q.ge(k,j))])
    elif j in a:
        a2=Set([k for k in a if not(Q.le(k,j))])
        b2=Set([k for k in b if not(Q.ge(k,j))]+[j])
    #print "first step: ",(a2,b2)
    for k in P.linear_extension():
        if not(Q.ge(k,j)) and Set([i[1] for i in G.edges_incident(k)]).intersection(b)==Set([]) and Set([i[1] for i in H.edges_incident(k)]).intersection(a2)==Set([]) and (k not in b2):
            a2=a2.union(Set([k]))
    for k in Q.linear_extension():
        if not(Q.le(k,j)) and Set([i[1] for i in H.edges_incident(k)]).intersection(a)==Set([]) and Set([i[1] for i in G.edges_incident(k)]).intersection(b2)==Set([]) and (k not in a2):
            b2=b2.union(Set([k]))
    return (a2,b2)
def flips(G,du,s):
#given a directed graph G, a trip (D,U) and a sequence s of elements j of G, return (\prod_{j \in s} flip_j)(D,U)
    dv=tuple(du)
    for i in s:
        dv=flip(G,dv,i)
    return dv

def complete_trip(G,u):
#given an independent set u in the digraph G, return the trip of the form (J,u)
    m=Set([])
    H=DiGraph(G)
    H.reverse_edges(H.edges())
    P=Poset(G)
    Q=Poset(H)
    m=Set([])
    for k in P.linear_extension():
        if Set([i[1] for i in H.edges_incident(k)]).intersection(m)==Set([]) and Set([i[1] for i in G.edges_incident(k)]).intersection(u)==Set([]) and k not in u:
            m=m.union(Set([k]))
    return (m,u)
def maximal_trip(G):
#given a directed graph G, return the maximal trip of the form (J,[])
    return complete_trip(G,Set([]))
def minimal_trip(G):
#given a directed graph G, return the minimal trip of the form ([],M)
    H=DiGraph(G)
    H.reverse_edges([i[:-1] for i in H.edges()])
    P=Poset(G)
    Q=Poset(H)
    m=Set([])
    for k in Q.linear_extension():
        if Set([i[1] for i in G.edges_incident(k)]).intersection(m)==Set([]):
            m=m.union(Set([k]))
    return (Set([]),m)

def inc1(a,b):
    if a[0].issubset(b[0]):
        return True
    else:
        return False
def mops(g):
    sets=[]
    edges=[(i[0],i[1]) for i in g.edges()]
    for s in Subsets(g):
        for t in Subsets(Set(g).difference(s)):
            no=False
            for i in s:
                for j in t:
                    if (i,j) in edges:
                        no=True
                        break
                if no==True:
                    break
            if no==False:
                sets.append((s,t))
    P=Poset([sets,inc])
    Pmax=P.maximal_elements()
    return Pmax
def poset_of_mops(g):
#naively, and slowly, computes the poset of maximal orthogonal pairs from the directed graph g
    return Poset([mops(g),inc1])