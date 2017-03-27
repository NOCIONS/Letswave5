function LW_updateforce
% LW_update
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
if isempty(tp);
    disp('Letswave install not found!!!');
else
    [p,n,e]=fileparts(tp);
    localtarget=[p];
    disp(['Found at : ' localtarget]);
end;

%ftp
disp('Connecting to server');
f=ftp('nocions.synology.me','gamfi','gamfi123');
cd(f,'home');
l=dir(f);
idx=-1;
for i=1:length(l);
    if strcmpi(l(i).name,'letswave5.zip');
        idx=i;
    end;
end;
if idx>1;
    disp('Found the installation files on server');
    remotefile=l(idx);
    disp('Downloading the update, this can take a few minutes...');
    mget(f,l(idx).name,[localtarget filesep]);
    disp('Update downloaded');
    disp('Unzipping the update');
    unzip(l(idx).name,localtarget);
    disp('Letswave has now been updated!');
end;
close(f);

    

