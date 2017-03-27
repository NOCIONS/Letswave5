function [outheader,outdata] = LW_apply_waveletfilter(header,data,filter_header,filter_data,channel_idx,include_original)
% LW_apply_waveletfilter
% Perform wavelet filtering
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - filter_header : LW5 header
% - filter_data : LW5 data
% - channel_idx : channel indexes (e.g. [1]) (should be the same as used to build the wavelet filter)
% - include_original = 0 only save the filtered data 
% - include_original = 1 also save the original data in an additional index
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : tf_filtering();
%
% Author : 
% Li Hu
% Southwest University
% Chongqing, China
%
% Modified by : 
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
    help LW_apply_waveletfilter
    return
end

%transfer header to outheader
outheader=header;

%adjust outheader
%adjust number of channels
outheader.datasize(2)=length(channel_idx);
%adjust channels
outheader.chanlocs=outheader.chanlocs(channel_idx);

%add history
i=length(outheader.history)+1;
st='LW_apply_waveletfilter';
outheader.history(i).description=st;
outheader.history(i).date=date;
outheader.history(i).index=channel_idx;

%f, Fs
filter_header.ystart;
f=1:1:filter_header.datasize(5);
f=((f-1)*filter_header.ystep)+filter_header.ystart;

Fs=round(1/header.xstep);% sampling frequency

if include_original==1;
    outheader.datasize(3)=2;
    outheader.indexlabels{1}='filtered';
    outheader.indexlabels{2}='original';
else
    outheader.datasize(3)=1;
    outheader.indexlabels{1}='filtered';
end;

%prepare outdata
outdata=zeros(outheader.datasize);

% wavelet filtering
for i=1:length(channel_idx);
    x_trials=squeeze(data(:,channel_idx(i),1,1,1,:))';
    P_mask=squeeze(filter_data(1,i,1,1,:,:));
    [f_trials] = tf_filtering(x_trials,f,Fs,P_mask);
    outdata(:,i,1,1,1,:)=f_trials';
    if include_original==1;
        outdata(:,i,2,1,1,:)=x_trials';
    end;
end