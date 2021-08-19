function [R] = getpdb(PDBid, varargin)
% GETPDB retrieves protein structure from the protein data base PDB
%
% PDBStruct = getpdb(PDBid)
% PDBStruct = getpdb(PDBid, ...'ToFile', ToFileValue, ...)
% PDBStruct = getpdb(PDBid, ...'SequenceOnly', SequenceOnlyValue, ...)
% 
% https://files.rcsb.org/download/6EUV.pdb.gz
%
%  R=getpdb('6EUV');
%
% Reference(s):
%  [1] http://www.wwpdb.org/documentation/file-format

% Copyright (C) 2017 Alois Schloegl
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


ToFileValue=[];
SequenceOnlyValue=false;

k = 1; 
while (k <= length(varargin))
	if ischar(varargin{k})
		switch (varargin{k})
		case 'ToFile'
			ToFileValue=varargin{k+1};
			k=k+2;
		case 'SequenceOnly'
			SequenceOnlyValue=varargin{k+1};
			k=k+2;
		otherwise
			fprintf(2,'unknown argument <%s>\n',varargin{k});
			k=k+1;
		end
	else
		k=k+1;
	end
end

if isempty(ToFileValue)
if exist('OCTAVE_VERSION','builtin')
	ToFileValue=[PDBid,'.pdb.gz'];
else
	ToFileValue=[PDBid,'.pdb'];
end
end

%%% Download file 
url=sprintf('https://files.rcsb.org/download/%s.pdb.gz',PDBid);	
if ~exist(ToFileValue,'file')
if exist('OCTAVE_VERSION','builtin')
	urlwrite(url,ToFileValue);
else
	gunzip(url);
end
end

R = pdbread(ToFileValue);
R.SearchURL = url;

