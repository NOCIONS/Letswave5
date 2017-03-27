function varargout = GLW_edittag(varargin)
% GLW_edittag MATLAB code for GLW_butterhigh.fig
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
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
                   'gui_OpeningFcn', @GLW_edittag_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_edittag_OutputFcn, ...
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




% --- Executes just before GLW_averageepochs is made visible.
function GLW_edittag_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_averageepochs (see VARARGIN)
% Choose default command line output for GLW_averageepochs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
inputfiles=varargin{2};
set(handles.filebox,'String',inputfiles);
set(handles.tagbox,'String',[]);
%load header
header=LW_load_header(inputfiles{1});
%fill tagbox with existing tags
set(handles.tagbox,'String',header.tags);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;






% --- Outputs from this function are returned to the command line.
function varargout = GLW_edittag_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Editing tags.',1,0);
%load header
update_status.function(update_status.handles,['Loading : ' inputfiles{1}],1,0);
header=LW_load_header(inputfiles{1});
%update tag
tags=get(handles.tagbox,'String');
header.tags={};
for i=1:length(tags);
    header.tags{i}=tags{i};
end;
%save header
[p,n,e]=fileparts(inputfiles{1});
st=[p,filesep,n,'.lw5'];
save(st,'-MAT','header');
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in tagbox.
function tagbox_Callback(hObject, eventdata, handles)
% hObject    handle to tagbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function tagbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function tagedit_Callback(hObject, eventdata, handles)
% hObject    handle to tagedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function tagedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagedit (see GCBO)
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
st=get(handles.tagbox,'String');
if length(st)>0;
    st{length(st)+1}=get(handles.tagedit,'String');
else
    st{1}=get(handles.tagedit,'String');
end;
set(handles.tagbox,'String',st);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
selected=get(handles.tagbox,'Value');
tags=get(handles.tagbox,'String');
tags(selected)=[];
set(handles.tagbox,'String',tags);
