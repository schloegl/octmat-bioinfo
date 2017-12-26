function [R] = pdbread(ToFileValue, varargin)
% PDBREAD retrieves protein structure from the protein data base PDB
%
% PDBStruct = pdbread(file)
% PDBStruct = pdbread(file, 'ModelNum', ModelNumValue)
%
%  R=pdbread('6euv.pdb.gz');
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


ModelNumValue=0;	% all models

k = 1; 
while (k <= length(varargin))
	if ischar(varargin{k})
		switch (varargin{k})
		case 'ModelNum'
			fprintf(2,'WARNING: argument <%s> not supported yet\n',varargin{k});
			ModelNumValue=varargin{k+1};
			k=k+2;
		otherwise
			fprintf(2,'unknown argument <%s>\n',varargin{k});
			k=k+1;
		end
	else
		k=k+1;
	end
end

fid = fopen(ToFileValue,'rz');

R.Title          = char([]);
R.Authors        = char([]);
R.Compound       = char([]);
R.ExperimentData = char([]);
R.Keywords       = char([]);
R.Source         = char([]);
R.RevisionDate   = {};
R.Sequence       = {};
R.DBReferences   = {};
R.HeterogenName(1).ChemName = char([]);
R.Model.Atom          = {};
R.Model.HeterogenAtom = {};
R.Model.Terminal      = {};
ModelSerialNo         = 1;	% default, if no "^MODEL " line
NumModelAtom          = 1;
NumModelHeterogenAtom = 1;
NumModelTerminal      = 1;

