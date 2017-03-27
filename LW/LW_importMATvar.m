function [header,data] = LW_importMATvar(matdata,sampling_rate,xstart,dim_labels);
% Import Letswave4 Structured MAT files
%
% Inputs
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


header=[];
data=[];

%set header
disp('Creating header');
header.filetype='time_amplitude';
header.name='data';
header.tags={};
header.history(1).description='LW_importMATvar';
header.history(1).date=date;
header.history(1).index=0;
header.xstart=xstart;
header.ystart=0;
header.zstart=0;
header.xstep=1/sampling_rate;
header.ystep=1;
header.zstep=1;

%dim_list
dimlist{1}='epochs';
dimlist{2}='channels';
dimlist{3}='index';
dimlist{4}='Z';
dimlist{5}='Y';
dimlist{6}='X';

%check dim_labels
ndims(matdata)
length(dim_labels)
if length(dim_labels)==ndims(matdata);
else
    disp('Error : the number of dimensions in the data does not correspond to the number of dimension labels!');
    return;
end;

disp('Importing the data');
%prepare data
if ndims(matdata)==1;
    data(:,1,1,1,1,1)=matdata;
end;
if ndims(matdata)==2;
    data(:,:,1,1,1,1)=matdata;
end;
if ndims(matdata)==3;
    data(:,:,:,1,1,1)=matdata;
end;
if ndims(matdata)==4;
    data(:,:,:,:,1,1)=matdata;
end;
if ndims(matdata)==5;
    data(:,:,:,:,:,1)=matdata;
end;
if ndims(matdata)==6;
    data(:,:,:,:,:,:)=matdata;
end;


%dim_order
for i=1:length(dim_labels);
    tp=find(strcmpi(dim_labels{i},dimlist));
    if isempty(tp);
        disp('Error : dimension label was not recognized');
        return;
    else
        a(i)=tp;
        
    end;
end;
dim_order=[0 0 0 0 0 0];
for i=1:length(a);
    dim_order(a(i))=i;
end;
tp=find(dim_order==0);
if isempty(tp);
else
    for i=1:length(tp);
        dim_order(tp(i))=length(a)+i;
    end;
end;

data=permute(data,dim_order);

header.datasize=size(data);


%set chanlocs
disp(['Creating channel labels']);
%dummy chanloc
chanloc.labels='';
chanloc.topo_enabled=0;
%set chanlocs
for chanpos=1:header.datasize(2);
    chanloc.labels=['channel' num2str(chanpos)];
    header.chanlocs(chanpos)=chanloc;
end;

header.events=[];


disp('Finished importing');
