function varargout = GLW_rereference(varargin)
% GLW_rereference MATLAB code for GLW_rereference.fig
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
                   'gui_OpeningFcn', @GLW_rereference_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_rereference_OutputFcn, ...
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




% --- Executes just before GLW_rereference is made visible.
function GLW_rereference_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_rereference (see VARARGIN)
% Choose default command line output for GLW_rereference
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
st=varargin{2};
set(handles.filebox,'String',st);
st=get(handles.filebox,'String');
%load header of first inputfile
header=LW_load_header(st{1});
%fill listbox1
for i=1:header.datasize(2);
    stringlist{i}=header.chanlocs(i).labels;
end;
set(handles.listbox1,'String',stringlist);
set(handles.editlist,'Value',[]);
set(handles.applylist,'String',stringlist);
%check apply list
stringlist=get(handles.applylist,'String');
tp=1:1:length(stringlist);
set(handles.applylist,'Value',tp);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_rereference_OutputFcn(hObject, eventdata, handles) 
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
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Rereferencing.',1,0);
%set reference channels
referencechannels=get(handles.editlist,'Value');
%set selected channels
selectedchannels=get(handles.applylist,'Value');
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Applying new reference.',1,0);
    [header,data]=LW_rereference(header,data,referencechannels,selectedchannels);
    LW_save(inputfiles{filepos},get(handles.prefixedit,'String'),header,data);

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




function editlist_Callback(hObject, eventdata, handles)
% hObject    handle to editlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes during object creation, after setting all properties.
function editlist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editlist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add
value1=get(handles.listbox1,'Value');
currentselection=get(handles.editlist,'Value');
%concatenate
value2=[currentselection,value1];
%update
set(handles.editlist,'Value',value2);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(value2));





% --- Executes on button press in deletebutton.
function deletebutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Delete
deleteselection=get(handles.listbox2,'Value');
currentselection=get(handles.editlist,'Value');
currentselection(deleteselection)=[];
set(handles.editlist,'Value',currentselection);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'String',stringlist(currentselection));
set(handles.listbox2,'Value',[]);




% --- Executes on button press in addallbutton.
function addallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add All
stringlist=get(handles.listbox1,'String');
set(handles.editlist,'Value',1:1:length(stringlist));
currentselection=get(handles.editlist,'Value');
%update edit listbox2;
set(handles.listbox2,'String',stringlist(currentselection));




% --- Executes on button press in deleteallbutton.
function deleteallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to deleteallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Delete All
set(handles.editlist,'Value',[]);
currentselection=[];
set(handles.listbox2,'ListboxTop',1);
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(currentselection));
set(handles.listbox2,'Value',[]);




% --- Executes on selection change in applylist.
function applylist_Callback(hObject, eventdata, handles)
% hObject    handle to applylist (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function applylist_CreateFcn(hObject, eventdata, handles)
% hObject    handle to applylist (see GCBO)
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
stringlist=get(handles.applylist,'String');
tp=1:1:length(stringlist);
set(handles.applylist,'Value',tp);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.applylist,'Value',[]);
