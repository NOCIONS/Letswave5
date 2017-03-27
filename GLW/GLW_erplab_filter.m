function varargout = GLW_erplab_filter(varargin)
% GLW_ERPLAB_FILTER MATLAB code for GLW_erplab_filter.fig





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_erplab_filter_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_erplab_filter_OutputFcn, ...
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






% --- Executes just before GLW_erplab_filter is made visible.
function GLW_erplab_filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_erplab_filter (see VARARGIN)
% Choose default command line output for GLW_erplab_filter
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill filebox UserData with name of inputfiles
set(handles.filebox,'Userdata',varargin{2});
%fill filebox String with name of inputfiles (without path and extension)
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles);
    inputfiles{i}=n;
end;
set(handles.filebox,'String',inputfiles);
    





% --- Outputs from this function are returned to the command line.
function varargout = GLW_erplab_filter_OutputFcn(hObject, eventdata, handles) 
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
inputfiles=get(handles.filebox,'UserData');
disp('*** Starting.');
%loop through files
for filepos=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    disp('*** Applying the filter');
    [header,data]=LW_erplab_filter(header,data,parameters); %the function that actually applies the filter
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
disp('*** Finished.');
