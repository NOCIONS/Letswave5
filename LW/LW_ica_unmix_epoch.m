function [outheader,outdata] = LW_ica_unmix_epoch(header,data,matrixheader,matrixdata,epochpos);
% LW_ICA_unmix
% ICA unmix
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - matrixheader : LW5 header
% - matrixdata : LW5 data
% - epochpos : epoch to filter
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

%unmixing : index=1
um=squeeze(matrixdata(1,:,1,1,1,:));

%outheader
outheader=header;
outheader.datasize(2)=matrixheader.datasize(6);
outheader.datasize(1)=1;

%chanlocs
outheader.chanlocs=[];
for i=1:outheader.datasize(2);
    outheader.chanlocs(i).labels=['IC',num2str(i)];
    outheader.chanlocs(i).topo_enabled=0;
end;

%prepare outdata
outdata=zeros(outheader.datasize);

%activations = weights*sphere*(input_data);
tp=um'*(squeeze(data(epochpos,:,1,1,1,:)));
outdata(1,:,1,1,1,:)=tp;
    
end

