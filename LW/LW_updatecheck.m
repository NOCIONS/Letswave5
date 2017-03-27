function [date_localfile date_remotefile]=LW_updatecheck
% LW_updatecheck
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
    disp('Letswave not found!!!');
    date_localfile='unknown';
else
    [p,n,e]=fileparts(tp);
    localtarget=[p];
    disp(['Found at : ' localtarget]);
    disp('Determining version');
    tp=which('LW_version.mat');
    if isempty(tp);
        disp('Version information is not available!!!');
        date_localfile=0;
    else
        load(tp);
        date_localfile=datestr(LW_version);
    end;
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
    date_remotefile=remotefile.date;
end;
close(f);

    

