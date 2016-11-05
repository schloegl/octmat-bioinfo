function [H,S,Q] = fastqread(filename,varargin)
% FASTQREAD reads fastq data 
%  
% Usage: 
%	FASTQDATA = fastqread(filename)
%	... = fastqread(..., 'TrimHeaders', TrimHeadersValue, ...)
%	... = fastqread(..., 'HeaderOnly', HeaderOnlyValue, ...)
%	... = fastqread(..., 'Blockread', BlockreadValue, ...)
%	[headers, seqs, quality] = fastqread(...)
%  
%    TrimHeadersValue: default 0 (false), if it is non-zero, 
%	header strings are truncated at 1st white space character (<tab> or <space>)
%    HeaderOnly: default 0 (false), 
%       if it is non-zero, seqs and quality are not reported
%    BlockreadValue: default [], reads all blocks
%       in case of a scalar N, only N-th block is returned
%       in case of [N1,N2], all blocks from N1:N2 are returned. 
%       N2 can be infinite, than all blocks from N1 to the end are read

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

% Copyright (C) 2016 Alois Schloegl

H={};
if (nargout>1)
	S={};
	Q={};
end

flag.TrimHeaders=0;
flag.HeaderOnly=0;
flag.Blockread=[];
for k=1:2:length(varargin)
	flag.(varargin{k})=varargin{k+1};
end;
if numel(flag.Blockread)==1
	flag.Blockread=flag.Blockread([1,1]);
end;


STATE=1;
LINENO=0;
BLKNO=0;

fid=fopen(filename,'r');
while (~feof(fid))
	STATE
	LINE = strtrim(fgetl(fid))
	LINENO=LINENO+1;

	if isempty(LINE) continue; end;
	
	switch (STATE)
	case {1}
		h=[];
		s=[];
		q=[];
		if (LINE(1)=='@')
			h=LINE(2:end);
			if (flag.TrimHeaders)
				ix=find(isspace(LINE),1);
				if ~isempty(ix)
					h=h(1:ix-1)
				end;
			end;
			STATE=2;
		else
			msg = sprintf('error in line %i of file %s',LINENO,filename);
			error(msg);
		end;
	case {2}
	 	s=LINE;
	 	STATE=3;
	case {3}
		if (LINE(1)=='+')
			STATE=4;
		else
			msg = sprintf('error in line %i of file %s',LINENO,filename);
			error(msg);
		end;
	case {4}
	 	q=LINE;
	 	BLKNO=BLKNO+1;
		STATE=1;
		h
		if ( isempty(flag.Blockread) ||
		     ( (flag.Blockread(1)<=BLKNO) && (BLKNO<=flag.Blockread(2)) ) )  
		 	if (flag.HeaderOnly)
				H{end+1}=h;
			elseif (nargout>1)
				H{end+1}=h;
				S{end+1}=s;
				Q{end+1}=q;
			else
				x.Header=h;	
				x.Sequence=s;	
				x.Quality=q;	
				H{end+1}=x;
			end;			
		end;
	end		
end; 
fclose(fid);



