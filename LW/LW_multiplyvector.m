function [outheader,outdata] = LW_multiplyvector(header,data,vector)
% LW_multiplyvector
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - vector : must be of same size as header.datasize(6)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
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

%add history
outheader=header;
i=length(outheader.history)+1;
outheader.history(i).description='LW_multiplyvector';
outheader.history(i).date=date;
outheader.history(i).index=[];


%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    data(epochpos,channelpos,indexpos,dz,dy,:)=squeeze(data(epochpos,channelpos,indexpos,dz,dy,:)).*vector;
                end;
            end;
        end;
    end;
end;

%output
outdata=data;

