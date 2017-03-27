function [G,H] = LW_SCD_getGH(header)
% LW_SCD_getGH
%
% Inputs
% - header (LW5 header) (must contain chanlocs with topo_enabled=1)
%
% Outputs
% - G (required to compute SCD)
% - H (required to compute SCD)
%
% Dependencies : CSDtoolbox.
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
%

%get usable list of electrodes
idx=[];
scdlabels={};
chanpos2=0;
for chanpos=1:header.datasize(2);
    if header.chanlocs(chanpos).topo_enabled==1;
        chanpos2=chanpos2+1;
        scdlabels{chanpos2}=header.chanlocs(chanpos).labels;
        idx=[idx,chanpos];
    end;
end;
%get montage for use with the CSD toolbox
Montage=ExtractMontage('10-5-System_Mastoids_EGI129.csd',scdlabels');
%MapMontage(Montage);
%Derive G and H
[G,H] = GetGH(Montage);