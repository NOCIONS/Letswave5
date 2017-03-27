function [outheader,outdata] = LW_interpolate_channels(header,data,badchan,interpchans)
%LW_averagechannels
% Average (pool) channels
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - badchan index
% - interpchans index
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
outheader.history(i).description='LW_interpolate_channels';
outheader.history(i).date=date;
outheader.history(i).index=[badchan,interpchans];

%transfer data to outdata
outdata=data;

%average
outdata(:,badchan,:,:,:,:)=mean(data(:,interpchans,:,:,:,:),2);

end

