function [outheader,outdata] = LW_artefactsuppression_unsegment(header,data,eventcode,x1,x2)
% LW_artefactsuppression_unsegment
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - eventcode (LW5 data)
% - x1,x2
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
%
% Dependencies : none.
%
% Author : 
% Gan Huang
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
st='LW_artefactsuppression_unsegment ';
st=[st ' x1:' num2str(x1) ' x2:' num2str(x2) ' codes : '];
for i=1:length(eventcode);
    st=[st eventcode{i} ' '];
end;
outheader.history(i).description=st;
outheader.history(i).date=date;
outheader.history(i).code=eventcode;
outheader.history(i).index=[x1,x2];

eventindex=[];
if isfield(header,'events');
    for eventpos=1:length(header.events);
        for eventcodepos=1:length(eventcode);
            if strcmpi(header.events(eventpos).code,eventcode{eventcodepos});
                eventindex=[eventindex,header.events(eventpos).latency];
            end;
        end;
    end;
else
    disp('No events found');
    return;
end;

%determine dx1 and dx2
xv=[];
for k=1:length(eventindex)
    dx1=fix(((x1-header.xstart+eventindex(k))/header.xstep)+1);
    dx2=fix(((x2-header.xstart+eventindex(k))/header.xstep)+1);
    xv=[xv;dx1,dx2];
end

%set outdata
outdata=data;

%loop 
for epochpos=1:header.datasize(1);
    for chanpos=1:header.datasize(2);
        for indexpos=1:header.datasize(3);
            for dz=1:header.datasize(4);
                for dy=1:header.datasize(5);
                    yv=squeeze(data(epochpos,chanpos,indexpos,dz,dy,:));
                    for dxv=1:length(eventindex)
                        xi=[xv(dxv,1) xv(dxv,2)];
                        yv(xv(dxv,1):xv(dxv,2))=interp1(xi,yv(xi),xi(1):xi(2));
                    end
                    outdata(epochpos,chanpos,indexpos,dz,dy,:)=yv;
                end;
            end;
        end;
    end;
end;