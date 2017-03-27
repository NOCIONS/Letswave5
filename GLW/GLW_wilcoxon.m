function varargout = GLW_wilcoxon(varargin)
% GLW_WILCOXON MATLAB code for GLW_wilcoxon.fig
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
                   'gui_OpeningFcn', @GLW_wilcoxon_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_wilcoxon_OutputFcn, ...
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




% --- Executes just before GLW_wilcoxon is made visible.
function GLW_wilcoxon_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_wilcoxon (see VARARGIN)
% Choose default command line output for GLW_wilcoxon
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
st=get(handles.filebox,'String');
%set leftedit and rightedit
set(handles.leftedit,'String',st{1});
set(handles.rightedit,'String',st{2});
%set outputedit
[p,n,e]=fileparts(st{1});
set(handles.outputedit,'String',[p,filesep,'wilcoxon.lw5']);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_wilcoxon_OutputFcn(hObject, eventdata, handles) 
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
leftfile=get(handles.leftedit,'String');
rightfile=get(handles.rightedit,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Statistics : Wilcoxon.',1,0);
%load left header and data
update_status.function(update_status.handles,['Loading : ' leftfile],1,0);
[leftheader,leftdata]=LW_load(leftfile);
%load right header and data
update_status.function(update_status.handles,['Loading : ' rightfile],1,0);
[rightheader,rightdata]=LW_load(rightfile);
%set type,tails,alpha
typestring={'signedrank','signed','rank'};
typeindex=get(handles.typemenu,'Value');
alpha=str2num(get(handles.alphaedit,'String'));
%process
update_status.function(update_status.handles,['Performing Wilcoxon test.'],1,0);
update_status.function(update_status.handles,['Type of test : ' typestring{typeindex} ' Alpha : ' num2str(alpha)],1,0);
[header,data]=LW_wilcoxon(leftheader,leftdata,rightheader,rightdata,typestring{typeindex},alpha);
LW_save(get(handles.outputedit,'String'),[],header,data);
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in methodmenu.
function methodmenu_Callback(hObject, eventdata, handles)
% hObject    handle to methodmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function methodmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typemenu.
function typemenu_Callback(hObject, eventdata, handles)
% hObject    handle to typemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function typemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tailmenu.
function tailmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tailmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tailmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tailmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function leftedit_Callback(hObject, eventdata, handles)
% hObject    handle to leftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function leftedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rightedit_Callback(hObject, eventdata, handles)
% hObject    handle to rightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function rightedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightedit (see GCBO)
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
st=get(handles.leftedit,'String');
set(handles.leftedit,'String',get(handles.rightedit,'String'));
set(handles.rightedit,'String',st);



function alphaedit_Callback(hObject, eventdata, handles)
% hObject    handle to alphaedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function alphaedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function processbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function outputedit_Callback(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function outputedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
