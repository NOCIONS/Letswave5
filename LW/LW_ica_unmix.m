function [outheader,outdata] = LW_ica_unmix(header,data,matrixheader,matrixdata);
% LW_ICA_unmix
% ICA unmix
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

%unmixing : index=1
um=squeeze(matrixdata(1,:,1,1,1,:));

%outheader
outheader=header;
outheader.datasize(2)=matrixheader.datasize(6);

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ica_unmix';
outheader.history(i).date=date;
outheader.history(i).index=[];

%chanlocs
outheader.chanlocs=[];
for i=1:outheader.datasize(2);
    outheader.chanlocs(i).labels=['IC',num2str(i)];
    outheader.chanlocs(i).topo_enabled=0;
end;

%prepare outdata
outdata=zeros(outheader.datasize);

%activations = weights*sphere*(input_data);
for epochpos=1:header.datasize(1);
    outdata(epochpos,:,1,1,1,:)=um'*(squeeze(data(epochpos,:,1,1,1,:)));
end;
    
end

