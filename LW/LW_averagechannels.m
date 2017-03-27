function [outheader,outdata] = LW_averagechannels(header,data,varargin)
%LW_averagechannels
% Average (pool) channels
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - varargin : weightvector
%   unmasked averaging (average all channels):
%   [outheader,outdata]=LW_averageepochs(header,data);
%   masked averaging selection of channels):
%   [outheader,outdata]=LW_averagechannels(header,data,maskvector);
%   select which channels to average using the maskvector 
%   where 0=unselected and 1=selected
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


%determine the weight vector, use ones if not weighted averaging
tp=length(varargin);
if (tp>0);
    weight=varargin{1};
else
    weight=ones(size(data,2),1);
end;

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_averagechannels';
outheader.history(i).date=date;
outheader.history(i).index=varargin;

%change number of channels
outheader.datasize(2)=1;

%change chanlocs
chanlocs(1).labels='avgchan';
chanlocs(1).topo_enabled=0;
chanlocs(1).theta=0;
chanlocs(1).radius=0;
chanlocs(1).sph_theta=0;
chanlocs(1).sph_phi=0;
chanlocs(1).sph_theta_besa=0;
chanlocs(1).sph_phi_besa=0;
chanlocs(1).X=0;
chanlocs(1).Y=0;
chanlocs(1).Z=0;
outheader.chanlocs=chanlocs;

%change splinefile association
outheader.filename_spl='';

%weight
for channelpos=1:size(data,2);
    data(:,channelpos,:,:,:,:)=weight(channelpos)*data(:,channelpos,:,:,:,:);
end;

%average
outdata=sum(data,2)/sum(weight);

end

