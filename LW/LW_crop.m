function [outheader,outdata] = LW_crop(header,data,xcrop,ycrop,zcrop,x1,x2,y1,y2,z1,z2)
% LW_crop
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - xcrop : crop X dimension (1)
% - ycrop : crop Y dimension (1)
% - zcrop : crop Z dimension (1)
% - x1,x2 : start and end of X dimension only used if xcrop=1
% - y1,y2 : start and end of Y dimension only used if ycrop=1
% - z1,z2 : start and end of Z dimension only usde if zcrop=1
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
%

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_crop';
outheader.history(i).date=date;
outheader.history(i).index=[xcrop,ycrop,zcrop,x1,x2,y1,y2,z1,z2];

%determine dx1 and dx2
if xcrop==0;
    dx1=1;
    dx2=header.datasize(6);
else
    dx1=fix(((x1-header.xstart)/header.xstep)+1);
    dx2=fix(((x2-header.xstart)/header.xstep)+1);
    %set outheader.xstart
    outheader.xstart=x1;
end;
dxsize=(dx2-dx1)+1;

%determine dy1 and dy2
if ycrop==0;
    dy1=1;
    dy2=header.datasize(5);
else
    dy1=fix(((y1-header.ystart)/header.ystep)+1);
    dy2=fix(((y2-header.ystart)/header.ystep)+1);
    %set outheader.xstart
    outheader.ystart=y1;
end;
dysize=(dy2-dy1)+1;

%determine dz1 and dz2
if zcrop==0;
    dz1=1;
    dz2=header.datasize(4);
else
    dz1=fix(((z1-header.zstart)/header.zstep)+1);
    dz2=fix(((z2-header.zstart)/header.zstep)+1);
    %set outheader.xstart
    outheader.zstart=z1;
end;
dzsize=(dz2-dz1)+1;

%set new datasize
outheader.datasize(4)=dzsize;
outheader.datasize(5)=dysize;
outheader.datasize(6)=dxsize;

%set outdata
outdata=data(:,:,:,dz1:dz2,dy1:dy2,dx1:dx2);

%check events
newevents=[];
if xcrop==1;
    if isfield(outheader,'events');
        eventpos2=1;
        for eventpos=1:size(outheader.events,2);
            lat=outheader.events(eventpos).latency;
            if lat>=x1;
                if lat<=x2;
                    newevents(eventpos2).code=outheader.events(eventpos).code;
                    newevents(eventpos2).latency=outheader.events(eventpos).latency;
                    newevents(eventpos2).epoch=outheader.events(eventpos).epoch;
                    eventpos2=eventpos2+1;
                end;
            end;
        end;
        if eventpos2>1;
            outheader.events=newevents;
        else
            outheader.events=[];
        end;
    end;
end;