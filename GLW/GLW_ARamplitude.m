function varargout = GLW_ARamplitude(varargin)
% GLW_AARamplitude MATLAB code for GLW_ARamplitude.fig
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




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ARamplitude_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ARamplitude_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT




% --- Executes just before GLW_ARamplitude is made visible.
function GLW_ARamplitude_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ARamplitude (see VARARGIN)
% Choose default command line output for GLW_ARamplitude
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill filemenu with inputfiles
filenames=varargin{2};
set(handles.filemenu,'String',filenames);
filenames=get(handles.filemenu,'String');
%loop through inputfiles
for filepos=1:length(filenames);
    header=LW_load_header(filenames{filepos});
    %fill epochlist
    epochlist(filepos).accepted=1:1:header.datasize(1);
    epochlist(filepos).rejected=[];
    for i=1:header.datasize(1);
        epochlist(filepos).stringlist{i}=['epoch ',num2str(i)];
    end;
end;
%userdata
set(handles.filemenu,'UserData',epochlist);
%update lists
updatelists(handles);
%chantext
for chanpos=1:length(header.chanlocs);
    chanlist{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanlist,'String',chanlist);
set(handles.chandispmenu,'String',chanlist);
%include1edit,include2edit
set(handles.include1edit,'String',num2str(header.xstart));
set(handles.include2edit,'String',num2str(header.xstart+((header.datasize(6)-1)*header.xstep)));




function updatelists(handles);
filepos=get(handles.filemenu,'Value');
epochlist=get(handles.filemenu,'UserData');
%update listbox1 and listbox2
set(handles.listbox1,'String',epochlist(filepos).stringlist(epochlist(filepos).accepted));
set(handles.listbox2,'String',epochlist(filepos).stringlist(epochlist(filepos).rejected));




function sortlists(handles);
filepos=get(handles.filemenu,'Value');
epochlist=get(handles.filemenu,'UserData');
%sort accepted and rejected
epochlist(filepos).accepted=sort(epochlist(filepos).accepted);
epochlist(filepos).rejected=sort(epochlist(filepos).rejected);
set(handles.filemenu,'UserData',epochlist);




function mask=buildmask(handles,filepos);
filename=get(handles.filemenu,'String');
header=LW_load_header(filename{filepos});
mask=zeros(header.datasize(6),1);
%include
if get(handles.includecheck,'Value')==1;
    include1=fix((str2num(get(handles.include1edit,'String'))-header.xstart)/header.xstep)+1;
    include2=fix((str2num(get(handles.include2edit,'String'))-header.xstart)/header.xstep)+1;
    mask(include1:include2)=1;
else
    mask(1:header.datasize(6))=1;
end;
%exclude
if get(handles.excludecheck,'Value')==1;
    exclude1=fix((str2num(get(handles.exclude1edit,'String'))-header.xstart)/header.xstep)+1;
    exclude2=fix((str2num(get(handles.exclude2edit,'String'))-header.xstart)/header.xstep)+1;
    mask(exclude1:exclude2)=0;
end;




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ARamplitude_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure




% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on selection change in filebox.
function filebox_Callback(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function filebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
epochlist=get(handles.filemenu,'UserData');
inputfiles=get(handles.filemenu,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Artifact rejection.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Rejecting artifacted epochs.',1,0);
    selectedepochs=epochlist(filepos).accepted;
    selectedchannels=1:1:header.datasize(2);
    selectedindexes=1:1:header.datasize(3);
    [header,data]=LW_selectsignals(header,data,selectedepochs,selectedchannels,selectedindexes);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function editlist1_Callback(hObject, eventdata, handles)
% hObject    handle to editlist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function editlist1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlist1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function editlist2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlist2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% move right
epochlist=get(handles.filemenu,'UserData');
select=get(handles.listbox1,'Value');
filepos=get(handles.filemenu,'Value');
selectepochs=epochlist(filepos).accepted(select);
epochlist(filepos).rejected=[epochlist(filepos).rejected selectepochs];
epochlist(filepos).accepted(select)=[];
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% move left
epochlist=get(handles.filemenu,'UserData');
select=get(handles.listbox2,'Value');
filepos=get(handles.filemenu,'Value');
selectepochs=epochlist(filepos).rejected(select);
epochlist(filepos).accepted=[epochlist(filepos).accepted selectepochs];
epochlist(filepos).rejected(select)=[];
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);




% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Set all Accepted
epochlist=get(handles.filemenu,'UserData');
filepos=get(handles.filemenu,'Value');
epochlist(filepos).accepted=[epochlist(filepos).accepted epochlist(filepos).rejected];
epochlist(filepos).rejected=[];
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);




% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Set all Rejected
epochlist=get(handles.filemenu,'UserData');
filepos=get(handles.filemenu,'Value');
epochlist(filepos).rejected=[epochlist(filepos).rejected epochlist(filepos).accepted];
epochlist(filepos).accepted=[];
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);



% --- Executes on selection change in filemenu.
function filemenu_Callback(hObject, eventdata, handles)
% hObject    handle to filemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'Value',[]);
updatelists(handles);




% --- Executes during object creation, after setting all properties.
function filemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function chanlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in chanlist.
function chanlist_Callback(hObject, eventdata, handles)
% hObject    handle to chanlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function upperedit_Callback(hObject, eventdata, handles)
% hObject    handle to upperedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function upperedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upperedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function loweredit_Callback(hObject, eventdata, handles)
% hObject    handle to loweredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function loweredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loweredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function include1edit_Callback(hObject, eventdata, handles)
% hObject    handle to include1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function include1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to include1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function include2edit_Callback(hObject, eventdata, handles)
% hObject    handle to include2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function include2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to include2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function exclude1edit_Callback(hObject, eventdata, handles)
% hObject    handle to exclude1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function exclude1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exclude1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function exclude2edit_Callback(hObject, eventdata, handles)
% hObject    handle to exclude2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function exclude2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to exclude2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function checkamplitude(handles,filepos);
epochlist=get(handles.filemenu,'UserData');
%check current
mask=buildmask(handles,filepos);
%load header
filename=get(handles.filemenu,'String');
%load header
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.lw5'];
disp(['loading ',st]);
load(st,'-MAT');
%load data
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.mat'];
load(st,'-MAT');
%selected channels
selectedchannels=get(handles.chanlist,'Value');
%selected epochs
selectedepochs=epochlist(filepos).accepted;
%max min
maxvalue=str2num(get(handles.upperedit,'String'));
minvalue=str2num(get(handles.loweredit,'String'));
%loop through epochs
dz=1;
dy=1;
index=1;
rejectedepochs=[];
for epochpos=1:length(selectedepochs);
    rejected=0;
    for chanpos=1:length(selectedchannels);
        tp=squeeze(data(selectedepochs(epochpos),selectedchannels(chanpos),index,dz,dy,:)).*mask;
        if max(tp)>maxvalue;
            rejected=1;
        end;
        if min(tp)<minvalue;
            rejected=1;
        end;
    end;
    if rejected==1;
        rejectedepochs=[rejectedepochs,epochpos];
    end;
end;
%apply
epochlist(filepos).rejected=[epochlist(filepos).rejected epochlist(filepos).accepted(rejectedepochs)];
epochlist(filepos).accepted(rejectedepochs)=[];
set(handles.filemenu,'UserData',epochlist);
disp('Done!');




% --- Executes on button press in checkbutton.
function checkbutton_Callback(hObject, eventdata, handles)
% hObject    handle to checkbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepos=get(handles.filemenu,'Value');
checkamplitude(handles,filepos);
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'Value',[]);
sortlists(handles);
updatelists(handles);
        




% --- Executes on button press in checkallbutton.
function checkallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to checkallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filenames=get(handles.filemenu,'String');
for filepos=1:length(filenames);
    checkamplitude(handles,filepos);
end;
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'Value',[]);
sortlists(handles);
updatelists(handles);




% --- Executes on button press in includecheck.
function includecheck_Callback(hObject, eventdata, handles)
% hObject    handle to includecheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in excludecheck.
function excludecheck_Callback(hObject, eventdata, handles)
% hObject    handle to excludecheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in chandispmenu.
function chandispmenu_Callback(hObject, eventdata, handles)
% hObject    handle to chandispmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function chandispmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chandispmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton15.
function pushbutton15_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton15 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% plot rejected
epochlist=get(handles.filemenu,'UserData');
%load header
filepos=get(handles.filemenu,'Value');
filename=get(handles.filemenu,'String');
%load header
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.lw5'];
load(st,'-MAT');
%load data
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.mat'];
load(st,'-MAT');
%selected channel
chanpos=get(handles.chandispmenu,'Value');
%selected epochs
selectedepochs=epochlist(filepos).rejected;
if length(selectedepochs)<1;
    return;
