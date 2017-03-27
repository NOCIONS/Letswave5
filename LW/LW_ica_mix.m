function [outheader,outdata] = LW_ica_mix(header,data,matrixheader,matrixdata);
% LW_ICA_mix
% ICA mix
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - matrixheader : LW5 header
% - matrixdata : LW5 data
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

%mixing : index=2
mm=squeeze(matrixdata(1,:,2,1,1,:));

%outheader
outheader=header;
outheader.datasize(2)=matrixheader.datasize(2);

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ica_mix';
outheader.history(i).date=date;
outheader.history(i).index=[];

%chanlocs
outheader.chanlocs=matrixheader.chanlocs;

%prepare outdata
outdata=zeros(outheader.datasize);

%mixed signals = mm*(input_data);
for epochpos=1:header.datasize(1);
    tp=squeeze(data(epochpos,:,1,1,1,:));
    outdata(epochpos,:,1,1,1,:)=mm*tp;
end;
    
end

