function [outheader,outdata] = LW_ttest(leftheader,leftdata,rightheader,rightdata,testtype,tail,alpha)
% LW_ttest
%
% Inputs
% - leftheader (LW5 header)
% - leftdata (LW5 data)
% - rightheader (LW5 header)
% - rightdata (LW5 data)
% - testtype : type of ttest : 'paired','nonpaired'
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
outheader=leftheader;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ttest';
outheader.history(i).date=date;
outheader.history(i).index=[testtype,tail,alpha];

%prepare outdata
outheader.datasize(1)=1; %epochsize=1
outheader.datasize(3)=3; %indexsize=3
outdata=zeros(outheader.datasize);

%loop
indexpos=1; %indexpos must be 1
for chanpos=1:outheader.datasize(2);
    for dz=1:outheader.datasize(4);
        for dy=1:outheader.datasize(5);
            tpleft=squeeze(leftdata(:,chanpos,indexpos,dz,dy,:));
            tpright=squeeze(rightdata(:,chanpos,indexpos,dz,dy,:));
            if strcmpi(testtype,'paired');
                [H,P,CI,STATS]=ttest(tpleft,tpright,alpha,tail);
            else
                [H,P,CI,STATS]=ttest2(tpleft,tpright,alpha,tail);
            end;
            outdata(1,chanpos,1,dz,dy,:)=P;
            outdata(1,chanpos,2,dz,dy,:)=H;
            outdata(1,chanpos,3,dz,dy,:)=STATS.tstat;
        end;
    end;
end;

%set index labels
outheader.indexlabels{1}='p-value';
outheader.indexlabels{2}='H';
outheader.indexlabels{3}='test statistic';


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