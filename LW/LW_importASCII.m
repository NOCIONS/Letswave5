function [header,data] = LW_importASCII(filename,headersize,channelline,epochsize,xstart,samplingrate,delimiter);
% Import ASCII files (epoched)
%
% Inputs
% - filename: name of ASCII file
% - headersize: number of lines of the header (no header : headersize=0)
% - channelline: line position of channel labels (no channel labels : channelline=0)
% - epochsize : size of epochs (number of bins)
% - xstart : latency of first datapoint
% - samplingrate
% - delimiter : character used to delimit different columns (e.g. ' ')
% Outputs
% - header (LW5 header)
% - data (LW5 data)
%
% Dependencies : ft_read_event, ft_read_header, ft_read_data (FIELDTRIP)
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


%open file
[f,message]=fopen(filename);
if isempty(message);
else
    disp(message);
end;

%skip header lines if headersize>0
if headersize>0;
    for i=1:headersize;
        st=fgetl(f);
        if channelline>0;
            if channelline==i;
                channelstring=st;
            end;
        end;
    end;
end;

%set dummy channel labels if channelline=0
if channelline==0;
    %get current position in file
    currentpos=ftell(f);
    st=fgetl(f);
    tp=textscan(st,'%s','Delimiter',delimiter,'MultipleDelimsAsOne',1);
    numchannels=length(tp{1});
    for i=1:numchannels;
        channel_labels{i}=['C' num2str(i)];
    end;
    fseek(f,0,'bof');
else
    tp=textscan(st,'%s','Delimiter',delimiter,'MultipleDelimsAsOne',1);
    channel_labels=tp{1};
    numchannels=length(channel_labels);
end;

disp(['number of channels : ',num2str(numchannels)]);
disp(['xsize : ',num2str(epochsize)]);

%data=zeros(1,1,1,1,1,1);

%read epochs
epochpos=1;
while not(feof(f));
    [tp,position]=textscan(f,'%n',epochsize*numchannels,'Delimiter',delimiter,'MultipleDelimsAsOne',1);
    %length(tp{1})
    if length(tp{1})==epochsize*numchannels;
        data(epochpos,:,1,1,1,:)=reshape(tp{1},numchannels,epochsize);
        epochpos=epochpos+1;
    else
        fread(f,1);
    end;
end;

%build header
%set header
disp('Building header');
header.filetype='time_amplitude';
header.name=filename;
header.tags='';
header.history(1).description='LW_importASCII';
header.history(1).date=date;
header.history(1).index=[];
header.datasize=[size(data,1) size(data,2) size(data,3) size(data,4) size(data,5) size(data,6)];
header.xstart=xstart;
header.ystart=0;
header.zstart=0;
header.xstep=1/samplingrate;
header.ystep=1;
header.zstep=1;

disp(['Number of epochs found : ' num2str(header.datasize(1))]);

%set chanlocs
disp(['Importing channel labels']);
%dummy chanloc
chanloc.labels='';
chanloc.topo_enabled=0;
%set chanlocs
for chanpos=1:numchannels;
    chanloc.labels=strtrim(channel_labels{chanpos});
    header.chanlocs(chanpos)=chanloc;
end;

header.events=[];