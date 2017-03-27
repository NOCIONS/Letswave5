function outheader=LW_fieldtrip_dipfit_fitdipole(header,data,headmodel,epochpos,indexpos,dz,dy,dx,numdipoles,symmetry,gridresolution,dipolelabel)
% LW_fieldtrip_dipdit_fitdipole
% Fit a dipole using the scalp topography at position defined by
% epochpos,indexpos,zpos,ypos, xpos
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - headmodel
% - epochpos
% - indexpos
% - dz
% - dy
% - dx
% - numdipoles
% - symmetry : 'x','y','z' or 'no'
% - gridresolution (e.g. 10)
% - dipolelabel
%
% Outputs
% - outheader : LW5 header
%
% Dependencies : Fieldtrip : $
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


%prepare elec
j=1;
for i=1:length(header.chanlocs);
    if header.chanlocs(i).fieldtrip_dipfit.enabled==1;
        chanlocs(j,1)=header.chanlocs(i).fieldtrip_dipfit.X;
        chanlocs(j,2)=header.chanlocs(i).fieldtrip_dipfit.Y;
        chanlocs(j,3)=header.chanlocs(i).fieldtrip_dipfit.Z;
        chanlabels{j}=header.chanlocs(i).labels;
        selected_channels(j)=i;
        j=j+1;
    end;
end;
chanlabels=chanlabels';
elec.pnt=chanlocs;
elec.label=chanlabels;

%prepare topo
topo=squeeze(data(epochpos,selected_channels,indexpos,dz,dy,dx));

%prepare ft_data
ft_data=[];
ft_data.avg(:,1)=topo;
ft_data.time=1;
ft_data.label=elec.label;
ft_data.dimord='chan_time';
ft_data.cfg=[];

%dipole_fitting cfg (gridsearch)
cfg=[];
cfg.numdipoles=numdipoles;
if strcmpi(symmetry,'no');
else
    cfg.symmetry=symmetry;
end;
cfg.model      = 'moving';
cfg.gridsearch = 'yes';
cfg.nonlinear  = 'no';
cfg.channel=chanlabels;
cfg.vol=headmodel;
cfg.elec=elec;
cfg.latency=1;
cfg.grid.resolution=gridresolution;
cfg.feedback='textbar';

%gridsearch
source=ft_dipolefitting(cfg,ft_data);

%dipole_fitting cfg (non linear)
cfg.dip=source.dip;
cfg.gridsearch='no';
cfg.nonlinear='yes';
cfg.feedback='textbar';
source=ft_dipolefitting(cfg,ft_data);

%reformat the output dipole sources 
dipole.dip=source.dip;
dipole.posxyz=source.dip.pos;
dipole.momxyz=reshape(source.dip.mom,3,length(source.dip.mom)/3)';
dipole.diffmap=source.Vmodel - source.Vdata;
dipole.sourcepot=source.Vmodel;
dipole.datapot=source.Vdata;
dipole.rv=NaN;
if isfield(source.dip,'rv');
    dipole.rv=source.dip.rv;
end;
if numdipoles==2;
    dipole.posxyz(:,:)=dipole.posxyz(:,[2 1 3]);
    dipole.momxyz(:,:)=dipole.momxyz(:,[2 1 3]);
    dipole.posxyz(:,2)=-dipole.posxyz(:,2);
    dipole.momxyz(:,2)=-dipole.momxyz(:,2);
else
    dipole.posxyz(:)=dipole.posxyz([2 1 3]);
    dipole.momxyz(:)=dipole.momxyz([2 1 3]);
    dipole.posxyz(2)=-dipole.posxyz(2);
    dipole.momxyz(2)=-dipole.momxyz(2);
end;

%additional dipole information
dipole.epochpos=epochpos;
dipole.indexpos=indexpos;
dipole.dzpos=dz;
dipole.dypos=dy;
dipole.dxpos=dx;
dipole.label=dipolelabel;

%outheader
outheader=header;
if isfield(outheader.fieldtrip_dipfit,'dipole');
    i=length(outheader.fieldtrip_dipfit.dipole)+1;
else
    i=1;
end;
outheader.fieldtrip_dipfit.dipole(i)=dipole;
disp('POS : ');
disp(source.dip.pos);
disp('MOM : ');
disp(source.dip.mom);
disp('RV : ');
disp(source.dip.rv);



