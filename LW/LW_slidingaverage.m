function [outheader,outdata] = LW_averageepochs(header,data,varargin)
% LW_averageepochs
% Average epochs
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - varargin : 
% - dimension : 1=X,2=Y,3=Z
% - width
% - operation : 'average' 'stdev'
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
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
%

tp=size(varargin,2);
if (tp>0);
    dimension=varargin{1};
    width=varargin{2};
    operation=varargin{3};
else
    dimension=1;
    width=0.1;
    operation='average';
end;


if strcmpi(operation,'average');
    operation_switch=1;
end;

if strcmpi(operation,'stdev');
    operation_switch=2;
end;

if strcmpi(operation,'max');
    operation_switch=3;
end;

if strcmpi(operation,'min');
    operation_switch=4;
end;

if strcmpi(operation,'perc75');
    operation_switch=5;
end;

if strcmpi(operation,'perc25');
    operation_switch=6;
end;

if strcmpi(operation,'maxminmean');
    operation_switch=7;
end;



disp(['Dimension : ' num2str(dimension)]);
disp(['Width : ' num2str(width)]);
disp(['Operation : ' operation]);
%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_averageepochs';
outheader.history(i).date=date;
outheader.history(i).index=varargin;

%check dimension
if dimension==1; %X
    binwidth=round(width/header.xstep);
    binwidth2=round(binwidth/2);
end;
if dimension==2; %Y
    binwidth=round(width/header.ystep);
    binwidth2=round(binwidth/2);
end;
if dimension==3; %Z
    binwidth=round(width/header.wstep);
    binwidth2=round(binwidth/2);
end;

%loop
if dimension==1;
    for dx=1:header.datasize(6);
        dx1=dx-binwidth2;
        dx2=dx+binwidth2;
        if dx1<1;
            dx1=1;
        end;
        if dx2>header.datasize(6);
            dx2=header.datasize(6);
        end;
        if operation_switch==1;
            outdata(:,:,:,:,:,dx)=mean(data(:,:,:,:,:,dx1:dx2),6);
        end;
        if operation_switch==2;
            outdata(:,:,:,:,:,dx)=std(data(:,:,:,:,:,dx1:dx2),0,6);
        end;
        if operation_switch==3;
            outdata(:,:,:,:,:,dx)=max(data(:,:,:,:,:,dx1:dx2),[],6);
        end;
        if operation_switch==4;
            outdata(:,:,:,:,:,dx)=min(data(:,:,:,:,:,dx1:dx2),[],6);
        end;
        if operation_switch==5;
            outdata(:,:,:,:,:,dx)=prctile(data(:,:,:,:,:,dx1:dx2),75,6);
        end;
        if operation_switch==6;
            outdata(:,:,:,:,:,dx)=prctile(data(:,:,:,:,:,dx1:dx2),25,6);
        end;
        if operation_switch==7;
            outdata(:,:,:,:,:,dx)=(max(data(:,:,:,:,:,dx1:dx2),[],6)-mean(data(:,:,:,:,:,dx1:dx2),6)).*(mean(data(:,:,:,:,:,dx1:dx2),6)-min(data(:,:,:,:,:,dx1:dx2),[],6));
        end;
    end;
end;

if dimension==2;
    for dy=1:header.datasize(5);
        dy1=dy-binwidth2;
        dy2=dy+binwidth2;
        if dy1<1;
            dy1=1;
        end;
        if dy2>header.datasize(5);
            dy2=header.datasize(5);
        end;
        if operation_switch==1
            outdata(:,:,:,:,dy,:)=mean(data(:,:,:,:,dy1:dy2,:),5);
        else
            outdata(:,:,:,:,dy,:)=std(data(:,:,:,:,dy1:dy2,:),0,5);
        end;
    end;
end;
        
if dimension==3;
    for dz=1:header.datasize(4);
        dz1=dz-binwidth2;
        dz2=dz+binwidth2;
        if dz1<1;
            dz1=1;
        end;
        if dz2>header.datasize(4);
            dz2=header.datasize(4);
        end;
        if operation_switch==1
            outdata(:,:,:,dz,:,:)=mean(data(:,:,:,dz1:dz2,:,:),5);
        else
            outdata(:,:,:,dz,:,:)=std(data(:,:,:,dz1:dz2,:,:),0,5);
        end;
    end;
end;

%size(data)
outdata=reshape(outdata,size(data));
%size(outdata)
         
% 
% 
% %loop 
% for epochpos=1:header.datasize(1);
%     for chanpos=1:header.datasize(2);
%         for indexpos=1:header.datasize(3);
%             %X
%             if dimension==1;
%                 for dz=1:header.datasize(4);
%                     for dy=1:header.datasize(5);
%                         tp=squeeze(data(epochpos,chanpos,indexpos,dz,dy,:));
%                         tp2=tp;
%                         for dx=1:header.datasize(6);
%                             dx1=dx-binwidth2;
%                             dx2=dx+binwidth2;
%                             if dx1<1;
%                                 dx1=1;
%                             end;
%                             if dx2>header.datasize(6);
%                                 dx2=header.datasize(6);
%                             end;
%                             if operation_switch==1
%                                 tp2(dx)=mean(tp(dx1:dx2));
%                             else
%                                 tp2(dx)=std(tp(dx1:dx2));
%                             end;
%                                 
%                         end;
%                         outdata(epochpos,chanpos,indexpos,dz,dy,:)=tp2;
%                     end;
%                 end;
%             end;
%             %Y
%             if dimension==2;
%                 for dz=1:header.datasize(4);
%                     for dx=1:header.datasize(6);
%                         tp=squeeze(data(epochpos,chanpos,indexpos,dz,:,dx));
%                         tp2=tp;
%                         for dy=1:header.datasize(5);
%                             dy1=dy-binwidth2;
%                             dy2=dy+binwidth2;
%                             if dy1<1;
%                                 dy1=1;
%                             end;
%                             if dy2>header.datasize(5);
%                                 dy2=header.datasize(5);
%                             end;
%                             if operation_switch==1;
%                                 tp2(dy)=mean(tp(dy1:dy2));
%                             else
%                                 tp2(dy)=std(tp(dy1:dy2));
%                             end;
%                         end;
%                         outdata(epochpos,chanpos,indexpos,dz,:,dx)=tp2;
%                     end;
%                 end;
%             end;
%             %Z
%             if dimension==3;
%             end;
%             for dy=1:header.datasize(5);
%                 for dx=1:header.datasize(6);
%                     tp=squeeze(data(epochpos,chanpos,indexpos,:,dy,dx));
%                     tp2=tp;
%                     for dz=1:header.datasize(4);
%                         dz1=dz-binwidth2;
%                         dz2=dz+binwidth2;
%                         if dz1<1;
%                             dz1=1;
%                         end;
%                         if dz2>header.datasize(4);
%                             dz2=header.datasize(4);
%                         end;
%                         if operation_switch==1;
%                             tp2(dz)=mean(tp(dz1:dz2));
%                         else
%                             tp2(dz)=std(tp(dz1:dz2));
%                         end;
%                     end;
%                     outdata(epochpos,chanpos,indexpos,:,dy,dx)=tp2;
%                 end;
%             end;
%         end;
%     end;
% end;
        
end

