function [filter_header,filter_data]=LW_build_waveletfilter(header,data,channel_idx,f,threshold)

% LW_build_waveletfilter
% Generate waveletfilter model
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - channel_idx : channel indexes (e.g. [1])
% - f : frequency vector, in Hz (e.g. [1:1:30])
% - threshold : the threshold for wavelet filtering (e.g. [0.85])
%   [filter_header,filter_data]=LW_build_waveletfilter(header,data,channel_idx,f,threshold)
%
% Outputs
% - filter_header : LW5 header
% - filter_data : data to be filtered
%
% Dependencies : model_generation();
%
% Author : 
% Li Hu
% Southwest University
% Chongqing, China
%
% Modified by Andre Mouraux
% Institute of Neurosciences (IONS)
% Universite catholique de louvain (UCL)
% Belgium
% 
% Contact : hulitju@gmail.com; andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%

if (nargin < 5)
   help LW_build_waveletfilter
   return
end

%transfer header to filter_header
filter_header=header;

%add history
i=length(filter_header.history)+1;
filter_header.history(i).description='LW_build_waveletfilter';
filter_header.history(i).date=date;
%store channel(s) used to build the filter in index (AM)
filter_header.history(i).index=channel_idx;

% model generation
Fs=round(1/header.xstep);% sampling frequency

%modified by AM (no resampling of x, as this is implemented in a separate function)

%epoch_end (AM)
epoch_end=1:1:header.datasize(6);
epoch_end=((epoch_end-1)*header.xstep)+header.xstart;
    
    
for i=1:length(channel_idx)
    x_trials=squeeze(data(:,channel_idx(i),1,1,1,:))';
    [P_mask] = model_generation(x_trials,f,Fs,epoch_end,threshold); % definition of TF mask
    filter_data(1,i,1,1,:,:)=P_mask;
end;

%adjust filter_header using LW5 format (AM)
filter_header.datasize=size(filter_data);
filter_header.ystart=f(1);
filter_header.ystep=f(2)-f(1);

filter_header.filetype='frequency_time_value';

%adjust channels (AM)
filter_header.chanlocs=header.chanlocs(channel_idx);

%delete invalid fields if present
if isfield(filter_header,'events');
    filter_header=rmfield(filter_header,'events');
end;
if isfield(filter_header,'condition_labels');
    filter_header=rmfield(filter_header,'condition_labels');
end;
if isfield(filter_header,'conditions');
    filter_header=rmfield(filter_header,'conditions');
end;
