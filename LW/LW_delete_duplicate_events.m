function [outheader] = LW_delete_duplicate_events(header);
% LW_delete_duplicate_events
% Delete duplicate events
%
% Inputs
% - header : LW5 header
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
outheader.history(i).description='LW_delete_duplicate_events';
outheader.history(i).date=date;
outheader.history(i).index=[];


%loop through events
events=header.events;
eventindex=ones(size(events));
for eventpos=1:size(events,2)-1;
    for eventpos2=eventpos+1:size(events,2);
        if isequal(events(eventpos),events(eventpos2))
            eventindex(eventpos2)=0;
        end;
    end;
end;
selection=[];
for eventpos=1:size(events,2);
    if eventindex(eventpos)==0;
        selection=[selection eventpos];
    end;
end;
events(selection)=[];
disp(['deleted events : ',num2str(selection)]);
outheader.events=events;