function [outheader,outdata] = LW_downsample(header,data,dsratiox,dsratioy,dsratioz)
% LW_downsample
% Downsample signals (ratio) along X/Y/Z dimensions
% New samplingrate will be samplingrate/dsratio
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - dsratiox : downsampling ratio for X axis (no downsampling dsratio=0)
% - dsratioy : downsampling ratio for Y axis (no downsampling dsratio=0)
% - dsratioz : downsampling ratio for Z axis (no downsampling dsratio=0)
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
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
outheader.history(i).description='LW_downsample';
outheader.history(i).date=date;
outheader.history(i).index=[dsratiox,dsratioy,dsratioz];

%adjust xstep,ystep,zstep
outheader.xstep=header.xstep*dsratiox;
outheader.ystep=header.ystep*dsratioy;
outheader.zstep=header.zstep*dsratioz;

%adjust xsize,ysize,zsize
outheader.datasize=header.datasize;
outheader.datasize(4)=ceil(double(header.datasize(4))/dsratioz);
outheader.datasize(5)=ceil(double(header.datasize(5))/dsratioy);
outheader.datasize(6)=ceil(double(header.datasize(6))/dsratiox);

%set xvector,yvector,zvector
zvector=1:dsratioz:header.datasize(4);
yvector=1:dsratioy:header.datasize(5);
xvector=1:dsratiox:header.datasize(6);

%prepare outdata
outdata=zeros(outheader.datasize);

%update data
outdata(:,:,:,:,:,:)=data(:,:,:,zvector,yvector,uint32(xvector));
%outdata(:,:,:,:,:,:)=data(:,:,:,zvector,yvector,xvector);
