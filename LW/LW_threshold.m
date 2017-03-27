function [outheader,outdata] = LW_threshold(header,data,threshold,consecutivity,criterion)
% LW_baselinesubtract
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - threshold
% - consecutivity
% - criterion '>' '>=' '<' '<=' '='
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
outheader.history(i).description='LW_threshold';
outheader.history(i).date=date;
outheader.history(i).index=[threshold consecutivity];

%prepare outdata
outdata=zeros(size(data));

%threshold
if strcmpi(criterion,'>');
    outdata(find(data>threshold))=1;
end;
if strcmpi(criterion,'>=');
    outdata(find(data>=threshold))=1;
end;
if strcmpi(criterion,'<');
    outdata(find(data<threshold))=1;
end;
if strcmpi(criterion,'<=');
    outdata(find(data<=threshold))=1;
end;
if strcmpi(criterion,'=');
    outdata(find(data==threshold))=1;
end;

disp(['A total of ' num2str(length(find(outdata==1))) ' bins were found to satisfy threshold criterion.']);

%consecutivity
if consecutivity>0;
    disp('Consecutivity criterion >1. This may take a while...');
    data=outdata;
    outdata=zeros(size(outdata));
    %loop through all the data
    for dx=1:size(data,6);
        dx1=dx-consecutivity;
        dx2=dx+consecutivity;
        if dx1>0;
            if dx2<size(data,6);
                for epochpos=1:size(data,1);
                    for channelpos=1:size(data,2);
                        for indexpos=1:size(data,3);
                            for dz=1:size(data,4);
                                for dy=1:size(data,5);
                                    if sum(squeeze(data(epochpos,channelpos,indexpos,dz,dy,dx1:dx2)))>=(consecutivity*2)+1;
                                        outdata(epochpos,channelpos,indexpos,dz,dy,dx)=1;
                                    end;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
disp(['After applying the consecutivity criterion, ' num2str(length(find(outdata==1))) ' bins remained.']);
end;


end

