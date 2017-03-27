function [outheader,outdata] = LW_rereference(header,data,referencechannels,selectedchannels);
% LW_rereference
% Rereference signals
%
% Inputs
% - header : LW5 header
% - data LW5 data
% - referencechannels : array of channels used to compute the new reference
% - selectedchannels : array of channels onto which to apply the new reference
%
% Outputs
% - outheader : LW5 header
% - outdata : LW data
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
outheader.history(i).description='LW_rereference';
outheader.history(i).date=date;
outheader.history(i).index=[];

%transfer data
outdata=data;

%compute new reference
refdata=data(:,referencechannels,:,:,:,:);
refdata=mean(refdata,2);

%apply new reference
for channelpos=1:length(selectedchannels);
    outdata(:,selectedchannels(channelpos),:,:,:,:)=outdata(:,selectedchannels(channelpos),:,:,:,:)-refdata;
end;