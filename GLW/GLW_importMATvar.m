function varargout = GLW_importMATvar(varargin)
% GLW_IMPORTMATVAR MATLAB code for GLW_importMATvar.fig
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
                   'gui_OpeningFcn', @GLW_importMATvar_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_importMATvar_OutputFcn, ...
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





% --- Executes just before GLW_importMATvar is made visible.
function GLW_importMATvar_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for GLW_importMATvar
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_importMATvar wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.outputedit,'String',pwd);
set(handles.varbox,'Userdata',varargin{2});
axis off;
refresh_workspace_variables(handles);



function refresh_workspace_variables(handles)
%load workspace variables
vars = evalin('base','who');
set(handles.varbox,'String',vars);




function a=load_selected_workspace_var(varname);
a=evalin('base',varname);
size(a)



% --- Outputs from this function are returned to the command line.
function varargout = GLW_importMATvar_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;




% --- Executes on selection change in varbox.
function varbox_Callback(hObject, eventdata, handles)
% hObject    handle to varbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selection
var_labels=get(handles.varbox,'String');
selected_vars=get(handles.varbox,'Value');
for i=1:length(selected_vars);
    disp(['Loading : ' var_labels{selected_vars(i)}]);
    a=load_selected_workspace_var(var_labels{selected_vars(i)});
    a_dims(i)=ndims(a);
end;
a_dims=unique(a_dims);
if length(a_dims)>1;
    disp('Error! All variables must have the same number of dimensions');
else
    if a_dims==1;
        set(handles.dim2_label,'Enable','off');
        set(handles.dim2_popup,'Enable','off');
        set(handles.dim3_label,'Enable','off');
        set(handles.dim3_popup,'Enable','off');
        set(handles.dim4_label,'Enable','off');
        set(handles.dim4_popup,'Enable','off');
    end;
    if a_dims==2;
        set(handles.dim2_label,'Enable','on');
        set(handles.dim2_popup,'Enable','on');
        set(handles.dim3_label,'Enable','off');
        set(handles.dim3_popup,'Enable','off');
        set(handles.dim4_label,'Enable','off');
        set(handles.dim4_popup,'Enable','off');
    end;
    if a_dims==3;
        set(handles.dim2_label,'Enable','on');
        set(handles.dim2_popup,'Enable','on');
        set(handles.dim3_label,'Enable','on');
        set(handles.dim3_popup,'Enable','on');
        set(handles.dim4_label,'Enable','off');
        set(handles.dim4_popup,'Enable','off');
    end;
    if a_dims==4;
        set(handles.dim2_label,'Enable','on');
        set(handles.dim2_popup,'Enable','on');
        set(handles.dim3_label,'Enable','on');
        set(handles.dim3_popup,'Enable','on');
        set(handles.dim4_label,'Enable','on');
        set(handles.dim4_popup,'Enable','on');
    end;
    if a_dims>4;
        disp('Error! The maximum number of dimensions is 4');
    end;
end;












% --- Executes during object creation, after setting all properties.
function varbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to varbox (see GCBO)
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
filterspec='*.mat;*.MAT';
[filename,pathname]=uigetfile(filterspec,'select datafiles','MultiSelect','on');
if isequal(filename,0) || isequal(pathname,0)
    else
    filename=cellstr(filename);
    for filepos=1:length(filename);
        filename{filepos}=[pathname,filename{filepos}];
    end;
    set(handles.varbox,'String',filename);
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
filenames=get(handles.varbox,'String');
selected_filenames=get(handles.varbox,'Value');
filenames=filenames(selected_filenames);
outputdir=get(handles.outputedit,'String');
update_status=get(handles.varbox,'UserData');
update_status.function(update_status.handles,'*** Importing LW4 MAT data.',1,0);
%dimlist
dim_labels=get(handles.dim1_popup,'String');
dimlist{1}=dim_labels{get(handles.dim1_popup,'Value')};
dim_labels=get(handles.dim2_popup,'String');
dimlist{2}=dim_labels{get(handles.dim2_popup,'Value')};
dim_labels=get(handles.dim3_popup,'String');
dimlist{3}=dim_labels{get(handles.dim3_popup,'Value')};
dim_labels=get(handles.dim4_popup,'String');
dimlist{4}=dim_labels{get(handles.dim4_popup,'Value')};
%sampling_rate
sampling_rate=str2num(get(handles.samplingrate_edit,'String'));
xstart=str2num(get(handles.xstart_edit,'String'));
%xstart
for filepos=1:length(filenames);
    update_status.function(update_status.handles,['Importing : ' filenames{filepos}],1,0);
    %load var
    matvar=load_selected_workspace_var(filenames{filepos});
    [header,data]=LW_importMATvar(matvar,sampling_rate,xstart,dimlist(1:ndims(matvar)));
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



function samplingrate_edit_Callback(hObject, eventdata, handles)
% hObject    handle to samplingrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function samplingrate_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to samplingrate_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xstart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function xstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on selection change in dim1_popup.
function dim1_popup_Callback(hObject, eventdata, handles)
% hObject    handle to dim1_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function dim1_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim1_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dim2_popup.
function dim2_popup_Callback(hObject, eventdata, handles)
% hObject    handle to dim2_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dim2_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim2_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dim4_popup.
function dim4_popup_Callback(hObject, eventdata, handles)
% hObject    handle to dim4_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function dim4_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim4_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function dim3_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dim3_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in dim3_popup.
function dim3_popup_Callback(hObject, eventdata, handles)
% hObject    handle to dim3_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
