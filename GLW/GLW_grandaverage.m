function varargout = GLW_grandaverage(varargin)
% GLW_GRANDAVERAGE MATLAB code for GLW_grandaverage.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_grandaverage_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_grandaverage_OutputFcn, ...
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





% --- Executes just before GLW_grandaverage is made visible.
function GLW_grandaverage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_grandaverage (see VARARGIN)
% Choose default command line output for GLW_grandaverage
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
inputfiles=get(handles.filebox,'String');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    table{i,1}=n;
    table{i,2}='1';
end;
set(handles.uitable,'Data',table);






% --- Outputs from this function are returned to the command line.
function varargout = GLW_grandaverage_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Grand average.',1,0);
%weights
table=get(handles.uitable,'Data');
for i=1:size(table,1);
    weights(i)=str2num(table{i,2});
end;
%load first header
header=LW_load_header(inputfiles{1});
%prepare outdata
outdata=zeros(header.datasize);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing grand average.',1,0);
    outdata=outdata+(weights(filepos)*data);
end;
data=outdata/sum(weights);
%delete dipfit
if isfield(header,'fieldtrip_dipfit');
    rmfield(header,'fieldtrip_dipfit');
end;
%delete conditions
if isfield(header,'conditions');
    rmfield(header,'conditions');
end;
%delete condition_labels
if isfield(header,'condition_labels');
    rmfield(header,'condition_labels');
end;
%delete epochdata
if isfield(header,'epochdata');
    rmfield(header,'epochdata');
end;
%save header
[p,n,e]=fileparts(inputfiles{filepos});
[p2,n2,e2]=fileparts(get(handles.filenametext,'String'));
st=[p,filesep,n2,'.lw5'];
LW_save(st,[],header,data);
update_status.function(update_status.handles,'Finished!',0,1);

