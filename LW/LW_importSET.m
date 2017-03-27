function [header,data] = LW_importSET(filename);
% Import EEGLAB SET files
%
% Inputs
% - filename: name of SET file
%
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


%load the SET file
disp(['Loading ',filename]);
%load data
dat=ft_read_data(filename);
%load header
hdr=ft_read_header(filename);
%load events
trg=ft_read_event(filename);

%set header
disp('Importing header');
header.filetype='time_amplitude';
header.name=filename;
header.tags={};
header.history(1).description='LW_importSET';
header.history(1).date=date;
header.history(1).index=filename;
header.datasize=[hdr.nTrials hdr.nChans 1 1 1 hdr.nSamples];
header.xstart=(hdr.nSamplesPre/hdr.Fs)*-1;
header.ystart=0;
header.zstart=0;
header.xstep=1/hdr.Fs;
header.ystep=1;
header.zstep=1;

%set chanlocs
disp(['Importing ',num2str(hdr.nChans),' channel labels']);
%dummy chanloc
chanloc.labels='';
chanloc.topo_enabled=0;
%set chanlocs
for chanpos=1:hdr.nChans;
    chanloc.labels=hdr.label{chanpos};
    header.chanlocs(chanpos)=chanloc;
end;

%set events
numevents=size(trg,2);
disp(['Importing ',num2str(numevents),' events']);
%set events
for eventpos=1:numevents;
    event.code='unknown';
    if isempty(trg(eventpos).value);
        event.code=trg(eventpos).type;
    else
        event.code=trg(eventpos).value;
    end;
    if isnumeric(event.code);
        event.code=num2str(event.code);
    end;
    event.latency=(trg(eventpos).sample*header.xstep)+header.xstart;
    event.epoch=1;
    header.events(eventpos)=event;
end;

%set data
disp(['Importing data (',num2str(hdr.nSamples),' samples, ',num2str(hdr.nTrials),' trial(s))']);
data=zeros(header.datasize);
for chanpos=1:header.datasize(2);
    for epochpos=1:header.datasize(1);
        data(epochpos,chanpos,1,1,1,:)=squeeze(dat(chanpos,:,epochpos));
    end;
end;

disp('Finished importing');
