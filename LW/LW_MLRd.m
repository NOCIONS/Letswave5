function [ST] = LW_MLRd(header,data,channel_idx,time_interval,num_peak,peak_interval,direction)
% LW_MLRd
% Perform single trial analysis using multiple linear regression with
% dispersion term
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - channel_idx : channel index (e.g. [1]); only 1 channel is allowed.
% - time_interval : the time intervals to be analyzed, in seconds (e.g. [0 0.5])
% - num_peak : number of peak (e.g. 2)
% - peak_interval : the time intervals of all peaks, in seconds (e.g. [0.15 0.25; 0.25 0.35])
% - direction : positive or negative (e.g. {'negative','positive'})
% - [ST] = LW_MLRd(header,data,16,[0 0.5],2,[0.05 0.15;0.15 0.25],{'negative','positive'});
%
% Outputs
% - ST : structure with complete result of MLR : 
%   - interval : 
%   - peak_interval : 
%   - peak : 
%   - epoch : 
%   - t_idx : 
%   - regressor : 
%   - Coeffs : 
%   - amplitude : 
%   - latency :
%
% Dependencies :
% extreme_point();MLR_regressors();peak_measure()
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
   help LW_MLR
   return
end

% peak definition
ST.interval=time_interval;
ST.peak_interval=peak_interval;
epoch=header.xstart : header.xstep : (header.xstart+(size(data,6)-1)*header.xstep);% define the time vector of the original data
t_idx=find(epoch>=ST.interval(1) & epoch<=ST.interval(2));

signal=squeeze(data(:,channel_idx,1,1,1,:));
avg=mean(signal,1);
[tmax tmin vmax vmin]=extreme_point(avg);
for i=1:num_peak
    if strcmp(direction{i},'positive')
        peak_time=epoch(tmax);
        peak_time_c=peak_time(find(peak_time>=peak_interval(i,1) & peak_time<=peak_interval(i,2)));
        if isempty(peak_time_c)
            disp('no positive peak in the pre-defined time interval');return;
        else
            for j=1:length(peak_time_c)
                peak_time_idx(j)=find(epoch==peak_time_c(j));
            end
            Vmax=max(avg(peak_time_idx));
            Tmax=epoch(find(avg==Vmax));
        end
        ST.peak(i,:)=[Tmax Vmax];
    elseif strcmp(direction{i},'negative')
        peak_time=epoch(tmin);
        peak_time_c=peak_time(find(peak_time>=peak_interval(i,1) & peak_time<=peak_interval(i,2)));
        if isempty(peak_time_c)
            disp('no negative peak in the pre-defined time interval');return;
        else
            for j=1:length(peak_time_c)
                peak_time_idx(j)=find(epoch==peak_time_c(j));
            end            
            Vmin=min(avg(peak_time_idx));
            Tmin=epoch(find(avg==Vmin));
        end
        ST.peak(i,:)=[Tmin Vmin];
    end
end

ST.epoch=epoch;
ST.t_idx=t_idx;
ST.channel_idx=channel_idx;

Fs=round(1/header.xstep);
[ST] = MLRd_regressors(avg,ST,Fs);
[ST] = peak_measure(signal,ST,Fs);