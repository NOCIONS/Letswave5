function [outheader,outdata] = LW_baseline(header,data,xstart,xend,operation)
% LW_baselinesubtract
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - xstart : start of the reference interval
% - xend : end of the reference interval
% - operation : 'subtract' 'divide' 'erpercent' 'zscore' 
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
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


%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_baseline';
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
                    bl_mean=squeeze(mean(data(epochpos,channelpos,indexpos,dz,dy,dxstart:dxend),6));
                    %zscore
                    if strcmpi(operation,'zscore');
                        bl_sd=squeeze(std(data(epochpos,channelpos,indexpos,dz,dy,dxstart:dxend),0,6));
                        data(epochpos,channelpos,indexpos,dz,dy,:)=(data(epochpos,channelpos,indexpos,dz,dy,:)-bl_mean)/bl_sd;
                    end;
                    %erpercent
                    if strcmpi(operation,'erpercent');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=(data(epochpos,channelpos,indexpos,dz,dy,:)-bl_mean)/bl_mean;
                    end;
                    %divide
                    if strcmpi(operation,'divide');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=data(epochpos,channelpos,indexpos,dz,dy,:)/bl_mean;
                    end;
                    %subtract
                    if strcmpi(operation,'subtract');
                        data(epochpos,channelpos,indexpos,dz,dy,:)=data(epochpos,channelpos,indexpos,dz,dy,:)-bl_mean;
                    end;
                end;
            end;
        end;
    end;
end;

%output
outdata=data;

end

