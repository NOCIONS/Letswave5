function filelist=LW_findtags(searchpath,tags,searchoption)
% LW_findtags
% search for LW5 files with corresponding tags
%
% Inputs
% - searchpath : search path
% - tags : cell array
% - searchoption : 'or','and'
%
% Outputs : 
% - filelist : cell array
%
% Dependencies : none.
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

%generate filelist (d)
if searchpath(length(searchpath))==filesep;
    searchpath=[searchpath '*.lw5'];
else
    searchpath=[searchpath filesep '*.lw5'];
end;
d=dir(searchpath);

%loop through files
filelist={};
for filepos=1:length(d);
    filelist{filepos}=d(filepos).name;;
end;

%loop through files and check headers
found=zeros(length(filelist),1);
for filepos=1:length(filelist);
    %load header
    load(filelist{filepos},'-mat');
    if isfield(header,'tags');
        if length(header.tags)>0;
            if strcmpi(searchoption,'or');
                for tagpos=1:length(tags);
                    for tagpos2=1:length(header.tags);
                        if strcmpi(tags{tagpos},header.tags{tagpos2});
                            found(filepos)=1;
                        end;
                    end;
                end;
            end;
            if strcmpi(searchoption,'and');
                found(filepos)=1;
                for tagpos=1:length(tags);
                    if found(filepos)==1;
                        tpfound=0;
                        for tagpos2=1:length(header.tags);
                            if strcmpi(tags{tagpos},header.tags{tagpos2});
                                tpfound=1;
                            end;
                        end;
                        if tpfound==0;
                            found(filepos)=0;
                        end;
                    end;
                end;
            end;
        end;
    end;
end;

%idx
idx=[];
for i=1:length(found);
    if found(i)==1;
        idx=[idx,i];
    end;
end;

%update filelist
filelist=filelist(idx);