end;
%prepare data (tpy)
index=1;
dz=1;
dy=1;
tpy=squeeze(data(selectedepochs,chanpos,index,dz,dy,:));
%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;
%figure
if isfield(epochlist(1),'rejectfigure')==1;
    figure(epochlist(1).rejectfigure);
    set(epochlist(1).rejectfigure,'MenuBar','none');
    set(epochlist(1).rejectfigure,'ToolBar','none');
    set(epochlist(1).rejectfigure,'Name','rejected epochs');
else
    epochlist(1).rejectfigure=figure;
    set(epochlist(1).rejectfigure,'MenuBar','none');
    set(epochlist(1).rejectfigure,'ToolBar','none');
    set(epochlist(1).rejectfigure,'Name','rejected epochs');
end;
plot(tpx,tpy);
hold;
plot(tpx,squeeze(mean(tpy,1)),'k','LineWidth',2);





% --- Executes on button press in pushbutton16.
function pushbutton16_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton16 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% plot accepted
epochlist=get(handles.filemenu,'UserData');
%load header
filepos=get(handles.filemenu,'Value');
filename=get(handles.filemenu,'String');
%load header
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.lw5'];
load(st,'-MAT');
%load data
[p,n,e]=fileparts(filename{filepos});
st=[p,filesep,n,'.mat'];
load(st,'-MAT');
%selected channel
chanpos=get(handles.chandispmenu,'Value');
%selected epochs
selectedepochs=epochlist(filepos).accepted;
if length(selectedepochs)<1;
    return;
end;
%prepare data (tpy)
index=1;
dz=1;
dy=1;
tpy=squeeze(data(selectedepochs,chanpos,index,dz,dy,:));
%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;
%figure
if isfield(epochlist(1),'acceptfigure')==1;
    figure(epochlist(1).acceptfigure);
    set(epochlist(1).acceptfigure,'MenuBar','none');
    set(epochlist(1).acceptfigure,'ToolBar','none');
    set(epochlist(1).acceptfigure,'Name','accepted epochs');
else
    epochlist(1).acceptfigure=figure;
    set(epochlist(1).acceptfigure,'MenuBar','none');
    set(epochlist(1).acceptfigure,'ToolBar','none');
    set(epochlist(1).acceptfigure,'Name','accepted epochs');
end;
plot(tpx,tpy);
hold;
plot(tpx,squeeze(mean(tpy,1)),'k','LineWidth',2);




% --- Executes on button press in pushbutton17.
function pushbutton17_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton17 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epochlist=get(handles.filemenu,'UserData');
for filepos=1:length(epochlist);
    epochlist(filepos).accepted=[epochlist(filepos).accepted epochlist(filepos).rejected];
    epochlist(filepos).rejected=[];
end;
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);





% --- Executes on button press in pushbutton18.
function pushbutton18_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton18 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epochlist=get(handles.filemenu,'UserData');
for filepos=1:length(epochlist);
    epochlist(filepos).rejected=[epochlist(filepos).rejected epochlist(filepos).accepted];
    epochlist(filepos).accepted=[];
end;
set(handles.listbox1,'ListboxTop',1);
set(handles.listbox1,'Value',[]);
set(handles.filemenu,'UserData',epochlist);
sortlists(handles);
updatelists(handles);




% --- Executes on button press in pushbutton19.
function pushbutton19_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton19 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epochlist=get(handles.filemenu,'UserData');
filelist=get(handles.filemenu,'String');
st{1}='Number of rejected epochs :';
for i=1:length(epochlist);
    [p,n,e]=fileparts(filelist{i});
    tp=[n ' : ' num2str(length(epochlist(i).rejected)) ' out of ' num2str(length(epochlist(i).rejected)+length(epochlist(i).accepted)) ' epochs.'];
    st{i+1}=tp;
end;
msgbox(st);
    
