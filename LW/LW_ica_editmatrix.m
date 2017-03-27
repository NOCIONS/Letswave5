function [outheader,outdata] = LW_ica_editmatrix(header,data,selectedICs);
% LW_ICA_mix
% ICA mix
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - selecedICs : ICs to remove from unmixing matrix
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

%transfer
outheader=header;
outdata=data;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ica_editmatrix';
outheader.history(i).date=date;
outheader.history(i).index=selectedICs;

%mixing : index=2
mm=squeeze(data(1,:,2,1,1,:));


%ICs are stored as x
%Channels are stored as channels
%Remove IC = set to 0 the corresponding x position

%ICmask
removeICs=1:1:size(mm,2);
removeICs(selectedICs)=[];
mm(:,removeICs)=0;

%update outdata
outdata(1,:,2,1,1,:)=mm;

    
end

