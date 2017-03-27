function [outheader,outdata] = LW_zscore(header,data,xstart,xend)
% LW_zscore
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - xstart : start of the reference interval
% - xend : end of the reference interval
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


%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_zscore';
outheader.history(i).date=date;
outheader.history(i).index=[xstart,xend];


%determine dxstart and dxend
dxstart=round(((xstart-header.xstart)/header.xstep)+1);
dxend=round(((xend-header.xstart)/header.xstep)+1);

%check limits
if dxstart<1;
    dxstart=1;
end;

if dxend>header.datasize(6);
    dxend=header.datasize(6);
end;

%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    %calculate baseline average and standard deviation
                    bl_av=mean(squeeze(data(epochpos,channelpos,indexpos,dz,dy,dxstart:dxend)));
                    bl_sd=std(squeeze(data(epochpos,channelpos,indexpos,dz,dy,dxstart:dxend)));
                    %zscore=(data-data_av)/data_sd
                    data(epochpos,channelpos,indexpos,dz,dy,:)=(data(epochpos,channelpos,indexpos,dz,dy,:)-bl_av)/bl_sd;
                end;
            end;
        end;
    end;
end;

%output
outdata=data;

end

