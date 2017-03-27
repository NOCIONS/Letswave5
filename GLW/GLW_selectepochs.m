function varargout = GLW_selectepochs(varargin)
% GLW_selectepochs MATLAB code for GLW_selectepochs.fig
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
                   'gui_OpeningFcn', @GLW_selectepochs_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_selectepochs_OutputFcn, ...
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




% --- Executes just before GLW_selectepochs is made visible.
function GLW_selectepochs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_selectepochs (see VARARGIN)
% Choose default command line output for GLW_selectepochs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
st=varargin{2};
set(handles.filebox,'String',st);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%load header of first inputfile
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
%fill listbox1
%determine stringsize for num2str of fixed width (needed to adequately sort epochs)
form=['%0',num2str(length(num2str(header.datasize(1)))),'d'];
for i=1:header.datasize(1);
    stringlist{i}=['epoch ',num2str(i,form)];
end;
set(handles.listbox1,'String',stringlist);
set(handles.listbox1,'UserData',[]);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_selectepochs_OutputFcn(hObject, eventdata, handles) 
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
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Selecting epochs.',1,0);
%set selected epochs
selectedepochs=get(handles.listbox1,'UserData');
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %selected channels
    selectedchannels=1:1:header.datasize(2);
    %selected indexes
    selectedindexes=1:1:header.datasize(3);
    %process
    update_status.function(update_status.handles,'Parsing epochs.',1,0);
    [header,data]=LW_selectsignals(header,data,selectedepochs,selectedchannels,selectedindexes);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);


% --- Executes on selection change in listbox1.
function listbox1_Callback(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox1


% --- Executes during object creation, after setting all properties.
function listbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns listbox2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from listbox2


% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Insert
% Add selected epochs in listbox1 at position selected in listbox2 (stored in listbox1.UserData)
value1=get(handles.listbox1,'Value');
value2=get(handles.listbox2,'Value');
position=value2(1);
currentselection=get(handles.listbox1,'UserData');
if position==1;
    part1=[];
    part2=currentselection;
else
    part1=currentselection(1:position-1);
    part2=currentselection(position:length(currentselection));
end;
%concatenate
value2=[part1,value1,part2];
%update
set(handles.listbox1,'UserData',value2);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(value2));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add Top
value1=get(handles.listbox1,'Value');
currentselection=get(handles.listbox1,'UserData');
%concatenate
value2=[value1,currentselection];
%update
set(handles.listbox1,'UserData',value2);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(value2));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add Bottom
value1=get(handles.listbox1,'Value');
currentselection=get(handles.listbox1,'UserData');
%concatenate
value2=[currentselection,value1];
%update
set(handles.listbox1,'UserData',value2);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(value2));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);






% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Sort Ascending
stringlist=get(handles.listbox2,'String');
[a,b]=sort(stringlist);
currentselection=get(handles.listbox1,'UserData');
currentselection=currentselection(b);
set(handles.listbox1,'UserData',currentselection);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(currentselection));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);



% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Sort Descending
stringlist=get(handles.listbox2,'String');
[a,b]=sort(stringlist);
b=flipud(b);
currentselection=get(handles.listbox1,'UserData');
currentselection=currentselection(b);
set(handles.listbox1,'UserData',currentselection);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(currentselection));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);



% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Delete
deleteselection=get(handles.listbox2,'Value');
currentselection=get(handles.listbox1,'UserData');
currentselection(deleteselection)=[];
set(handles.listbox1,'UserData',currentselection);
%update edit listbox2;
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'ListboxTop',1);
set(handles.listbox2,'String',stringlist(currentselection));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);




% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Add All
stringlist=get(handles.listbox1,'String');
set(handles.listbox1,'UserData',1:1:length(stringlist));
currentselection=get(handles.listbox1,'UserData');
%update edit listbox2;
set(handles.listbox2,'String',stringlist(currentselection));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);





% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Delete All
set(handles.listbox1,'UserData',[]);
currentselection=[];
set(handles.listbox2,'ListboxTop',1);
stringlist=get(handles.listbox1,'String');
set(handles.listbox2,'String',stringlist(currentselection));
%update selection 
set(handles.listbox1,'Value',[]);
set(handles.listbox2,'Value',[]);




% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stringlist=get(handles.listbox1,'String');
selected=1:2:length(stringlist);
set(handles.listbox1,'Value',selected);




% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
stringlist=get(handles.listbox1,'String');
selected=2:2:length(stringlist);
set(handles.listbox1,'Value',selected);
