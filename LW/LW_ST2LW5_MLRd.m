function [out_header,out_data,regressor_header,regressor_data] = LW_ST2LW5_MLRd(header,data,ST)
% LW_ST2LW5
% Transfer the output of MLR function (ST) to LW5 data
%
% Inputs
% - header : LW5 header of the dataset onto which the MLR was applied
% - data : LW5 data of the dataset onto which the MLR was applied
% - ST : the output of the MLR function
%
% Outputs
% - out_header
% - out_data
% - regressor_header
% - regressor_data
%
% Dependencies :
% none
%
% Author :
% Andre Mouraux
% Institute of Neurosciences (IONS)
% Universite catholique de louvain (UCL)
% Belgium
%
% Contact : hulitju@gmail.com; andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%
% ST structure :
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

%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;

%regressor header
regressor_header=header;
regressor_header.datasize=[1 1 1+(length(ST.regressor)*2) 1 1 length(ST.t_idx)];
regressor_header.xstart=tpx(ST.t_idx(1));
regressor_header.xstep=tpx(ST.t_idx(2))-tpx(ST.t_idx(1));
regressor_header.chanlocs=regressor_header.chanlocs(ST.channel_idx);

%delete invalid optional fields
if isfield(regressor_header,'events');
    regressor_header.events=[];
end;
if isfield(regressor_header,'conditions');
    regressor_header=rmfield(regressor_header,'conditions');
end;
if isfield(regressor_header,'condition_labels');
    regressor_header=rmfield(regressor_header,'condition_labels');
end;

%index labels
regressor_header.indexlabels{1}='original';
for i=1:length(ST.regressor);
    regressor_header.indexlabels{i*2}=['peak' num2str(i) '_1'];
    regressor_header.indexlabels{(i*2)+1}=['peak' num2str(i) '_2'];
end;

%add history
i=size(regressor_header.history,2)+1;
regressor_header.history(i).description='LW_ST2LW5_MLRd';
regressor_header.history(i).date=date;
regressor_header.history(i).index='regressors';

%regressor data
regressor_data=zeros(regressor_header.datasize);
regressor_data(1,1,1,1,1,:)=mean(data(:,ST.channel_idx,1,1,1,ST.t_idx),1);
for i=1:length(ST.regressor);
    regressor_data(1,1,i*3,1,1,:)=ST.regressor{i}(:,1);
    regressor_data(1,1,(i*3)+1,1,1,:)=ST.regressor{i}(:,2);
    regressor_data(1,1,(i*3)+2,1,1,:)=ST.regressor{i}(:,3);    
end;

%out_header
out_header=header;
out_data=data;

%add conditions with ST latency and amplitude values

%condition_labels
if isfield(out_header,'condition_labels');
    j=length(out_header.condition_labels)+1;
else
    j=1;
end;
for i=1:length(ST.regressor);
    out_header.condition_labels{j+((i-1)*2)}=['latency' num2str(i)];
    out_header.condition_labels{1+j+((i-1)*2)}=['amplitude' num2str(i)];
end;

%conditions (data)
if isfield(out_header,'conditions');
    j=size(out_header.conditions,2)+1;
else
    j=1;
end;
for i=1:length(ST.regressor);
    out_header.conditions(:,j+((i-1)*2))=ST.latency(:,i);
    out_header.conditions(:,1+j+((i-1)*2))=ST.amplitude(:,i);
end;

