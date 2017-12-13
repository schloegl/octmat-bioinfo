function [disc, pred, closed] = graphtraverse(G, S, varargin)
% GRAPHTRAVERSE traverses a graph by following adjacent nodes
%   by implementing the ideas according to the methods as described
%   in [1-3].
%
% Usage:
%	[disc, pred, closed] = graphtraverse(G, S)
%	[...] = graphtraverse(..., 'Depth', DepthValue, ...)
%	[...] = graphtraverse(..., 'Directed', DirectedValue, ...)
%	[...] = graphtraverse(..., 'Method', MethodValue, ...)
%
% Input:
%	G	NxN sparse matrix, edges are indicated by non-zero entries
%	S	starting node number
%       MethodValue:
%		'DFS' Depth-first-search (default) 
%               'BFS' Breadth-first-search
%	DepthValue:	depth of search, (default is Inf)	
%	DirectedValue:
%		True: (default) G is a directed graph
%		False: G undirected graph, (upper triangle is ignored) 
%
% Output:
%	disc 	vector containing node indices in the order of their discovery
%	pred	predecessor node indices
%       closed	vector of node indices in closing order
%   NOTE: For the DFS method, the result of "closed"
%        can differ from the Matlab version - most likely because
%        a non-recursive algorithm is used [1].
%
% References:
% [1] https://en.wikipedia.org/wiki/Depth-first_search
% [2] https://en.wikipedia.org/wiki/Breadth-first_search
% [3] https://en.wikipedia.org/wiki/Tree_traversal

% Copyright (C) 2017 Alois Schloegl, IST Austria
%
% This software is free software; you can redistribute it and/or modify it
% under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 3 of the License, or (at
% your option) any later version.
%
% This software is distributed in the hope that it will be useful, but
% WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
% General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this software; see the file COPYING.  If not, see
% <http://www.gnu.org/licenses/>.


DepthValue=inf;
DirectedValue=true;
Method='DFS';

k = 1; 
while (k <= length(varargin))
	if ischar(varargin{k})
		switch (varargin{k})
		case 'Method'
			Method=varargin{k+1};
			k=k+2;
		case 'Depth'
			DepthValue=varargin{k+1};
			k=k+2;
		case 'Directed'
			DirectedValue=varargin{k+1};
			k=k+2;
		otherwise
			fprintf(2,'unknown argument <%s>\n',varargin{k});
			k=k+1;
		end
	else
		k=k+1;
	end
end

if ~DirectedValue
	G=tril(G);	
end

if ~issparse(G) 
	error('G is not sparse')
end

if strcmp(Method,'BFS')
	disc    = S;
	closed  = S;
	pred    = repmat(NaN,1,max(size(G)));
	pred(S) = 0;

	P = 0;
	D = DepthValue;
	while ~isempty(S)
		% get element from fifo queue
		s = S(end); S(end) = [];
		p = P(end); P(end) = [];
		d = D(end); D(end) = [];
		if (d>0)
			if ~DirectedValue,
				x = find(G(:,s)' | G(s,:));
			else
				x = find(G(s,:));
			end
			for k = x,
				if isnan(pred(k))
					disc    = [disc, k];
					closed  = [closed,k];
					pred(k) = s;

					% push element into queue
					S  = [k,   S];
					D  = [d-1, D];
					P  = [s,   P];
				end
			end	
		end
	end
	return

elseif strcmp(Method,'DFS')
	disc   = [];
	closed = [];
	pred   = repmat(NaN,1,max(size(G)));
	
	P = 0;
	D = DepthValue;
	while ~isempty(S)
		% pop from stack 
		s = S(end); S(end) = [];
		p = P(end); P(end) = [];
		d = D(end); D(end) = [];

		if isnan(pred(s)) && (d>=0) 
			pred(s) = p;
			disc    = [disc,s];
			closed  = [s,closed];

			if ~DirectedValue
				x = find(G(:,s)' | G(s,:));
			else
				x = find(G(s,:));
			end
			% push to stack	
			S = [S, x(end:-1:1)];
			D = [D, repmat(d-1, 1, length(x))];
			P = [P, repmat(s,   1, length(x))];
		end
	end
	if nargout>2,
		warning('The third output argument uses a different order than Matlab')
	end; 
	return

else
	error('Method not supported')	
end

%dgMat = sparse(relMatrix); % sparse matrix representing the directed graph
%[visitOrder, predVec, ~] = graphtraverse(dgMat,IdxA,'method','bfs');


%! DG = sparse([1 2 3 4 5 5 5 6 7 8 8 9],[2 4 1 5 3 6 7 9 8 1 10 2],true,10,10)
%! 
%! [order,p,c] = graphtraverse(DG,[4],'method','DFS') 
%    order =[ 4     5     3     1     2     6     9     7     8    10]
%
%! [order,p,c] = graphtraverse(DG,[4],'method','BFS') 
%    order =[ 4     5     3     6     7     1     9     8     2    10]
%!
%!

