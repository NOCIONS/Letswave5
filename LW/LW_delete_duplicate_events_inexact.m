function [outheader] = LW_delete_duplicate_events_inexact(header,latency);
% LW_delete_duplicate_events
% Delete duplicate events
%
% Inputs
% - header : LW5 header
% - latency
%
% Outputs
% - outheader : LW5 header
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
%


%transfer header to outheader
outheader=header;

%add history
i=size(outheader.history,2)+1;
outheader.history(i).description='LW_delete_duplicate_events_inexact';
outheader.history(i).date=date;
outheader.history(i).index=[];

%loop through events
events=header.events;
eventindex=ones(length(events),1);
if length(events)>1;
    for eventpos=1:length(events);
        currentcode=events(eventpos).code;
        currentlatency=events(eventpos).latency;
        eventlist=1:1:length(events);
        eventlist(eventpos)=[];
        for eventpos2=1:length(eventlist);
            if strcmpi(events(eventlist(eventpos2)).code,currentcode);
                if (abs(currentlatency-events(eventlist(eventpos2)).latency))<latency;
                    if currentlatency>events(eventlist(eventpos2)).latency;
                        eventindex(eventpos)=0;
                        disp(['E ' num2str(eventpos) ' = E ' num2str(eventlist(eventpos2))]);
                    end;
                end;
            end;
        end;
    end;
end;

idx=find(eventindex==0);
if isempty(idx);
else
    disp(['Found ' num2str(length(idx)) ' duplicate events.']);
end;
idx=find(eventindex==1);
outheader.events=events(idx);