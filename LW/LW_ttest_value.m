function [outheader,outdata] = LW_ttest_value(header,data,value,tail,alpha)
% LW_ttest
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - tail : 'both','right','left'
% - alpha : alpha level
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data) : index(1)='p-value', index(2)='H'
%
% Dependencies : none.
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
outheader.history(i).description='LW_ttest_value';
outheader.history(i).date=date;
outheader.history(i).index=[value,tail,alpha];

%prepare outdata
outheader.datasize(1)=1; %epochsize=1
outheader.datasize(3)=2; %indexsize=2
outdata=zeros(outheader.datasize);

%loop
indexpos=1; %indexpos must be 1
for chanpos=1:outheader.datasize(2);
    for dz=1:outheader.datasize(4);
        for dy=1:outheader.datasize(5);
            tpleft=squeeze(data(:,chanpos,indexpos,dz,dy,:));
            [outdata(1,chanpos,2,dz,dy,:) outdata(1,chanpos,1,dz,dy,:)]=ttest(tpleft,value,alpha,tail);
        end;
    end;
end;

%set index labels
outheader.indexlabels{1}='p-value';
outheader.indexlabels{2}='H';


%parse events
if isfield(outheader,'events');
    for eventpos=1:length(outheader.events);
        outheader.events(eventpos).epoch=1;
    end;
end;

%delete conditions if present
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'conditions');
    outheader=rmfield(outheader,'condition_labels');
end;