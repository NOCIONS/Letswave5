function source = LW_fieldtrip_dipfit_fitdipole_alt(vol,elec,topo,grid_resolution)
% LW_fieldtrip_dipdit_fitdipole
% Fit a dipole
%
% Inputs
% - vol (headmodel)
% - elec structure with information concerning sensors (elec.pnt(numchans,3); elec.label{numchans})
% - topo matrix(numchans) with data at each sensor
% - grid_resolution : resolution of grid search (e.g. 10)

% Outputs
% - dipole
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

%prepare ft_data
ft_data=[];
ft_data.avg(:,1)=topo;
ft_data.time=1;
ft_data.label=elec.label;
ft_data.dimord='chan_time';
ft_data.cfg=[];

%gridsearch configuration
cfg=[];
cfg.model='moving';
cfg.gridsearch='yes';
cfg.nonlinear='no';
cfg.channel=elec.label;
%cfg.vol=ft_fetch_vol(vol);
%cfg.elec=ft_fetch_sens(elec);
[vol sens]=ft_prepare_vol_sens(vol,elec);
cfg.elec=sens;
cfg.vol=vol;
cfg.latency=1;
cfg.grid.resolution=grid_resolution;

source=[];
source = ft_dipolefitting(cfg, ft_data);
