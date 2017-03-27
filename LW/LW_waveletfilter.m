function [outheader,outdata] = LW_waveletfilter(header,data,channel_idx,x_idx,y_idx,threshold)
% LW_waveletfilter
% Perform wavelet filtering
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - channel_idx : channel indexes (e.g. [1])
% - x_idx : latency vector, in seconds (e.g. [-0.5:0.001:1])
% - y_idx : frequency vector, in Hz (e.g. [1:1:30])
% - threshold : the threshold for wavelet filtering (e.g. [0.85])
%   [outheader,outdata]=LW_waveletfilter(header,data,16,[-0.25:0.001:0.75],[1:1:30],0.85);
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : model_generation();tf_filtering();
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

if (nargin < 6)
   help LW_waveletfilter
   return
end

%transfer header to outheader
outheader=header;

%add history
i=size(outheader.history,2)+1;
outheader.history(i).description='LW_waveletfilter';
outheader.history(i).date=date;
% outheader.history(i).index=varargin;

% wavelet filtering
Fs=round(1/header.xstep);% sampling frequency
f=y_idx;% frequency resolution
epoch=header.xstart : header.xstep : (header.xstart+(size(data,6)-1)*header.xstep);% define the time vector of the original data
if header.xstep==x_idx(2)-x_idx(1);    
    epoch_idx=find(epoch >= x_idx(1) & epoch <= x_idx(end));
    epoch_end=epoch(epoch_idx);
    for i=1:length(channel_idx)
        x_trials=squeeze(data(:,channel_idx(i),1,1,1,epoch_idx))'; 
        [P_mask] = model_generation(x_trials,f,Fs,epoch_end,threshold); % definition of TF mask
        [f_trials] = tf_filtering(x_trials,f,Fs,P_mask);  % wavelet filtering
        f_data(:,channel_idx(i),1,1,1,:)=f_trials';
    end
else
    Fs_new=round(1/(x_idx(2)-x_idx(1)));
    header.xstep=x_idx(2)-x_idx(1);
    epoch_new = resample(epoch,Fs_new,Fs);
    epoch_idx=find(epoch_new >= x_idx(1) & epoch_new <= x_idx(end));
    epoch_end=epoch_new(epoch_idx);
    for i=1:length(channel_idx)
        temp=squeeze(data(:,channel_idx(i),1,1,1,:)); 
        for j=1:size(temp,1)
            x_data(j,:)=resample(temp(j,:),Fs_new,Fs);
        end
        x_trials=x_data(:,epoch_idx)'; 
        [P_mask] = model_generation(x_trials,f,Fs_new,epoch_end,threshold); % definition of TF mask
        [f_trials] = tf_filtering(x_trials,f,Fs_new,P_mask);  % wavelet filtering
        f_data(:,channel_idx(i),1,1,1,:)=f_trials';
    end
end

%remove conditions
if isfield(outheader,'conditions');
    rmfield(outheader,'conditions');
end;

%remove condition_labels
if isfield(outheader,'condition_labels');
    rmfield(outheader,'condition_labels');
end;

%remove epochdata
if isfield(outheader,'epochdata');
    rmfield(outheader,'epochdata');
end;

%remove dipfit
if isfield(outheader,'fieldtrip_dipfit');
    rmfield(outheader,'fieldtrip_dipfit');
end;


%outdata
outdata=f_data;