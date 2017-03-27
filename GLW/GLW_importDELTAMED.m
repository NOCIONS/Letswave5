function varargout = GLW_importDELTAMED(varargin)
% GLW_IMPORTDELTAMED MATLAB code for GLW_importDELTAMED.fig
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





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_importDELTAMED_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_importDELTAMED_OutputFcn, ...
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





% --- Executes just before GLW_importDELTAMED is made visible.
function GLW_importDELTAMED_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for GLW_importDELTAMED
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_importDELTAMED wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.outputedit,'String',pwd);
set(handles.filebox,'Userdata',varargin{2});
axis off;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_importDELTAMED_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;




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




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filterspec='*.txt;*.TXT';
[filename,pathname]=uigetfile(filterspec,'select TXT header file','MultiSelect','on');
if isequal(filename,0) || isequal(pathname,0)
    else
    filename=cellstr(filename);
    for filepos=1:length(filename);
        filename{filepos}=[pathname,filename{filepos}];
    end;
    set(handles.filebox,'String',filename);
end;





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepath=uigetdir(get(handles.outputedit,'String'));
set(handles.outputedit,'String',filepath);




% --- Executes during object creation, after setting all properties.
function outputedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filenames=get(handles.filebox,'String');
outputdir=get(handles.outputedit,'String');
update_status=get(handles.filebox,'UserData');
update_status.function(update_status.handles,'Importing DELTAMED data.',1,0);
for filepos=1:length(filenames);
    update_status.function(update_status.handles,['*** Importing : ' filenames{filepos}],1,0);
    [header,data]=LW_importDELTAMED(filenames{filepos});
    update_status.function(update_status.handles,['Number of events : ' num2str(length(header.events))],1,0);
    update_status.function(update_status.handles,['Number of epochs : ' num2str(header.datasize(1))],1,0);
    update_status.function(update_status.handles,['Number of channels : ' num2str(header.datasize(2))],1,0);
    update_status.function(update_status.handles,['Number of bins : ' num2str(header.datasize(6))],1,0);   
    %save header
    [p,n,e]=fileparts(filenames{filepos});
    st=fullfile(outputdir,[n,'.lw5']);
    LW_save(st,[],header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);
