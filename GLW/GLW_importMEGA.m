function varargout = GLW_importMEGA(varargin)
% GLW_IMPORTMEGA MATLAB code for GLW_importMEGA.fig
%
% Author : 
% Andr Mouraux
% Institute of Neurosciences (IONS)
% Universit catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_importMEGA_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_importMEGA_OutputFcn, ...
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





% --- Executes just before GLW_importMEGA is made visible.
function GLW_importMEGA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for GLW_importMEGA
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_importMEGA wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.outputedit,'String',pwd);
set(handles.filebox,'Userdata',varargin{2});
axis off;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_importMEGA_OutputFcn(hObject, eventdata, handles) 
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
[pathname]=uigetdir;
set(handles.filebox,'String',pathname);





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
session_number=str2num(get(handles.session_edit,'String'));
update_status=get(handles.filebox,'UserData');
update_status.function(update_status.handles,'*** Importing MEGA EEG data.',1,0);
update_status.function(update_status.handles,['Importing : ' filenames],1,0);
[header,data]=LW_importMEGA(filenames,session_number);
update_status.function(update_status.handles,['Number of events : ' num2str(length(header.events))],1,0);
update_status.function(update_status.handles,['Number of epochs : ' num2str(header.datasize(1))],1,0);
update_status.function(update_status.handles,['Number of channels : ' num2str(header.datasize(2))],1,0);
update_status.function(update_status.handles,['Number of bins : ' num2str(header.datasize(6))],1,0);
%set filename
tp=filenames;
a=find(tp==filesep);
filename=[tp(max(a)+1:end) '_' num2str(session_number) '.lw5'];
%save header
st=fullfile(outputdir,filename);
LW_save(st,[],header,data);
update_status.function(update_status.handles,'Finished!',0,1);



% --- Executes on button press in continuous_chk.
function continuous_chk_Callback(hObject, eventdata, handles)
% hObject    handle to continuous_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in BIOSIG_chk.
function BIOSIG_chk_Callback(hObject, eventdata, handles)
% hObject    handle to BIOSIG_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.BIOSIG_chk,'Value')==1;
    set(handles.continuous_chk,'Value')=1;
end;



function session_edit_Callback(hObject, eventdata, handles)
% hObject    handle to session_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function session_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to session_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
