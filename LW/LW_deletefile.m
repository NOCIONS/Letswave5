function LW_deletefile(headerfilename)
% LW_delete
% delete datafile (and associated files)
%
% Inputs
% - headerfilename
%
% Outputs : none.
%
% Dependencies : none.
%
% Author : 
% André Mouraux
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information




%load header
load(headerfilename,'-mat');
%inpath
[inpath,n,e]=fileparts(headerfilename);
%infile
headerfilename=[n,'.lw5'];
datafilename=[n,'.mat'];
%delete headerfile
iname=[inpath,filesep,headerfilename];
disp(['deleting header file : ',iname]);
delete(iname);
%delete datafile
iname=[inpath,filesep,datafilename];
disp(['deleting data file : ',iname]);
delete(iname);


