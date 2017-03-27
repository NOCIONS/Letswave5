function [outheader,outdata] = LW_DCremoval(header,data,doDetrend)
% LW_DCremoval
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none.
%
% Author : 
% Corentin Jacques
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_DCremoval';
outheader.history(i).date=date;
% outheader.history(i).index=[xstart,xend];


%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    %calculate DC
                    bl=squeeze(mean(data(epochpos,channelpos,indexpos,dz,dy,:),6));
                    %subtract baseline
                    if doDetrend;
                     data(epochpos,channelpos,indexpos,dz,dy,:) = detrend(data(epochpos,channelpos,indexpos,dz,dy,:)-bl,'linear');
                    else
                    data(epochpos,channelpos,indexpos,dz,dy,:) = data(epochpos,channelpos,indexpos,dz,dy,:)-bl;
                    end
                end;
            end;
        end;
    end;
end;

%output
outdata=data;

end

