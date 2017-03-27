function [outheader,outdata] = LW_ERPimage(header,data,epochindex,epochvalue,hanningwidth,ysize,ystart,yend)
% LW_ERPimage
% ERPimage
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - epochindex
% - epochvalue
% - hanningwidth
% - ysize
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
%
% Author : 
% Andre Mouraux
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

%hanning function
tp=hanning(hanningwidth);
for dx=1:size(data,6);
    han(:,dx)=tp;
end;

%check Ydim
if size(data,5)>1;
    disp('Warning : the ERPimage will be computed using only the first bin of the Y dimension');
end;    

%fetch epochs
if epochindex==0;
    data(:,:,:,:,:,:)=data(:,:,:,:,1,:);
else
    data(:,:,:,:,:,:)=data(epochindex,:,:,:,1,:);
end;

%sort epochs according to epochvalue
if epochvalue==0;
    disp('No epoch values were defined, epochs will be sorted according to trial order');
else
    [epochvalue,epochvaluei]=sort(epochvalue);
    data(:,:,:,:,:,:)=data(epochvaluei,:,:,:,:,:);
end;

%check hanningwidth
if hanningwidth>1;
    disp('Hanning smoothing will be applied');
    hanningwidth2=floor(hanningwidth/2);
    hanningwidth=(2*hanningwidth2)+1;
    disp(['Hanning window size : ' num2str(hanningwidth)]);
else
    disp('No Hanning smoothing is requested');
end;

%figure out outheader.datasize
outheader.datasize(1)=1;
if ysize>1;
    disp(['Rescaling will be applied. Number of lines : ' num2str(ysize)]);
    xq=1:1:header.datasize(6);
    if epochvalue==0;
        outheader.ystart=1;
        yq=linspace(1,header.datasize(1),ysize);
        outheader.ystep=yq(2)-yq(1);
    else
        if ystart==yend;
            outheader.ystart=min(epochvalue);            
            yq=linspace(min(epochvalue),max(epochvalue),ysize);
            outheader.ystep=yq(2)-yq(1);
        else
            outheader.ystart=ystart;
            yq=linspace(ystart,yend,ysize);
            outheader.ystep=yq(2)-yq(1);
        end;        
    end;
    outheader.datasize(5)=ysize;    
else
    disp(['No rescaling will be applied. Number of lines : ' num2str(length(epochindex))]);
    outheader.ystart=1;
    outheader.ystep=1;
    outheader.datasize(5)=length(epochindex);
end;

%disp
disp(['YStart : ' num2str(outheader.ystart)]);
disp(['YStep : ' num2str(outheader.ystep)]);
disp(['YSize : ' num2str(outheader.datasize(5))]);

%change data type
outheader.filetype='time_epochs';

%prepare outdata
outdata=zeros(outheader.datasize);


%loop through channels
for chanpos=1:size(data,2);
    disp(['Computing Channel : ' header.chanlocs(chanpos).labels]);
    %loop through index
    for indexpos=1:size(data,3);
        %loop through Z
        for zpos=1:size(data,4);
            %fetch data
            or_data=squeeze(data(:,chanpos,indexpos,zpos,1,:));
            han_data=or_data;
            %check if hanning smoothing should be applied
            if hanningwidth>1
                %loop through epochs
                for dy=1:size(or_data,1);
                    dy1=dy-hanningwidth2;
                    dy2=dy+hanningwidth2;
                    if dy1<1;
                        dy1=1;
                    end;
                    if dy2>size(or_data,1);
                        dy2=size(or_data,1);
                    end;
                    hdy1=dy1-dy+(hanningwidth2+1);
                    hdy2=dy2-dy+(hanningwidth2+1);
                    han_data(dy,:)=squeeze(mean(or_data(dy1:dy2,:).*han(hdy1:hdy2,:),1));
                end;
            end;
            %rescale if needed
            if ysize>1;
                rs_han_data=griddata(xq,epochvalue,han_data,xq,yq','cubic');
            end;
            outdata(1,chanpos,indexpos,zpos,:,:)=rs_han_data;
        end;
    end;
end;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ERPimage';
outheader.history(i).date=date;
outheader.history(i).index=[];

%adjust events
if isfield(outheader,'events');
    for i=1:size(outheader.events,2);
        outheader.events(i).epoch=1;
    end;
end;

%delete conditions if present
if isfield(outheader,'conditions');
    rmfield(outheader,'conditions');
end;

%delete dipfit
if isfield(outheader,'fieldtrip_dipfit');
    rmfield(outheader,'fieldtrip_dipfit');
end;

%delete epochdata
if isfield(outheader,'epochdata');
    rmfield(outheader,'epochdata');
end;
        
        
end

