
function [outheader,outdata]=LW_linear_csd(header,data)
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
if header.datasize(2)<=3;
    disp('ERROR : Computing the CSD requires more than 3 channels!!!');
end;


%adjust datasize
outheader.datasize(2)=outheader.datasize(2)-2; %remove two channels
outheader.datasize(4)=1;
outheader.datasize(5)=1;
outheader.chanlocs=header.chanlocs(2:end-1);

%prepare outdata
outdata=zeros(outheader.datasize);

%create the CSD
for epochpos=1:header.datasize(1);
    for indexpos=1:header.datasize(3);
        for chanpos=2:header.datasize(2)-1;
            outdata(epochpos,chanpos-1,indexpos,1,1,:)=-1.*data(epochpos,chanpos-1,indexpos,1,1,:)+-1.*data(epochpos,chanpos+1,indexpos,1,1,:)+2.*data(epochpos,chanpos,indexpos,1,1,:);
        end;
    end;
end;