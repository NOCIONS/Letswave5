function [outheader,outdata] = LW_selectsignals(header,data,selectedepochs,selectedchannels,selectedindexes);
% LW_selectsignals
% Select signals
%
% Inputs
% - header : LW5 header
% - data LW5 data
% - selected epochs : array of selected epoch indices
% - selected channels : array of selected channel indices
% - selected indices : array of selected index indices
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
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_selectsignals';
outheader.history(i).date=date;
outheader.history(i).index=[selectedepochs,selectedchannels,selectedindexes];

%update data
outdata(:,:,:,:,:,:)=data(selectedepochs,selectedchannels,selectedindexes,:,:,:);

%update datasize
outheader.datasize=size(outdata);

%updage chanlocs
outheader = rmfield(outheader,'chanlocs');
for i=1:length(selectedchannels);
    outheader.chanlocs(i)=header.chanlocs(selectedchannels(i));
end;

%update indexlabels (if isfield)
if isfield(outheader,'indexlabels')==0;
else
    outheader.indexlabels(:)=header.indexlabels(selectedindexes);
end;

%update events
eventpos2=1;
if isfield(outheader,'events');
    if isempty(outheader.events);
    else
        for eventpos=1:length(header.events);
            f=find(selectedepochs==header.events(eventpos).epoch);
            if isempty(f);
            else
                newevents(eventpos2)=header.events(eventpos);
                newevents(eventpos2).epoch=f;
                eventpos2=eventpos2+1;
            end;
        end;
    end;
    if eventpos2==1;
        outheader.events=[];
    else
        outheader.events=newevents;
    end;
end;


%update conditions
%conditions(epochpos,condition) : a matrix of condition values
if isfield(outheader,'conditions');
    conditions=header.conditions(selectedepochs,:);
    outheader.conditions=conditions;
end;

%update epochdata
if isfield(outheader,'epochdata');
    epochdata=header.epochdata(selectedepochs);
    outheader.epochdata=epochdata;
end;


%delete fieldtrip_dipfit.dipoles if present
if isfield(outheader,'fieldtrip_dipfit');
    if isfield(outheader.fieldtrip_dipfit,'dipole');
        outheader.fieldtrip_dipfit=rmfield(outheader.fieldtrip_dipfit,'dipole');
    end;
end;

