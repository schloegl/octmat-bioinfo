function [H,S] = fastaread(filename,varargin)
% FASTAREAD reads fasta data
%
% Usage:
%	FASTADATA = fastaread(filename)
%	... = fastaread(..., 'TrimHeaders', TrimHeadersValue, ...)
%	... = fastaread(..., 'IgnoreGaps', IgnoreGapsValue, ...)
%	... = fastaread(..., 'Blockread', BlockreadValue, ...)
%	[headers, seqs] = fastaread(...)
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
end

flag.IgnoreGaps=0;
flag.TrimHeaders=0;
flag.Blockread=[];
for k=1:2:length(varargin)
	flag.(varargin{k})=varargin{k+1};
end;
if numel(flag.Blockread)==1
	flag.Blockread=flag.Blockread([1,1]);
end;


STATE =1;
LINENO=0;
BLKNO =0;
h=[];s='';

fid=fopen(filename,'r');

while (1)
	LINE  = strtrim(fgetl(fid));
	LINENO= LINENO+1;

	if (isempty(LINE) || feof(fid) || (STATE==3) || (LINE(1)=='>') || ((STATE==1) && (LINE(1)==';')) )
		STATE=1;
		if ~isempty(s) && ~isempty(h)
		 	BLKNO = BLKNO+1;
		 	if (flag.IgnoreGaps)
		 		s(s=='.' | s=='-')=[];
		 	end;
			if ( isempty(flag.Blockread) ||
			     ( (flag.Blockread(1)<=BLKNO) && (BLKNO<=flag.Blockread(2)) ) )
			 	if (nargout>1)
					H{end+1}=h;
					S{end+1}=s;
				else
					x.Header=h;
					x.Sequence=s;
					H{end+1}=x;
				end;
			end
		end;
		h=[];s='';
	end

	if feof(fid)
		break;
	elseif isempty(LINE)
		continue;
	elseif ((STATE==2) && (LINE(1)==';'))
		continue;
	elseif ( (LINE(1)=='>') ||
	     ((STATE==1) && (LINE(1)==';')) )
		h = LINE(2:end);
		s = '';
		if (flag.TrimHeaders)
			ix = find(isspace(LINE),1);
			if ~isempty(ix)
				h = h(1:ix-1);
			end;
		end;
		STATE=2;
		continue

	elseif (STATE==2) && any(upper(LINE(1))=='ABCDEFGHIJKLMNOPQRSTUVWYZX*-')
	 	ix = find(LINE=='*');
	 	if ~isempty(ix)
	 		LINE=LINE(1:ix-1);
	 		STATE=3;
	 	end
	 	s=[s,upper(LINE)];
	else
		msg = sprintf('error in line %i of file %s',LINENO,filename);
		error(msg);
	end;
end;
fclose(fid);



