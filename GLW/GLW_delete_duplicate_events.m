function varargout = GLW_delete_duplicate_events(varargin)
% GLW_DELETE_DUPLICATE_EVENTS MATLAB code for GLW_delete_duplicate_events.fig
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
                   'gui_OpeningFcn', @GLW_delete_duplicate_events_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_delete_duplicate_events_OutputFcn, ...
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





% --- Executes just before GLW_delete_duplicate_events is made visible.
function GLW_delete_duplicate_events_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_delete_duplicate_events (see VARARGIN)
% Choose default command line output for GLW_delete_duplicate_events
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;




% --- Outputs from this function are returned to the command line.
function varargout = GLW_delete_duplicate_events_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Deleting duplicate events.',1,0);
%loop through files
for filepos=1:size(inputfiles,1);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %process
    [header]=LW_delete_duplicate_events(header);
    %process2 (of inexact)
    if get(handles.inexact_chk,'Value')==1;
        latency=str2num(get(handles.latency_edit,'String'));
        [header]=LW_delete_duplicate_events_inexact(header,latency);
    end;
    LW_save_header(inputfiles{filepos},[],header);

end;
update_status.function(update_status.handles,'Finished!',0,1);


% --- Executes on button press in exact_chk.
function exact_chk_Callback(hObject, eventdata, handles)
% hObject    handle to exact_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.exact_chk,'Value')==1;
    set(handles.inexact_chk,'Value',0);
else
    set(handles.inexact_chk,'Value',1);
end;





% --- Executes on button press in inexact_chk.
function inexact_chk_Callback(hObject, eventdata, handles)
% hObject    handle to inexact_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.inexact_chk,'Value')==1;
    set(handles.exact_chk,'Value',0);
else
    set(handles.exact_chk,'Value',1);
end;




function latency_edit_Callback(hObject, eventdata, handles)
% hObject    handle to latency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of latency_edit as text
%        str2double(get(hObject,'String')) returns contents of latency_edit as a double


% --- Executes during object creation, after setting all properties.
function latency_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to latency_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
