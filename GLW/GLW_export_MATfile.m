function varargout = GLW_export_MATfile(varargin)
% GLW_EXPORT_MATFILE MATLAB code for GLW_export_MATfile.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_export_MATfile_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_export_MATfile_OutputFcn, ...
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





% --- Executes just before GLW_export_MATfile is made visible.
function GLW_export_MATfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_export_MATfile (see VARARGIN)
% Choose default command line output for GLW_export_MATfile
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
st=get(handles.filebox,'UserData');
for filepos=1:length(st);
    [p,n,e]=fileparts(st{filepos});
    filenames{filepos}=n;
end;
set(handles.filebox,'String',filenames);
set(handles.filebox,'Value',1:1:length(filenames));
set(handles.processbutton,'Userdata',varargin{3});
axis off;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_export_MATfile_OutputFcn(hObject, eventdata, handles) 
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
selectedfiles=get(handles.filebox,'Value');
inputfiles=inputfiles(selectedfiles);
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Exporting MAT data.',1,0);
lwdata=[];
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Exporting : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Copying to variable.',1,0);
    lwdata(filepos).data=data;
    lwdata(filepos).header=header;
    lwdata(filepos).filename=inputfiles{filepos};
end;
uisave('lwdata');
update_status.function(update_status.handles,'Finished!',0,1);
