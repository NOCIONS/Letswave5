function GLW_status(handles,status)
%update letswave_gui logtext
% 0=ready
% 1=busy
if status==0;
    set(handles.statustext,'String','Ready');
    set(handles.statustext,'ForegroundColor',[0 0.5 0]);
else
    set(handles.statustext,'String','Busy');
    set(handles.statustext,'ForegroundColor',[1 0 0]);
end;
%update
set(handles.filebox,'Value',1);
st=get(handles.pathedit,'String');
%set text string to dir
set(handles.text,'String',st);
%set work dir to dir
cd(st); 
clear d;
d=dir(st);
%update dirlist and filelist
j=1;
k=1;
filelist=[];
dirlist=[];
for i=1:length(d);
    if d(i).isdir==1;
        dirlist{j}=d(i).name;
        j=j+1;
    end;
    if d(i).isdir==0;
        st=d(i).name;
        [path,name,ext]=fileparts(d(i).name);
        if strcmpi(ext,'.lw5')==1;
           filelist{k}=name;
           k=k+1;
        end,
    end;
end;
filterstring=findfilters(filelist);
handles.updatefilterbox(handles,filterstring);
if get(handles.filterchk,'Value')==1;
    filelist=filterfilelist(handles,filelist);
end;
set(handles.filebox,'String',filelist);
set(handles.info_text,'String','');
end

