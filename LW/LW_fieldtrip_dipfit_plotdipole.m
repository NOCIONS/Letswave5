function LW_fieldtrip_dipfit_plotdipole(header,data,dipolepos)
%LW_fieldtrip_dipfit_plotdipole(header,data,dipolepos)
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information

%dipole information
epochpos=header.fieldtrip_dipfit.dipole(dipolepos).epochpos;
indexpos=header.fieldtrip_dipfit.dipole(dipolepos).indexpos;
dx=header.fieldtrip_dipfit.dipole(dipolepos).dxpos;
dy=header.fieldtrip_dipfit.dipole(dipolepos).dypos;
dz=header.fieldtrip_dipfit.dipole(dipolepos).dzpos;
dipole=header.fieldtrip_dipfit.dipole(dipolepos);

%prepare topo
topo=squeeze(data(epochpos,:,indexpos,dz,dy,dx));

%topoplot
gridscale=256;
topoplot(topo,header.chanlocs,'dipole',dipole,'diporient',-1,'dipnorm','off','gridscale',gridscale,'shading','interp','whitebk','on');

