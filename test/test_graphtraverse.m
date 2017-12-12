G2 = sparse(4,5,1,10,10);
G3 = sparse([1,1,1,2,2,3,6],[2,3,5,4,6,7,6],true,7,7); G3=G3+G3';
DG = sparse([1 2 3 4 5 5 5 6 7 8 8 9], [2 4 1 5 3 6 7 9 8 1 10 2], true, 10, 10);

[order,p,c] = graphtraverse(G2,[3],'Method','DFS');
	disp(isequaln(order,[3]))
	disp(isequaln(p,    [NaN   NaN     0   NaN   NaN   NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [3]))

[order,p,c] = graphtraverse(G2,[3],'Method','BFS');
	disp(isequaln(order,[3]))
	disp(isequaln(p,    [NaN   NaN     0   NaN   NaN   NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [3]))

[order,p,c] = graphtraverse(G2,[4],'Method','DFS');
	disp(isequaln(order,[4     5    ]))
	disp(isequaln(p,    [NaN   NaN   NaN   0     4     NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [5     4    ]))

[order,p,c] = graphtraverse(G2,[4],'Method','BFS');
	disp(isequaln(order,[4     5    ]))
	disp(isequaln(p,    [NaN   NaN   NaN   0     4     NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [4     5    ]))

disp('#DFS')

[order,p,c] = graphtraverse(DG,[4],'Method','DFS','Depth',2);
	disp(isequaln(order,[4     5     3     6     7]))
	disp(isequaln(p,    [NaN   NaN   5     0     4     5     5     NaN   NaN  NaN]))
	disp(isequaln(c,    [3     6     7     5     4]))

[order,p,c] = graphtraverse(DG,[4],'Method','DFS','Depth',3);
	disp(isequaln(order,[4     5     3     1     6     9     7     8 ]))
	disp(isequaln(p,    [3     NaN   5     0     4     5     5     7     6  NaN]))
	disp(isequaln(c,    [1     3     9     6     8     7     5     4]))

[order,p,c] = graphtraverse(DG,[4],'Method','DFS');
	disp(isequaln(order,[4     5     3     1     2     6     9     7     8    10]))
	disp(isequaln(p,    [3     1     5     0     4     5     5     7     6     8]))
	disp(isequaln(c,    [2     1     3     9     6    10     8     7     5     4]))

disp('#BFS')

[order,p,c] = graphtraverse(DG,[4],'Method','BFS');
	disp(isequaln(order,[4     5     3     6     7     1     9     8     2    10]))
	disp(isequaln(p,    [3     1     5     0     4     5     5     7     6     8]))
	disp(isequaln(c,    [4     5     3     6     7     1     9     8     2    10]))

[order,p,c] = graphtraverse(DG,[4],'Method','BFS','Depth',1);
	disp(isequaln(order,[4     5    ]))
	disp(isequaln(p,    [NaN   NaN   NaN   0     4     NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [4     5    ]))

[order,p,c] = graphtraverse(DG,[4],'Method','BFS','Depth',2);
	disp(isequaln(order,[4     5     3     6     7]))
	disp(isequaln(p,    [NaN   NaN   5     0     4     5     5     NaN   NaN  NaN]))
	disp(isequaln(c,    [4     5     3     6     7]))

[order,p,c] = graphtraverse(DG,[4],'Method','BFS','Depth',3);
	disp(isequaln(order,[4     5     3     6     7     1     9     8]))
	disp(isequaln(p,    [3     NaN   5     0     4     5     5     7     6     NaN]))
	disp(isequaln(c,    [4     5     3     6     7     1     9     8]))

disp('# Directed=0')

[order,p,c] = graphtraverse(DG,[4],'Method','DFS', 'Directed', 0);
	disp(isequaln(order,[4]))
	disp(isequaln(p,    [NaN   NaN   NaN     0   NaN   NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [4]))

[order,p,c] = graphtraverse(DG,[4],'Method','BFS', 'Directed', 0);
	disp(isequaln(order,[4]))
	disp(isequaln(p,    [NaN   NaN   NaN     0   NaN   NaN   NaN   NaN   NaN  NaN]))
	disp(isequaln(c,    [4]))

[order,p,c] = graphtraverse(DG',[4],'Method','BFS', 'Directed', 0);
	disp(isequaln(order,[4     2     5     1     6     7     9     8     10]))
	disp(isequaln(p,    [2     4   NaN     0     4     5     5     7     6     8]))
	disp(isequaln(c,    [4     2     5     1     6     7     9     8     10]))

[order,p,c] = graphtraverse(DG',[4],'Method','DFS', 'Directed', 0);
	disp(isequaln(order,[4     2     1     5     6     9     7     8     10 ]))
	disp(isequaln(p,    [2     4   NaN     0     4     5     5     7     6     8]))
	disp(isequaln(c,    [1     2     9     6    10     8     7     5     4 ]))


