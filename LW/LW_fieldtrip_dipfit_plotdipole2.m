function LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint)
%LW_fieldtrip_dipfit_plotdipole(header,data,dipolepos)
%
% Inputs : 
% 
% header
% data
% vol
% volpos
% volcolor: e.g. [1,0.8,0.8]
% dipolepos
% viewpoint: e.g. [0 90]
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

%fetch patch
tri=vol.bnd(volpos).tri;
pnt=vol.bnd(volpos).pnt;

%volume limits
xmax=max(abs(pnt(:,1)));
ymax=max(abs(pnt(:,2)));
zmax=max(abs(pnt(:,3)));

%white background
set(gcf,'Color','w');

%color map
colormap=volcolor;

%plot volume
trisurf(tri,pnt(:,1),pnt(:,2),pnt(:,3),1,'EdgeColor','none','DiffuseStrength',0.3,'FaceAlpha',0.5);
material metal;
camlight;
lighting gouraud;

%tighten scales to volume limits
set(gca,'XLim',[-xmax xmax]);
set(gca,'YLim',[-ymax ymax]);
set(gca,'ZLim',[-zmax zmax]);

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

%set viewpoint
view(viewpoint);

hold off;