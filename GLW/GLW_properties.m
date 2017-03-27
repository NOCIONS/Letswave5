function varargout = GLW_properties(varargin)
% GLW_PROPERTIES MATLAB code for GLW_properties.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_properties_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_properties_OutputFcn, ...
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





% --- Executes just before GLW_properties is made visible.
function GLW_properties_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_properties (see VARARGIN)
% Choose default command line output for GLW_properties
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
inputfiles=get(handles.filebox,'String');
%load header
header=LW_load_header(inputfiles{1});
set(handles.datatype_edit,'String',header.filetype);
set(handles.name_edit,'String',header.name);
set(handles.xstart_edit,'String',num2str(header.xstart));
set(handles.ystart_edit,'String',num2str(header.ystart));
set(handles.zstart_edit,'String',num2str(header.zstart));
set(handles.xstep_edit,'String',num2str(header.xstep,16));
set(handles.ystep_edit,'String',num2str(header.ystep,16));
set(handles.zstep_edit,'String',num2str(header.zstep,16));
set(handles.xsrate_edit,'String',num2str(1/header.xstep));
set(handles.ysrate_edit,'String',num2str(1/header.ystep));
set(handles.zsrate_edit,'String',num2str(1/header.zstep));
set(handles.xsize_text,'String',num2str(header.datasize(6)));
set(handles.ysize_text,'String',num2str(header.datasize(5)));
set(handles.zsize_text,'String',num2str(header.datasize(4)));
set(handles.epochs_text,'String',num2str(header.datasize(1)));
set(handles.channels_text,'String',num2str(header.datasize(2)));
set(handles.indices_text,'String',num2str(header.datasize(3)));
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;








% --- Outputs from this function are returned to the command line.
function varargout = GLW_properties_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Changing properties.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %process
    if get(handles.typesave_chk,'Value')==1;
        header.filetype=get(handles.datatype_edit,'String');
    end;
    if get(handles.namesave_chk,'Value')==1;
        header.name=get(handles.name_edit,'String');
    end;
    if get(handles.xsave_chk,'Value')==1;
        header.xstart=str2num(get(handles.xstart_edit,'String'));
        header.xstep=1/str2num(get(handles.xsrate_edit,'String'));
    end;
    if get(handles.ysave_chk,'Value')==1;
        header.ystart=str2num(get(handles.ystart_edit,'String'));
        header.ystep=1/str2num(get(handles.ysrate_edit,'String'));
    end;
    if get(handles.zsave_chk,'Value')==1;
        header.zstart=str2num(get(handles.zstart_edit,'String'));
        header.zstep=1/str2num(get(handles.zsrate_edit,'String'));
    end;
    %save header
    LW_save_header(inputfiles{filepos},[],header);
end;
update_status.function(update_status.handles,'Finished!',0,1);



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function datatype_edit_Callback(hObject, eventdata, handles)
% hObject    handle to datatype_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function datatype_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to datatype_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function name_edit_Callback(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function name_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to name_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xstart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function xstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xstep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.xstep_edit,'String');
sr=1/str2num(st);
set(handles.xsrate_edit,'String',num2str(sr));




% --- Executes during object creation, after setting all properties.
function xstep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xsrate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xsrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.xsrate_edit,'String');
stp=1/str2num(st);
set(handles.xstep_edit,'String',num2str(stp,16));




% --- Executes during object creation, after setting all properties.
function xsrate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xsrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ystart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ystart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function ystart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ystart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ystep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ystep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.ystep_edit,'String');
sr=1/str2num(st);
set(handles.ysrate_edit,'String',num2str(sr));




% --- Executes during object creation, after setting all properties.
function ystep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ystep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ysrate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ysrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.ysrate_edit,'String');
stp=1/str2num(st);
set(handles.ystep_edit,'String',num2str(stp,16));




% --- Executes during object creation, after setting all properties.
function ysrate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ysrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function zstart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function zstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zstep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.zstep_edit,'String');
sr=1/str2num(st);
set(handles.zsrate_edit,'String',num2str(sr));




% --- Executes during object creation, after setting all properties.
function zstep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zsrate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to zsrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.zsrate_edit,'String');
stp=1/str2num(st);
set(handles.zstep_edit,'String',num2str(stp,16));




% --- Executes during object creation, after setting all properties.
function zsrate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zsrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xsave_chk.
function xsave_chk_Callback(hObject, eventdata, handles)
% hObject    handle to xsave_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in ysave_chk.
function ysave_chk_Callback(hObject, eventdata, handles)
% hObject    handle to ysave_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in zsave_chk.
function zsave_chk_Callback(hObject, eventdata, handles)
% hObject    handle to zsave_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in namesave_chk.
function namesave_chk_Callback(hObject, eventdata, handles)
% hObject    handle to namesave_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on button press in typesave_chk.
function typesave_chk_Callback(hObject, eventdata, handles)
% hObject    handle to typesave_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
