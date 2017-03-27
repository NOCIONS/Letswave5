function [topo,elec] = LW_fieldtrip_dipfit_fetchtopo(header,data,rejected_channels,epochpos,indexpos,xstart,xend,ystart,yend,zstart,zend)
% LW_fieldtrip_dipdit_fitdipole
% Fit a dipole
%
% Inputs
% - header (LW5 header)
% - data (headmodel)
% - rejected_channels
% - epochpos
% - indexpos
% - xstart,xend
% - ystart,yend
% - zstart,zend

% Outputs
% - topo
% - elec
%
% Dependencies : none
%
% Author : 
% Andre Mouraux
% Institute of Neurosciences (IONS)
% Universite catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information

dxstart=round((xstart-header.xstart)/header.xstep)+1;
dxend=round((xend-header.xstart)/header.xstep)+1;

dystart=round((ystart-header.ystart)/header.ystep)+1;
dyend=round((yend-header.ystart)/header.ystep)+1;

dzstart=round((zstart-header.zstart)/header.zstep)+1;
dzend=round((zend-header.zstart)/header.zstep)+1;

%elec
chanlocs=header.chanlocs;
chanlocs_idx=1:1:length(header.chanlocs);
chanlocs(rejected_channels)=[];
chanlocs_idx(rejected_channels)=[];
remove_channels=[];
for chanpos=1:length(chanlocs);
    if chanlocs(chanpos).fieldtrip_dipfit.enabled==1;
    else
        remove_channels=[remove_channels chanpos];
    end;
end;
chanlocs(remove_channels)=[];
chanlocs_idx(remove_channels)=[];
elec=[];
for i=1:length(chanlocs);
    elec.pnt(i,1)=chanlocs(i).fieldtrip_dipfit.X;
    elec.pnt(i,2)=chanlocs(i).fieldtrip_dipfit.Y;
    elec.pnt(i,3)=chanlocs(i).fieldtrip_dipfit.Z;
    elec.label{i}=chanlocs(i).labels;
end;
elec.label=elec.label';

%topo
topo=data(epochpos,chanlocs_idx,indexpos,dzstart:dzend,dystart:dyend,dxstart:dxend);
topo=mean(topo,4);
topo=mean(topo,5);
topo=mean(topo,6);
topo=squeeze(topo);



    
