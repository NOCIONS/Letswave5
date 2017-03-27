function varargout = GLW_adduserdata(varargin)
% GLW_ADDUSERDATA MATLAB code for GLW_adduserdata.fig
%




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_adduserdata_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_adduserdata_OutputFcn, ...
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




% --- Executes just before GLW_adduserdata is made visible.
function GLW_adduserdata_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_adduserdata (see VARARGIN)
% Choose default command line output for GLW_adduserdata
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles (the array of input files is stored in varargin{2})
%The 'UserData' field contains the full path+filename of the LW5 datafile
set(handles.filebox,'UserData',varargin{2});
set(handles.text_label,'Userdata',varargin{3});
axis off;
st=get(handles.filebox,'UserData');
for i=1:length(st);
    [p,n,e]=fileparts(st{i});
    inputfiles{i}=n;
end;
%The 'String' field only contains the name (without path and extension)
set(handles.filebox,'String',inputfiles);
%Header
load(st{1},'-mat');
set(handles.save_btn,'UserData',header);








% --- Outputs from this function are returned to the command line.
function varargout = GLW_adduserdata_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%get the list of inputfiles
inputfiles=get(handles.filebox,'UserData');
%userdata
udata=get(handles.import_btn,'UserData');
update_status=get(handles.text_label,'UserData');
update_status.function(update_status.handles,'*** Adding Userdata',1,0);
header=LW_load_header(inputfiles{1});
%process
for i=1:header.datasize(1);
    header.epochdata(i).userdata=udata(i);
end;
%save header
LW_save_header(inputfiles{1},[],header);;
update_status.function(update_status.handles,'Finished',0,1);



function varname_edit_Callback(hObject, eventdata, handles)
% hObject    handle to varname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function varname_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in import_btn.
function import_btn_Callback(hObject, eventdata, handles)
% hObject    handle to import_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%varname
varname=get(handles.varname_edit,'String');
%udata
udata=evalin('base',varname);
%header
header=get(handles.save_btn,'UserData');
%
disp(['Number of entries in the variable : ' num2str(length(udata))]);
disp(['Number of epochs in the dataset : ' num2str(header.datasize(1))]);
%check consistency
if length(udata)==header.datasize(1);
    disp('The number of entries in the variable matches the number of epochs in the datafile');
    set(handles.save_btn,'enable','on');
    set(handles.import_btn,'UserData',udata);
else
    disp('The number of entries in the variable does not match the number of epochs in the datafile');
    set(handles.save_btn,'enable','off');
end;
