function varargout = GLW_ica_assignfile(varargin)
% GLW_ICA_ASSIGNFILE MATLAB code for GLW_ica_assignfile.fig
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
                   'gui_OpeningFcn', @GLW_ica_assignfile_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ica_assignfile_OutputFcn, ...
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





% --- Executes just before GLW_ica_assignfile is made visible.
function GLW_ica_assignfile_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ica_assignfile (see VARARGIN)
% Choose default command line output for GLW_ica_assignfile
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ica_assignfile_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Assigning ICA matrix file.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    [p n e]=fileparts(inputfiles{filepos});
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %matrix file name
    [ps,ns,es]=fileparts(get(handles.icafilename,'String'));
    icafilename=[ns,'.lw5'];
    %copy ica matrix file in current directory if it does not exist
    if exist([p,filesep,icafilename])==0;
        update_status.function(update_status.handles,['Copying splinefile to : ',p,filesep,icafilename],1,0);
        copyfile(get(handles.icafilename,'String'),[p,filesep,icafilename]);
    end;
    %process
    update_status.function(update_status.handles,'Assigning matrix file.',1,0);
    [header]=LW_ica_assignfile(header,icafilename);
    LW_save_header(inputfiles{filepos},[],header);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
[p,n,e]=fileparts(inputfiles{1});
filterspec=[p,filesep,'*.lw5'];
filename=uigetfile(filterspec);
set(handles.icafilename,'String',filename);
