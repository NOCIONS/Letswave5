function LW_copyfile(inputheaderfilename,outputheaderfilename)
% LW_copyfile
% copy datafile (and associated files
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
        if strcmpi(iname,oname);
        else
            disp(['copying associated splinefile : ',iname,' > ',oname]);
            copyfile(iname,oname);
        end;
    end;
end;
%copy matrixfile if exists
if isfield(header,'filename_bss');
    iname=[inpath,filesep,header.filename_bss];
    oname=[outpath,filesep,header.filename_bss];
    if exist(iname,'file');
        if strcmpi(iname,oname);
        else
            disp(['copying associated matrixfile : ',iname,' > ',oname]);
            copyfile(iname,oname);
        end;
    end;
end;

%copy fieltrip_dipfit files if they exist
if isfield(header,'fieldtrip_dipfit');
    %copy fieldtrip_dipfit hdmfile if it exists
    if isfield(header.fieldtrip_dipfit,'hdmfile');
        iname=[inpath,filesep,header.fieldtrip_dipfit.hdmfile];
        oname=[outpath,filesep,header.fieldtrip_dipfit.hdmfile];
        if exist(iname,'file');
            if strcmpi(iname,oname);
            else
                disp(['copying associated fieldtrip_dipfit.hdmfile : ',iname,' > ',oname]);
                copyfile(iname,oname);
            end;
        end;
    end;
    %copy fieldtrip_dipfit mrifile if it exists
    if isfield(header.fieldtrip_dipfit,'hdmfile');
        iname=[inpath,filesep,header.fieldtrip_dipfit.mrifile];
        oname=[outpath,filesep,header.fieldtrip_dipfit.mrifile];
        if exist(iname,'file');
            if strcmpi(iname,oname);
            else
                disp(['copying associated fieldtrip_dipfit.mrifile : ',iname,' > ',oname]);
                copyfile(iname,oname);
            end;
        end;
    end;
end;
    
%copy headerfile
iname=[inpath,filesep,headerfilename];
oname=[outpath,filesep,headerfilename];
if strcmpi(iname,oname);
else
    disp(['copying header file : ',iname,' > ',oname]);
    copyfile(iname,oname);
end;
%copy datafile
iname=[inpath,filesep,datafilename];
oname=[outpath,filesep,datafilename];
if strcmpi(iname,oname);
else
    disp(['copying data file : ',iname,' > ',oname]);
    copyfile(iname,oname);
end;


