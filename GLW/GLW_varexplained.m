function varargout = GLW_varexplained(varargin)
% GLW_varexplained MATLAB code for GLW_varexplained.fig
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
% Last Modified by GUIDE v2.5 07-Jun-2012 09:46:51





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_varexplained_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_varexplained_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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





% --- Executes just before GLW_varexplained is made visible.
function GLW_varexplained_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill filebox with inputfiles
st=varargin{2};
set(handles.filebox,'UserData',st);
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
%fill filebox2 with inputfiles
set(handles.filebox2,'String',cleanfiles);
%select first file
set(handles.filebox2,'Value',1);
%update filebox1
update_filebox1(handles);
%chanbox
header=LW_load_header(inputfiles{1});
chanstring={};
for i=1:length(header.chanlocs);
    chanstring{i}=header.chanlocs(i).labels;
end;
set(handles.chanbox,'String',chanstring);
sel=1:1:length(chanstring);
set(handles.chanbox,'Value',sel);






function update_filebox1(handles);
selected2=get(handles.filebox2,'Value');
inputfiles=get(handles.filebox,'String');
selected1=1:1:length(inputfiles);
selected1(selected2)=[];
set(handles.filebox1,'String',inputfiles(selected1));





% --- Outputs from this function are returned to the command line.
function varargout = GLW_varexplained_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;





% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
inputfiles=get(handles.filebox,'UserData');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Variance explained.',1,0);
selected_channels=get(handles.chanbox,'Value');
inputfile2_index=get(handles.filebox2,'Value');
inputfile1_index=1:1:length(inputfiles);
inputfile1_index(inputfile2_index)=[];
%load header2 data2
update_status.function(update_status.handles,['Loading : ' inputfiles{inputfile2_index}],1,0);
[header2,data2]=LW_load(inputfiles{inputfile2_index});
%loop through file1
for i=1:length(inputfile1_index);
    update_status.function(update_status.handles,['Loading : ' inputfiles{inputfile1_index(i)}],1,0);
    %load header1 data1
    [header1,data1]=LW_load(inputfiles{inputfile1_index(i)});
    %process
    update_status.function(update_status.handles,'Calculating explained variance.',1,0);
    [header,data]=LW_varexplained(header1,data1,header2,data2,selected_channels);
    %save header data
    LW_save(inputfiles{inputfile1_index(i)},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




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




% --- Executes on selection change in filebox1.
function filebox1_Callback(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function filebox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in filebox2.
function filebox2_Callback(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_filebox1(handles);




% --- Executes during object creation, after setting all properties.
function filebox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in chanbox.
function chanbox_Callback(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function chanbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in allbutton.
function allbutton_Callback(hObject, eventdata, handles)
% hObject    handle to allbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chanstring=get(handles.chanbox,'String');
sel=1:1:length(chanstring);
set(handles.chanbox,'Value',sel);




% --- Executes on button press in nonebutton.
function nonebutton_Callback(hObject, eventdata, handles)
% hObject    handle to nonebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chanbox,'Value',[]);
