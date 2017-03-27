function [outheader] = LW_addtag(header,tag)
% LW_addtag
%
% Inputs
% - header (LW5 header)
% - tag : string

%
% Outputs
% - outheader (LW5 header)
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
outheader.history(i).description=['LW_addtag ' tag];
outheader.history(i).date=date;
outheader.history(i).index=tag;

%add tags
i=length(outheader.tags)+1;
outheader.tags{i}=tag;

%delete duplicate tags
%loop through tags
tags=outheader.tags;
tagindex=ones(size(tags));
for tagpos=1:length(tags)-1;
    for tagpos2=tagpos+1:length(tags);
        if isequal(tags(tagpos),tags(tagpos2))
            tagindex(tagpos2)=0;
        end;
    end;
end;
%prepare selection
selection=[];
for tagpos=1:length(tags);
    if tagindex(tagpos)==0;
        selection=[selection tagpos];
    end;
end;
tags(selection)=[];


outheader.tags=tags;