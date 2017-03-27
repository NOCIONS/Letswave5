function [outheader,outdata] = LW_segmentation2(header,data,eventcode,xstart,xsize);
% Segment epochs relative to events
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - eventcode : array of strings containing the code(s) of the event(s) used for segmentation
% - xstart : time of the first bin, relative to event onset
% - xsize : size of epochs (in number of bins)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5 data)
%
% Dependencies : none.
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

%find eventcode
disp('*** Searching for events');
eventindex=[];
if isfield(header,'events');
    for eventpos=1:length(header.events);
        for eventcodepos=1:length(eventcode);
            if strcmpi(header.events(eventpos).code,eventcode{eventcodepos});
                eventindex=[eventindex,eventpos];
            end;
        end;
    end;
else
    disp('No events found');
    return;
end;
if isempty(eventindex);
    disp(['No events corresponding to the selected eventcodes']);
    return;
end;
disp([num2str(length(eventindex)),' corresponding events were found.']);

%transfer header
outheader=header;

%set datasize
outheader.datasize(1)=length(eventindex);
outheader.datasize(6)=xsize;

%prepare outdata
outdata=zeros(outheader.datasize);

%xend
xend=xstart+((xsize-1)*outheader.xstep);

%clear outheader.events
outheader=rmfield(outheader,'events');

%xstart
outheader.xstart=xstart;

if isfield(header,'conditions');
    rmfield(outheader,'conditions');
end;

if isfield(header,'condition_labels');
    rmfield(outheader,'condition_labels');
end;

if isfield(header,'epochdata');
    rmfield(outheader,'epochdata');
end;
    
%loop through events
disp('Segmenting data and adjusting events');
eventpos3=1;
epochpos2=0;
for eventpos=1:length(eventindex);
    currentevent=header.events(eventindex(eventpos));
    epochpos=currentevent.epoch;
    dxstart=fix((currentevent.latency+xstart-header.xstart)/header.xstep)+1;
    dxend=dxstart+xsize-1;
    if dxstart>1;
        if dxend<=header.datasize(6);
            epochpos2=epochpos2+1;
            outdata(epochpos2,:,:,:,:,:)=data(epochpos,:,:,:,:,dxstart:dxend);
            for eventpos2=1:size(header.events,2);
                newlatency=header.events(eventpos2).latency-currentevent.latency;
                if newlatency>=xstart;
                    if newlatency<=xend;
                        %add event
                        outheader.events(eventpos3).code=header.events(eventpos2).code;
                        outheader.events(eventpos3).latency=newlatency;
                        outheader.events(eventpos3).epoch=epochpos2;
                        eventpos3=eventpos3+1;
                    end;
                end;
            end;
        else
            disp(['Event ' num2str(eventpos) ' was not segmented because epoch is outside matrix dimensions']);
        end;
    else
        disp(['Event ' num2str(eventpos) ' was not segmented because epoch is outside matrix dimensions']);
    end;
end;

outdata=outdata(1:epochpos2,:,:,:,:,:);
outheader.datasize=size(outdata);


disp('*** Done!');
