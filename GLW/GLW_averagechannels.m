function varargout = GLW_averagechannels(varargin)
% GLW_AVERAGECHANNELS MATLAB code for GLW_averagechannels.fig
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
                   'gui_OpeningFcn', @GLW_averagechannels_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_averagechannels_OutputFcn, ...
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




% --- Executes just before GLW_averagechannels is made visible.
function GLW_averagechannels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_averagechannels (see VARARGIN)
% Choose default command line output for GLW_averagechannels
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
inputfiles=get(handles.filebox,'String');
%load header of first inputfile
header=LW_load_header(inputfiles{1});
%fill channelbox with channels
for chanpos=1:length(header.chanlocs);
    inputfiles{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.channelbox,'String',inputfiles);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_averagechannels_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Average channels.',1,0);
%calculate channelmask
update_status.function(update_status.handles,'Computing channel mask.',1,0);
st=get(handles.channelbox,'String');
stv=get(handles.channelbox,'Value');
channelmask=zeros(length(st),1);
channelmask(stv)=1;
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing channel average.',1,0);
    [header,data]=LW_averagechannels(header,data,channelmask);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);






% --- Executes on selection change in channelbox.
function channelbox_Callback(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function channelbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% select all
st=get(handles.channelbox,'String');
vst=1:1:length(st);
set(handles.channelbox,'Value',vst);
set(handles.channelbox,'ListboxTop',1);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% deselect all
set(handles.channelbox,'Value',[]);
set(handles.channelbox,'ListboxTop',1);




% --- Executes during object creation, after setting all properties.
function processbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
