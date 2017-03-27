function [outheader,outdata] = LW_averageepochs(header,data,operation,varargin)
% LW_averageepochs
% Average epochs
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - operation : average, stdev, median
% - varargin : weightvector
%   Unweighted averaging : 
%   [outheader,outdata]=LW_averageepochs(header,data);
%   Weighted averaging :
%   [outheader,outdata]=LW_averageepochs(header,data,weightvector);
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%


%determine the weight vector, use ones if not weighted averaging
tp=size(varargin,2);
if (tp>0);
    weight=varargin{1};
else
    weight=ones(size(data,1),1);
end;

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_averageepochs';
outheader.history(i).date=date;
outheader.history(i).index=varargin;

%change number of epochs
outheader.datasize(1)=1;

if strcmpi(operation,'average');
    disp('Operation : average');
    %weight
    for epochpos=1:size(data,1);
        data(epochpos,:,:,:,:,:)=weight(epochpos)*data(epochpos,:,:,:,:,:);
    end;
    %average
    outdata=sum(data,1)/sum(weight);
end;

if strcmpi(operation,'stdev');
    disp('Operation : stdev');
    outdata=zeros(outheader.datasize);
    outdata(1,:,:,:,:,:)=std(data,0,1);
end;

if strcmpi(operation,'median');
    disp('Operation : median');
    outdata=zeros(outheader.datasize);
    outdata(1,:,:,:,:,:)=median(data,1);
end;

%adjust events
if isfield(outheader,'events');
    for i=1:size(outheader.events,2);
        outheader.events(i).epoch=1;
    end;
end;

%adjust conditions
if isfield(outheader,'conditions');
    conditions=outheader.conditions;
    disp('Also averaging conditions across epochs');
    if size(varargin,2)>0;
        disp('WARNING : Applying weights to condition values');
        
    end;
    for conditionpos=1:size(conditions,2);
        conditions(:,conditionpos)=conditions(:,conditionpos)+weight;
    end;
    conditions=squeeze(sum(conditions,1)/sum(weight));
    outheader.conditions=conditions;
end;

%delete dipfit
if isfield(outheader,'fieldtrip_dipfit');
    rmfield(outheader,'fieldtrip_dipfit');
end;

%delete epochdata
if isfield(outheader,'epochdata');
    rmfield(outheader,'epochdata');
end;
        
        
end

