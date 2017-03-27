function LW_fieldtrip_dipfit_plotdipole2b(header,dipolepos)
%LW_fieldtrip_dipfit_plotdipole(header,data,dipolepos)
%
% Inputs : 
% 
% header
% dipolepos
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


hold on;

%dipole
dipole=header.fieldtrip_dipfit.dipole(dipolepos);

%fetch dipole information
if ndims(dipole)==1;
    dip(1).posxyz=dipole.posxyz(:);
    dip(1).momxyz=dipole.momxyz(:);
else
    for i=1:size(dipole.posxyz,1);
        dip(i).posxyz=dipole.posxyz(i,:);
        dip(i).momxyz=dipole.momxyz(i,:);
    end;
end;

%reformat dipole information
for i=1:length(dip);
    dip(i).posxyz(2)=-dip(i).posxyz(2);
    dip(i).posxyz(:)=dip(i).posxyz([2 1 3]);
    dip(i).momxyz(2)=-dip(i).momxyz(2);
    dip(i).momxyz(:)=dip(i).momxyz([2 1 3]);
    ft_plot_dipole(dip(i).posxyz,dip(i).momxyz,'units','mm');
end;

hold off;