function [header,data] = LW_importLW4MAT(filename);
% Import Letswave4 Structured MAT files
%
% Inputs
% - filename: name of MAT file
%
% Outputs
% - header (LW5 header)
% - data (LW5 data)
%
% Dependencies : none
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


%load the MAT file
disp(['Loading ',filename]);
%load data
tp=load(filename);
[p,n,e]=fileparts(filename);
ni=find(n==' ');
n(ni)='_';
eval(['dat=tp.' n]);


%set header
disp('Importing header');
header.filetype='time_amplitude';
header.name=n;
header.tags={};
header.history(1).description='LW_importLW4MAT';
header.history(1).date=date;
header.history(1).index=n;
header.datasize=[dat.NumEpochs dat.NumChannels 1 1 dat.YSize dat.XSize];
header.xstart=dat.XStart;
header.ystart=dat.YStart;
header.zstart=0;
header.xstep=dat.XStep;
header.ystep=dat.YStep;
header.zstep=1;

%set chanlocs
disp(['Importing channel labels']);
%dummy chanloc
chanloc.labels='';
chanloc.topo_enabled=0;
%set chanlocs
for chanpos=1:length(dat.Channels);
    chanloc.labels=dat.Channels(chanpos).label;
    header.chanlocs(chanpos)=chanloc;
end;

header.evens=[];

%set data
disp(['Importing data (',num2str(dat.XSize),' samples, ',num2str(dat.NumEpochs),' trial(s))']);
data=zeros(header.datasize);
if header.datasize(1)>1;
    for chanpos=1:header.datasize(2);
        for epochpos=1:header.datasize(1);
            for ypos=1:header.datasize(5);
                data(epochpos,chanpos,1,1,ypos,:)=squeeze(dat.RealData(:,ypos,chanpos,epochpos));
            end;
        end;
    end;
else
    for chanpos=1:header.datasize(2);
        for ypos=1:header.datasize(5);
            data(1,chanpos,1,1,ypos,:)=squeeze(dat.RealData(:,ypos,chanpos));
        end;
    end;
end;

disp('Finished importing');
