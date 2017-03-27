function LW_movefile(inputheaderfilename,outputheaderfilename)
% LW_movefile
% move datafile (and associated files
%
% Inputs
% - inputheaderfilename
% - outputheaderfilename
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
load(inputheaderfilename,'-mat');
%inpath
[inpath,n,e]=fileparts(inputheaderfilename);
%infile
headerfilename=[n,'.lw5'];
datafilename=[n,'.mat'];
%outpath
[outpath,n,e]=fileparts(outputheaderfilename);
%copy splinefile if exists
if isfield(header,'filename_spl');
    iname=[inpath,filesep,header.filename_spl];
    oname=[outpath,filesep,header.filename_spl];
    if exist(iname,'file');
        disp(['moving associated splinefile : ',iname,' > ',oname]);
        movefile(iname,oname);
    end;
end;
%copy matrixfile if exists
if isfield(header,'filename_bss');
    iname=[inpath,filesep,header.filename_bss];
    oname=[outpath,filesep,header.filename_bss];
    if exist(iname,'file');
        disp(['moving associated matrixfile : ',iname,' > ',oname]);
        movefile(iname,oname);
    end;
end;
%copy headerfile
iname=[inpath,filesep,headerfilename];
oname=[outpath,filesep,headerfilename];
disp(['moving header file : ',iname,' > ',oname]);
movefile(iname,oname);
%copy datafile
iname=[inpath,filesep,datafilename];
oname=[outpath,filesep,datafilename];
disp(['moving data file : ',iname,' > ',oname]);
movefile(iname,oname);


