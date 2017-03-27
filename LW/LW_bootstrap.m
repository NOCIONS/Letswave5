function [outheader,outdata] = LW_bootstrap(header,data,channel_idx,baseline_interval,N_Bootstrap)
% LW_bootstrap
% Perform bootstrap test for time-frequency distribution to extract the
% signicant regions in the post-stimulus interval compared to the pre-stimulus interval
% Inputs
% - header : LW5 header
% - data : LW5 data
% - channel_idx : channel index (e.g. [1]); all channels can be selected at
% the same time, but it will be very slow
% - baseline_interval : the time intervals of the baseline, in seconds (e.g. [-0.4 -0.1])
% - N_Bootstrap : number of bootstraping (e.g. 1000)
% - [outheader,outdata] = LW_bootstrap(header,data,[1],[-0.4 -0.1],1000)
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data (bootstrap results)
%
% Dependencies :
% sub_tfd_bootstrp();
%
% Author : 
% Li Hu
% Southwest University
% Chongqing, China

% Andre Mouraux
% Institute of Neurosciences (IONS)
% Universite catholique de louvain (UCL)
% Belgium
% 
% Contact : hulitju@gmail.com; andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%

if (nargin < 5)
   help LW_bootstrap
   return
end

%transfer header to outheader
outheader=header;

%add history
i=size(outheader.history,2)+1;
outheader.history(i).description='LW_bootstrap';
outheader.history(i).date=date;
outheader.history(i).index=[channel_idx baseline_interval N_Bootstrap];

%define the time vector of the original data
t=header.xstart : header.xstep : (header.xstart+(size(data,6)-1)*header.xstep);
% define the frequency vector of the original data
f=header.ystart : header.ystep : (header.ystart+(size(data,5)-1)*header.ystep);
% baseline index, unit: sec
t_base_idx = find((t>=baseline_interval(1)) & (t<=baseline_interval(2))); 

%bootstrap
for i=1:length(channel_idx)
    for j=1:size(data,1)
        tp(:,:,j)=squeeze(data(j,channel_idx(i),1,1,:,:));% freq*time*epoch;
    end;
    if size(data,5)>1;
        data_to_test=tp;
    else
        data_to_test(1,:,:)=tp;
    end;
    [ pvals_btstrp(i,:,:),pvals_btstrp_r(i,:,:),pvals_btstrp_l(i,:,:) ] = sub_tfd_bootstrp(data_to_test(:,t_base_idx,:), data_to_test, N_Bootstrap);
end;

%pvals_btstrp(chan,freq,time)
%outdata
if size(data,5)>1;
    for chanpos=1:length(channel_idx);
        outdata(1,chanpos,1,1,:,:)=pvals_btstrp(chanpos,:,:);
    end;
else
    for chanpos=1:length(channel_idx);
        outdata(1,chanpos,1,1,1,:)=pvals_btstrp(chanpos,:);
    end;
end;



%adjust outheader.datasize
outheader.datasize=size(outdata);
%adjust outheader.chanlocs
outheader.chanlocs=outheader.chanlocs(channel_idx);
%delete events if present
if isfield(outheader,'events');
    outheader.events=[];
end;
%delete outheader.conditions if present
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'conditions');
end;