lastfield = '';
value     = '';
stopflag  = 0;
while ~feof(fid)
	line  = fgetl(fid);
	field = line(1:6);
	switch (field)
	% one time, one line
	case 'CRYST1'
		if isfield(R,'Cryst1') error('multiple HEADER found'); end 
		R.Cryst1.a      = str2double(line(7:15));
		R.Cryst1.b      = str2double(line(16:24));
		R.Cryst1.c      = str2double(line(25:33));
		R.Cryst1.alpha  = str2double(line(34:40));
		R.Cryst1.beta   = str2double(line(41:47));
		R.Cryst1.gamma  = str2double(line(48:54));
		R.Cryst1.sGroup = line(56:66);
		R.Cryst1.z      = str2double(line(67:70));

	case 'END   '
		%fprintf(1,'%s>\t%s\n',field,tok)
		
	case 'HEADER'
		if isfield(R,'Header') error('multiple HEADER found'); end 
		R.Header.classification = strtrim(line(11:50));
		R.Header.depDate        = line(51:59);
		R.Header.idCode         = line(63:66);
		
	case 'NUMMDL'
		if isfield(R,'modelNumber') error('multiple HEADER found'); end 
		R.modelNumber = str2double(line(11:14));

	case 'MASTER'
		if isfield(R,'Master') error('multiple Master found'); end 
		R.Master.numREMARK = str2double(line(11:15));
		R.Master.numHET    = str2double(line(21:25));
		R.Master.numHelix  = str2double(line(26:30));
		R.Master.numSheet  = str2double(line(31:35));
		R.Master.numTurn   = str2double(line(36:40));
		R.Master.numSite   = str2double(line(41:45));
		R.Master.numXform  = str2double(line(46:50));
		R.Master.numCoord  = str2double(line(51:55));
		R.Master.numTer    = str2double(line(56:60));
		R.Master.numConect = str2double(line(61:65));
		R.Master.numSeq    = str2double(line(66:70));

	case 'ORIGX1 '
		k=field(6)-'0';
		R.OriginX(k).On1 = str2double(line(11:20));
		R.OriginX(k).On2 = str2double(line(21:30));
		R.OriginX(k).On3 = str2double(line(31:40));
		R.OriginX(k).Tn  = str2double(line(46:55));

	case 'ORIGX2 '
		k=field(6)-'0';
		R.OriginX(k).On1 = str2double(line(11:20));
		R.OriginX(k).On2 = str2double(line(21:30));
		R.OriginX(k).On3 = str2double(line(31:40));
		R.OriginX(k).Tn  = str2double(line(46:55));

	case 'ORIGX3 '
		k=field(6)-'0';
		R.OriginX(k).On1 = str2double(line(11:20));
		R.OriginX(k).On2 = str2double(line(21:30));
		R.OriginX(k).On3 = str2double(line(31:40));
		R.OriginX(k).Tn  = str2double(line(46:55));

	case 'SCALE1'
		k=field(6)-'0';
		R.Scale(k).Sn1 = str2double(line(11:20));
		R.Scale(k).Sn2 = str2double(line(21:30));
		R.Scale(k).Sn3 = str2double(line(31:40));
		R.Scale(k).Un  = str2double(line(46:55));

	case 'SCALE2'
		k=field(6)-'0';
		R.Scale(k).Sn1 = str2double(line(11:20));
		R.Scale(k).Sn2 = str2double(line(21:30));
		R.Scale(k).Sn3 = str2double(line(31:40));
		R.Scale(k).Un  = str2double(line(46:55));

	case 'SCALE3'
		k=field(6)-'0';
		R.Scale(k).Sn1 = str2double(line(11:20));
		R.Scale(k).Sn2 = str2double(line(21:30));
		R.Scale(k).Sn3 = str2double(line(31:40));
		R.Scale(k).Un  = str2double(line(46:55));

	% one time, multiple lines
	case 'AUTHOR'
		R.Authors  = [R.Authors; line(11:80)];
	case 'CAVEAT'
		% TODO
		R.CAVEAT = [R.CAVEAT; line(11:80)];
	case 'COMPND'	
		R.Compound = [R.Compound; line(11:80)];
	case 'EXPDTA'	
		R.ExperimentData = [R.ExperimentData; line(11:80)];
	case 'MDLTYP'
		R.Compound = [R.Compound; line(11:80)];
	case 'KEYWDS'	
		R.Keywords = [R.Keywords; line(11:80)];
	case 'OBSLTE'
		% TODO
		R.OBSLTE = [R.OBSLTE; line(11:80)];
	case 'SOURCE'	
		R.Source = [R.Source; line(11:80)];
	case 'SPLIT '
		% TODO
		R.SPLIT = [R.SPLIT; line(11:80)];
	case 'SPRSDE'
		% TODO
		R.SPRSDE = [R.SPRSDE; line(11:80)];
	case 'TITLE '
		R.Title = [R.Title;line(11:80)];
	
	% multiple times, one line
	case 'ANISOU'	

	case 'ATOM  '
		Atom.AtomSerNo  = str2double(line(7:11));
		Atom.AtomName   = strtrim(line(13:16));
		Atom.altLoc     = strtrim(line(17));
		Atom.resName    = line(18:20);
		Atom.chainID    = line(22);
		Atom.resSeq     = str2double(line(23:26));
		Atom.iCode      = strtrim(line(27));
		Atom.X          = str2double(line(31:38));
		Atom.Y          = str2double(line(39:46));
		Atom.Z          = str2double(line(47:54));
		Atom.occupancy  = str2double(line(55:60));
		Atom.tempFactor = str2double(line(61:66));
		Atom.segID      = '    ';
		Atom.element    = strtrim(line(77:78));
		Atom.charge     = line(79:80);
		Atom.AtomNameStruct.chemSymbol = strtrim(line(13:14));
		Atom.AtomNameStruct.remoteInd  = line(15);
		Atom.AtomNameStruct.branch     = strtrim(line(16));
 		R.Model(ModelSerialNo).Atom(end+1) = Atom;

	case 'CISPEP'	
	case 'CONECT'	
	case 'DBREF '
		k = length(R.DBReferences)+1;
		R.DBReferences(k).idCode      = line(8:11);
		R.DBReferences(k).chainID     = line(13);
		R.DBReferences(k).seqBegin    = str2double(line(15:18));
		R.DBReferences(k).insertBegin = line(19);
		R.DBReferences(k).seqEnd      = str2double(line(21:24));
		R.DBReferences(k).insertEnd   = line(25);
		R.DBReferences(k).database    = line(27:32);
		R.DBReferences(k).dbAccession = line(34:41);
		R.DBReferences(k).dbIdCode    = line(43:54);
		R.DBReferences(k).dbseqBegin  = str2double(line(56:60));
		R.DBReferences(k).idbnsBeg    = line(61);
		R.DBReferences(k).dbseqEnd    = str2double(line(63:67));
		R.DBReferences(k).dbinsEnd    = line(68);

	case 'HELIX '	

	case 'HET   '

	case 'HETATM'
		HetAtom.AtomSerNo  = str2double(line(7:11));
		HetAtom.AtomName   = strtrim(line(13:16));
		HetAtom.altLoc     = strtrim(line(17));
		HetAtom.resName    = line(18:20);
		HetAtom.chainID    = line(22);
		HetAtom.resSeq     = str2double(line(23:26));
		HetAtom.iCode      = strtrim(line(27));
		HetAtom.X          = str2double(line(31:38));
		HetAtom.Y          = str2double(line(39:46));
		HetAtom.Z          = str2double(line(47:54));
		HetAtom.occupancy  = str2double(line(55:60));
		HetAtom.tempFactor = str2double(line(61:66));
		HetAtom.segID      = '    ';
		HetAtom.element    = strtrim(line(77:78));
		HetAtom.charge     = line(79:80);
		HetAtom.AtomNameStruct.chemSymbol = strtrim(line(13:14));
		HetAtom.AtomNameStruct.remoteInd  = line(15);
		HetAtom.AtomNameStruct.branch     = strtrim(line(16));
		R.Model(ModelSerialNo).HeterogenAtom(end+1) = HetAtom;

	case 'LINK  '	
	case 'MODRES'
	case 'MTRIX1'	
	case 'MTRIX2'	
	case 'MTRIX3'	
	case 'REVDAT'
		k = length(R.RevisionDate)+1;
		R.RevisionDate(k).modNum  = str2double(line(8:10));
		R.RevisionDate(k).modDate = line(14:22);
		R.RevisionDate(k).modId   = line(24:27);
		R.RevisionDate(k).modType = line(24:27);
		R.RevisionDate(k).record  = strtrim(reshape(line(40:67),7,4)');
		
	case 'SEQADV'
	case 'SHEET '
	case 'SSBOND'
		
	% multiple times, multiple line
	case 'FORMUL'	
	case 'HETNAM'
		hetID = line(12:14);
		tok   = strtrim(line(16:70));
		if ~isfield(R.HeterogenName,'hetID')
			R.HeterogenName(1).hetID    = hetID;
			R.HeterogenName(1).ChemName = tok;
		else
			ix = find(strcmp({R.HeterogenName.hetID},hetID));
			if isempty(ix)
				ix = length(R.HeterogenName) + 1;
				R.HeterogenName(ix).hetID    = hetID;
				R.HeterogenName(ix).ChemName = tok;
			else
				R.HeterogenName(ix).ChemName = [R.HeterogenName(ix).ChemName; tok];
			end
		end
	case 'HETSYN'	
	case 'SEQRES'
		serNum  = str2double(line(8:10));
		chainID = line(12);
		numRes  = str2double(line(14:17));
		x = strtrim(reshape([upper(line(20:4:70));lower(line(21:4:70));lower(line(22:4:70))],1,[]));
		seq     = aminolookup(x);

		if ~isfield(R.Sequence,'ChainID')
			ix = [];
		else
			ix = find(strcmp({R.Sequence.ChainID},chainID));
		end;
		if isempty(ix)
			ix = length(R.Sequence)+1;
			R.Sequence(ix).ChainID       = chainID;
			R.Sequence(ix).NumOfResidues = numRes;
			R.Sequence(ix).ResidueNames  = strtrim(line(20:70));
			R.Sequence(ix).Sequence      = seq;
		else
			R.Sequence(ix).ChainID       = chainID;
			R.Sequence(ix).NumOfResidues = numRes;
			R.Sequence(ix).ResidueNames  = [R.Sequence(ix).ResidueNames, ' ', strtrim(line(20:70))];
			R.Sequence(ix).Sequence      = [R.Sequence(ix).Sequence, seq];
		end

	case 'SITE  '
	
	% grouping 
	case 'ENDMDL'	
		R.Model(ModelSerialNo).Atom = R.Model(ModelSerialNo).Atom(1:NumModelAtom(ModelSerialNo));
		ModelSerialNo = [];
			
	case 'MODEL '
		ModelSerialNo = str2double(line(11:14));
		NumModelAtom(ModelSerialNo)         =0;
		NumModelHeterogenAtom(ModelSerialNo)=0;
		NumModelTerminal(ModelSerialNo)     =0;
		R.Model(ModelSerialNo).Atom = {};	
		R.Model(ModelSerialNo).HeterogenAtom = {};	
		R.Model(ModelSerialNo).Terminal = {};	

	case 'TER   '
		Terminal.SerialNo = str2double(line(7:11));
		Terminal.resName  = line(18:20);
		Terminal.chainID  = line(22);
		Terminal.resSeq   = str2double(line(23:26));
		Terminal.iCode    = strtrim(line(27));
 		R.Model(ModelSerialNo).Terminal(end+1) = Terminal;

	% other
	case 'JRNL  '	
	case 'REMARK'
		
	otherwise
		[tok2, tok3] = strtok(tok);
		if all(isdigit(tok2))
			value = [value;tok3];
		else
			value = tok;		
		end
	end
end;	
%s   = fread(fid,[1,inf],'uint8=>char');
fclose(fid);

