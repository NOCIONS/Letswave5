function [outheader,outdata] = LW_merge_epochs(header1,data1,header2,data2);
% LW_merge_epochs
% Merge epochs
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
outheader=header1;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_merge_epochs';
outheader.history(i).date=date;
outheader.history(i).index=[];

%update data
outdata=cat(1,data1,data2);

%update datasize
outheader.datasize=size(outdata);

%update events
if isfield(header2,'events');
    epochtranslate=header1.datasize(1);
    for eventpos=1:length(header2.events);
        header2.events(eventpos).epoch=header2.events(eventpos).epoch+epochtranslate;
    end;
    outheader.events=cat(2,header1.events,header2.events);
end;

%update conditions
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'condition_labels');
    outheader=rmfield(outheader,'conditions');
end;
if isfield(header2,'conditions');
    if isfield(header1,'conditions');
        if strcmpi(header1.condition_labels,header2.condition_labels);
            disp('Matching conditions found, these will be transfered to the merged dataset.');
            outheader.conditions=vertcat(header1.conditions,header2.conditions);
            outheader.condition_labels=header1.condition_labels;
        end;
    end;
end;

%update epochdata
if isfield(outheader,'epochdata');
    rmfield(outheader,'epochdata');
end;
if isfield(header1,'epochdata');
    if isfield(header2,'epochdata');
        disp('Matching epochdata found. This will be transfered to the merged dataset.');
        outheader.epochdata=[header1.epochdata header2.epochdata];
    end;
end;

%update dipfit
if isfield(header2,'fieldtrip_dipfit');
    if isfield(header2.fieldtrip_dipfit,'dipole');
        for i=1:length(header2.fieldtrip_dipfit.dipole);
            header2.fieldtrip_dipfit.dipole(dipolepos).epochpos=header2.fieldtrip_dipfit.dipole(dipolepos).epochpos+header1.datasize(1);
        end;
    end;
end;
dipfit1_chk=0;
dipfit2_chk=0;
if isfield(header1,'fieldtrip_dipfit');
    if isfield(header1.fieldtrip_dipfit,'dipole');
        dipfit1_chk=1;
    end;
end;
if isfield(header2,'fieldtrip_dipfit');
    if isfield(header2.fieldtrip_dipfit,'dipole');
        dipfit2_chk=1;
    end;
end;
if dipfit1_chk==1;
    if dipfit2_chk==1;
        outheader.fieldtrip_dipfit.dipoles=[header1.fieldtrip_dipfit.dipoles header2.fieldtrip_dipfit.dipoles];
    end;
end;
if dipfit1_chk==1;
    if dipfit2_chk==0;
        outheader.fieldtrip_dipfit.dipoles=header1.fieldtrip_dipfit.dipoles;
    end;
end;
if dipfit1_chk==0;
    if dipfit2_chk==1;
        outheader.fieldtrip_dipfit.dipoles=header2.fieldtrip_dipfit.dipoles;
    end;
end;
