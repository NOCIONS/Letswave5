function epochlist=LW_findepochs_events(header,epochlist,eventcode,latency1,latency2)
% LW_findepochs_events
% search for LW5 files with corresponding events between x1-x2 latencies
%
% Inputs
% - header
% - epochlist : preselection of epochs, all epochs if empty.
% - eventcode
% - latency1 
% - latency2 (set latency1=0 and latency2=0 to search all epoch)
%
% Outputs : 
% - epochlist
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

%inputlist
inputlist=epochlist;
if isempty(inputlist);
    inputlist=1:1:header.datasize(1);
    disp('No epochs were defined. Searching all epochs');
end;

%lat1 and lat2
if latency1==0;
    if latency2==0;
        disp('No limits were defined. Searching the entire epoch');
        latency1=header.xstart;
        latency2=header.xstart+((header.datasize(6)-1)*header.xstep);
    end;
end;

%selected epochs
outputlist=[];

%loop through epochs;
for i=1:length(inputlist);
    %loop through events;
    for j=1:length(header.events);
        if header.events(j).epoch==inputlist(i);
            if strcmpi(header.events(j).code,eventcode);
                if header.events(j).latency>=latency1;
                    if header.events(j).latency<=latency2;
                        outputlist=[outputlist inputlist(i)];
                    end;
                end;
            end;
        end;
    end;
end;
epochlist=outputlist;
