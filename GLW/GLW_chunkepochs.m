function varargout = GLW_chunkepochs(varargin)
% GLW_CHUNKEPOCHS MATLAB code for GLW_chunkepochs.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_chunkepochs_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_chunkepochs_OutputFcn, ...
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





% --- Executes just before GLW_chunkepochs is made visible.
function GLW_chunkepochs_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_chunkepochs (see VARARGIN)
% Choose default command line output for GLW_chunkepochs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%inputfiles
inputfiles=get(handles.filebox,'String');
%load header of first file
header=LW_load_header(inputfiles{1});
%set offsetedit
set(handles.offsetedit,'String',num2str(header.xstart));






% --- Outputs from this function are returned to the command line.
function varargout = GLW_chunkepochs_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Chunk epochs.',1,0);
%set parameters
offset=str2num(get(handles.offsetedit,'String'));
epochlength=str2num(get(handles.epochlengthedit,'String'));
epochstep=str2num(get(handles.epochstepedit,'String'));
if get(handles.numchunkschk,'Value')==1;
    numchunks='max';
else
    numchunks=str2num(get(handles.numchunksedit,'String'));
end;
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Chunking epochs.',1,0);
    [header,data]=LW_chunkepochs(header,data,offset,epochlength,epochstep,numchunks);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




function offsetedit_Callback(hObject, eventdata, handles)
% hObject    handle to offsetedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function offsetedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to offsetedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function epochlengthedit_Callback(hObject, eventdata, handles)
% hObject    handle to epochlengthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochlengthedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochlengthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function epochstepedit_Callback(hObject, eventdata, handles)
% hObject    handle to epochstepedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochstepedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochstepedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function numchunksedit_Callback(hObject, eventdata, handles)
% hObject    handle to numchunksedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function numchunksedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numchunksedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in numchunkschk.
function numchunkschk_Callback(hObject, eventdata, handles)
% hObject    handle to numchunkschk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.numchunkschk,'Value')==1;
    set(handles.numchunksedit,'Enable','off');
else
    set(handles.numchunksedit,'Enable','on');
end;
