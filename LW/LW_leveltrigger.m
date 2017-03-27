function [outheader] = LW_leveltrigger(header,data,eventcode,channel,threshold,direction,minisi);
% Segment epochs relative to events
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - eventcode
% - channel
% - index
% - z
% - y
% - threshold
% - direction : 'positive' or 'negative'
% - minisi
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5 data)
%
% Dependencies : none.
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

%transfer header
outheader=header;

disp('***Starting');

%eventpos
if isfield(outheader,'events');
    disp('Found events. New events will be appended.');
    eventpos=length(outheader.events);
else
    eventpos=1;
end;

disp('Finding events');

%loop
for epochpos=1:header.datasize(1);
    tp=squeeze(data(epochpos,channel,1,1,1,:));
    ltp=1:1:header.datasize(6);
    ltp=((ltp-1)*header.xstep)+header.xstart;
    if strcmpi(direction,'positive');
        f=find(tp>threshold);
    else
        f=find(tp<threshold);
    end;
    fltp=ltp(f);
    fltp_diff=zeros(size(fltp))+minisi;
    for k=2:length(fltp);
        fltp_diff(k)=fltp(k)-fltp(k-1);
    end;
    fltp(find(fltp_diff<minisi))=[];
    disp(['Number of triggers found : ' num2str(length(fltp))]);
    for k=1:length(fltp);
        %add event
        outheader.events(eventpos).code=eventcode;
        outheader.events(eventpos).latency=fltp(k);
        outheader.events(eventpos).epoch=epochpos;
        eventpos=eventpos+1;
    end;
    
end;
disp('*** Done!');
