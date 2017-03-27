function [outheader,outdata] = LW_wilcoxon(leftheader,leftdata,rightheader,rightdata,testtype,alpha)
% LW_wilcoxon
%
% Inputs
% - leftheader (LW5 header)
% - leftdata (LW5 data)
% - rightheader (LW5 header)
% - rightdata (LW5 data)
% - testtype : type of test : 'signedrank','signed','rank'
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
outheader.history(i).description='LW_wilcoxon';
outheader.history(i).date=date;
outheader.history(i).index=[testtype,alpha];

%prepare outdata
outheader.datasize(1)=1; %epochsize=1
outheader.datasize(3)=2; %indexsize=2
outdata=zeros(outheader.datasize);

%loop
indexpos=1; %indexpos must be 1
for chanpos=1:outheader.datasize(2);
    for dz=1:outheader.datasize(4);
        for dy=1:outheader.datasize(5);
            if strcmpi(testtype,'signedrank');
                for dx=1:outheader.datasize(6);
                    tpleft=squeeze(leftdata(:,chanpos,indexpos,dz,dy,dx));
                    tpright=squeeze(rightdata(:,chanpos,indexpos,dz,dy,dx));
                    [outdata(1,chanpos,1,dz,dy,dx) outdata(1,chanpos,2,dz,dy,dx)]=signrank(tpleft,tpright,'alpha',alpha);
                end;
            end;
            if strcmpi(testtype,'signed');
                for dx=1:outheader.datasize(6);
                    tpleft=squeeze(leftdata(:,chanpos,indexpos,dz,dy,dx));
                    tpright=squeeze(rightdata(:,chanpos,indexpos,dz,dy,dx));
                    [outdata(1,chanpos,1,dz,dy,dx) outdata(1,chanpos,2,dz,dy,dx)]=signtext(tpleft,tpright,'alpha',alpha);
                end;
            end;
            if strcmpi(testtype,'rank');
                for dx=1:outheader.datasize(6);
                    tpleft=squeeze(leftdata(:,chanpos,indexpos,dz,dy,dx));
                    tpright=squeeze(rightdata(:,chanpos,indexpos,dz,dy,dx));
                    [outdata(1,chanpos,1,dz,dy,dx) outdata(1,chanpos,2,dz,dy,dx)]=ranktest(tpleft,tpright,'alpha',alpha);
                end;
            end;
        end;
    end;
end;

%set index labels
outheader.indexlabels{1}='p-value';
outheader.indexlabels{2}='H';

%parse events
for eventpos=1:length(outheader.events);
    outheader.events(eventpos).epoch=1;
end;

%delete conditions if present
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'conditions');
    outheader=rmfield(outheader,'condition_labels');
end;