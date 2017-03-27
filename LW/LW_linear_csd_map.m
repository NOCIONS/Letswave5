
function [outheader,outdata]=LW_linear_csd_map(header,data,numlines)
%
% LW_linear_csd
% - header
% - data
%
%
%

%transfer outheader and outdata
outheader=header;

%dz, dy
dy=1;
dz=1;

if header.datasize(4)>1;
    disp('Z dimension greater than 1, first bin will be used to compute the CSD');
end;
if header.datasize(5)>1;
    disp('Y dimension greater than 1, first bin will be used to compute the CSD');
end;

%outheader.chanlocs
outheader.chanlocs=[];
outheader.chanlocs(1).labels='CSD';
outheader.chanlocs(1).topo_enabled=0;


%meshgrid xi,yi
xi=1:1:header.datasize(6);
xi=((xi-1)*header.xstep)+header.xstart;
yi=linspace(1,header.datasize(2),numlines);
%outheader ystart, ystep
outheader.ystart=yi(1);
outheader.ystep=yi(2)-yi(1);
%meshgrid
[xi,yi]=meshgrid(xi,yi);

%meshgrid x,y
x=1:1:header.datasize(6);
x=((x-1)*header.xstep)+header.xstart;
y=1:1:header.datasize(2);
[x,y]=meshgrid(x,y);


%adjust datasize
outheader.datasize(2)=1; %one single channel
outheader.datasize(4)=1;
outheader.datasize(5)=numlines;

%prepare outdata
outdata=zeros(outheader.datasize);

%csd_maker
for epochpos=1:header.datasize(1);
    for indexpos=1:header.datasize(3);
        %csd(chanpos,:)
        csd=squeeze(data(epochpos,:,indexpos,dz,dy,:));
        outdata(epochpos,1,indexpos,1,:,:)=interp2(x,y,csd,xi,yi,'cubic');
    end;
end;



