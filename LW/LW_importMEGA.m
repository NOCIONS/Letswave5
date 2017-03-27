function [header,data] = LW_importMEGA(dataPath,sessionPhaseNumber)
% Import MEGA Neurone
%
% Inputs
% - filename: dataPath: path to directory containing NeurOne data files from one
%             measurement.
%             sessionPhaseNumber: specifies which session phase to be read,
%             if multiple sessions are present within the same;
%
% Outputs
% - header (LW5 header)
% - data (LW5 data)
%
% Dependencies : module_read_neurone_data, module_read_neurone_events,
%                module_read_neurone_xml, textprogressbar, catstruct
%
% Author : 
% Gan Huang
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information

if nargin==1
    sessionPhaseNumber=1;
end 
recording = module_read_neurone(dataPath, sessionPhaseNumber);
header.filetype='time_amplitude';
header.name=dataPath;
header.tags={};
header.history(1).description='LW_importMEGA';
header.history(1).date=date;
header.history(1).index=sessionPhaseNumber;
header.datasize=uint32([1 length(recording.signalTypes) 1 1 1 recording.properties.length*recording.properties.samplingRate]);
header.xstart=1/recording.properties.samplingRate;
header.ystart=0;
header.zstart=0;
header.xstep=1/recording.properties.samplingRate;
header.ystep=1;
header.zstep=1;

%dummy chanloc
chanloc.labels='';
chanloc.topo_enabled=0;
%set chanlocs
disp(['Importing ',num2str(length(recording.signalTypes)),' channel labels']);
for chanpos=1:length(recording.signalTypes);
    chanloc.labels=recording.signalTypes{chanpos};
    header.chanlocs(chanpos)=chanloc;
end;


%set events
numevents=length(recording.markers.index);
disp(['Importing ',num2str(numevents),' events']);
for eventpos=1:numevents;
    event.code='unknown';
    if ~isempty(recording.markers.type(eventpos));
        event.code=recording.markers.type{eventpos};
    end;
    if isnumeric(event.code);
        event.code=num2str(event.code);
    end;    
    event.latency=recording.markers.time(eventpos);
    event.epoch=1;
    header.events(eventpos)=event;
end;

disp(['Importing data (',num2str(header.datasize(6)),' samples, ',num2str(header.datasize(1)),' trial(s))']);
data=zeros(header.datasize,'single');
for k=1:length(recording.signalTypes)
    eval(['data(1,k,1,1,:)=squeeze(recording.signal.',recording.signalTypes{k},'.data);']);    
end

disp('Finished importing');
