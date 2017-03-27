function LW_makezip
% LW_makezip
%
%
% Author : 
% Andre Mouraux
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%


%local
disp('Locating local install');
tp=which('letswave.m');
[p,n,e]=fileparts(tp);
localtarget=[p];
disp(['Found at : ' localtarget]);

%create version mat
LW_version=now;
filename=[localtarget filesep 'LW_version.mat'];
save(filename,'LW_version');

%make zip
zip('letswave5.zip',[localtarget filesep],filesep);


