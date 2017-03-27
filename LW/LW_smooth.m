function [outheader,outdata] = LW_smooth(header,data,windowsize)
% LW_smooth
% Smooth response data
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - windowsize : width of the window (in bins)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none
%
% Author :
% Gan Huang
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
outdata=data;
for epochpos=1:size(data,1)
    for chanpos=1:header.datasize(2)
        for indexpos=1:header.datasize(3)
            for dz=1:header.datasize(4)
                for dy=1:size(data,5)
                    outdata(epochpos,chanpos,indexpos,dz,dy,:)=smooth(data(epochpos,chanpos,indexpos,dz,dy,:),windowsize);
                end
            end
        end
    end
end
