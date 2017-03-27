function [outheader,outdata] = LW_merge_channels(header1,data1,header2,data2);
% LW_merge_channels
% Merge channels
%
% Inputs
% - header1 : LW5 header
% - header2 : LW5 header
% - data1 : LW5 data
% - data2 : LW5 data
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
outheader=header1;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_merge_channels';
outheader.history(i).date=date;
outheader.history(i).index=[];

%update data
outdata=cat(2,data1,data2);

%update datasize
outheader.datasize=size(outdata);

%update chanlocs
fn1=fieldnames(header1.chanlocs);
fn2=fieldnames(header2.chanlocs);
fn=[fn1; fn2];
ufn=unique(fn);
tploc=[];
for i=1:length(ufn);
    tploc.(ufn{i})=[];
end;
outheader.chanlocs=tploc;
for i=1:length(header1.chanlocs);
    for j=1:length(fn1);
        tploc.(fn1{j})=header1.chanlocs(i).(fn1{j});
        outheader.chanlocs(i)=tploc;
    end;
end;
tpi=length(header1.chanlocs);
for i=1:length(header2.chanlocs);
    for j=1:length(fn2);
        tploc.(fn2{j})=header2.chanlocs(i).(fn2{j});
        outheader.chanlocs(i+tpi)=tploc;
    end;
end;

%update events

if isfield(header2,'events');
    if isfield (header1,'events');
        outheader.events=cat(2,header1.events,header2.events);
    else
        outheader.events=header2.events;
    end;
end;

%update conditions
if isfield(header2,'conditions');
    if isfield(header1,'conditions');
        outheader.conditions=cat(2,header1.conditions,header2.conditions);
        outheader.condition_labels=[header1.condition_labels,header2.condition_labels]
    else
        outheader.conditions=header2.conditions;
        outheader.condition_labels=header2.condition_labels;
    end;
end;