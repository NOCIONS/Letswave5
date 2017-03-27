function [outheader,outdata] = LW_segmentation(header,data,eventcode,xstart,xsize);
% Segment epochs relative to events
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - eventcode : the code of the event used for segmentation (string)
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
    for eventpos=1:size(header.events,2);
        if strcmpi(header.events(eventpos).code,eventcode);
            eventindex=[eventindex,eventpos];
        end;
    end;
else
    disp('No events found');
    return;
end;
if isempty(eventindex);
    disp(['No events corresponding to ',eventcode]);
    return;
end;
disp([num2str(size(eventindex,2)),' corresponding events were found.']);

%transfer header
outheader=header;

%set datasize
outheader.datasize(1)=size(eventindex,2);
outheader.datasize(6)=xsize;

%prepare outdata
outdata=zeros(outheader.datasize);

%xend
xend=xstart+((xsize-1)*outheader.xstep);

%clear outheader.events
outheader=rmfield(outheader,'events');

%xstart
outheader.xstart=xstart;

%loop through events
disp('Segmenting data and adjusting events');
eventpos3=1;
epochpos2=0;
for eventpos=1:size(eventindex,2);
    currentevent=header.events(eventindex(eventpos));
    epochpos=currentevent.epoch;
    dxstart=fix((currentevent.latency+xstart+header.xstart)/header.xstep)+1;
    dxend=dxstart+xsize-1;
    if dxstart>1;
        if dxend<=header.datasize(6);
            epochpos2=epochpos2+1;
            outdata(epochpos2,:,:,:,:,:)=data(epochpos,:,:,:,:,dxstart:dxend);
            %scan for events within epoch
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

%delete conditions if present
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'conditions');
end;
if isfield(outheader,'condition_labels');
    outheader=rmfield(outheader,'condition_labels');
end;

%delete fieldtrip_dipfit.dipoles if present
if isfield(outheader,'fieldtrip_dipfit');
    if isfield(outheader.fieldtrip_dipfit,'dipole');
        outheader.fieldtrip_dipfit=rmfield(outheader.fieldtrip_dipfit,'dipole');
    end;
end;


disp('*** Done!');
