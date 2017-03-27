function [outheader,data] = LW_hilbert(header,data)
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
outheader.history(i).description='LW_hilbert';
outheader.history(i).date=date;
% outheader.history(i).index=[xstart,xend];


%loop through all the data
for epochpos=1:size(data,1);
    for indexpos=1:size(data,3);
        for dz=1:size(data,4);
            for dy=1:size(data,5);
                data(epochpos,:,indexpos,dz,dy,:) = abs(hilbert(squeeze(data(epochpos,:,indexpos,dz,dy,:))'))';
            end;
        end;
    end;
end


