function LW_check_matrixfiles(lookpath,matrixprefix)
% LW_check_matrixfiles
% check consistency of matrixfiles
%
% Inputs
% - lookpath : path to check for consistency of matrixfiles
% - matrixprefix : prefix used to identify matrixfiles
%
% Outputs : none.
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


%find header files
tp=dir([lookpath,filesep,'*.lw5']);
for i=1:size(tp,1);
    headerfiles{i}=tp(i).name;
end;
filepath=lookpath;
%find matrix files
j=1;
matrixfiles=[];
for i=1:size(headerfiles,2);
    if findstr(headerfiles{i},matrixprefix);
        matrixfiles{j}=headerfiles{i};
        j=j+1;
    end;
end;
%matrixindex
matrixindex=zeros(size(matrixfiles));

%loop through header files (to check if matrix files exist)
for i=1:size(headerfiles,2);
    %load header
    headerfile=[filepath,filesep,headerfiles{i}];
    load(headerfile,'-mat');
    %matrixfile
    if isfield(header,'filename_bss');
        matrixfile=header.filename_bss;
        %check if present
        matrixexists=0;
        if isempty(matrixindex);
        else
            for j=1:size(matrixfiles,2);
                if strcmp(matrixfile,matrixfiles{j});
                    matrixindex(j)=1;
                    matrixexists=1;
                end;
            end;
        end;
        if matrixexists==0;
            disp(['matrix file not found, field deleted in : ',headerfile]);
            header=rmfield(header,'filename_bss');
            save(headerfile,'-MAT','header');
        end;
    end;
end;
%delete unused matrix files
if isempty(matrixindex);
else
    selection=[];
    for i=1:size(matrixindex,2);
        if matrixindex(i)==0;
            selection=[selection,i];
        end;
    end;
    deletefiles=matrixfiles(selection);
    if isempty(deletefiles)
    else
        for j=1:size(deletefiles,2);
            deletefile=[filepath,filesep,deletefiles{j}];
            disp(['deleting unused matrix file : ',deletefile]);
            delete(deletefile);
        end;
    end;
end;
    