function [outheader,outdata] = LW_equalize(header,data,numepochs,optionstring)
% LW_averageepochs
% Average epochs
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - numepochs
% - optionstring : 'random' 'sequential_first' 'sequential_last'
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



%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_equalize';
outheader.history(i).date=date;
outheader.history(i).index=optionstring;

%change number of epochs
outheader.datasize(1)=numepochs;

%select epochs
if strcmpi(optionstring,'random');
    tp=randperm(header.datasize(1));
    selected_epochs=tp(1:numepochs);
end;
if strcmpi(optionstring,'sequential_first')
    selected_epochs=1:1:numepochs;
end;
if strcmpi(optionstring,'sequential_last')
    tp=1:1:numepochs;
    selected_epochs=((header.datasize(1))-tp)+1;
end;

%data
outdata=data(selected_epochs,:,:,:,:,:);

%adjust events
if isfield(outheader,'events');
    outheader.events=header.events(selected_epochs);
end;

%adjust conditions
if isfield(outheader,'conditions');
    if length(header.conditions)>=max(selected_epochs);
        outheader.conditions=header.conditions(selected_epochs,:);
    else
        disp('There must be a problem with Conditions. Conditions will be deleted');
        rmfield(outheader,'conditions');
        rmfield(outheader,'condition_labels');
    end;
end;

%delete dipfit
if isfield(outheader,'fieldtrip_dipfit');
    rmfield(outheader,'fieldtrip_dipfit');
end;

%adjust epochdata
if isfield(outheader,'epochdata');
    outheader.epochdata=header.epochdata(selected_epochs);
end;
        
        
end

