function varargout = GLW_ica_runica(varargin)
% GLW_ICA_RUNICA MATLAB code for GLW_ica_runica.fig





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ica_runica_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ica_runica_OutputFcn, ...
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





% --- Executes just before GLW_ica_runica is made visible.
function GLW_ica_runica_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ica_runica (see VARARGIN)
% Choose default command line output for GLW_ica_runica
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%set radiobuttons
set(handles.radiobutton1,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);
%set numedit
set(handles.numedit,'String','10');





% --- Outputs from this function are returned to the command line.
function varargout = GLW_ica_runica_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Calculating ICA matrix (runica). This can take a while!',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %number of ICs
    %square matrix
    if get(handles.radiobutton1,'Value')==1;
        numIC=header.datasize(2);
        update_status.function(update_status.handles,'Square mixing matrix.',1,0);
    end;
    %user-defined matrix
    if get(handles.radiobutton2,'Value')==1;
        numIC=fix(str2num(get(handles.numedit,'String')));
        update_status.function(update_status.handles,'User-defined number of ICs.',1,0);
    end;
    %probabilistic ICA
    if get(handles.radiobutton3,'Value')==1;
        %LAP (Laplace approximation)
        %BIC (Bayesian Information Criterion)
        %RRN (Rajan & Rayner)
        %AIC
        %MDL
        methodstring={'lap','bic','rrn','aic','mdl'};
        methodindex=get(handles.popupmethod,'Value');
        numIC=LW_probdim(header,data,methodstring{methodindex});
        numIC=round(numIC*(str2num(get(handles.percentedit,'String'))/100));
        update_status.function(update_status.handles,'Probabilistic ICA.',1,0);
    end;
    update_status.function(update_status.handles,['Number of ICs : ',num2str(numIC)],1,0);
    %filename of ICA matrix file header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,get(handles.prefixtext,'String'),' ',n,'.lw5'];
    %assign ICA filename to original data file
    header=LW_ica_assignfile(header,st);
    %save header of original data file
    LW_save_header(inputfiles{filepos},[],header);
    %process
    update_status.function(update_status.handles,'Starting ICA computation. Check command window for progress.',1,0);
    [header,data]=LW_ica_runica(header,data,numIC);
    %save header data (MAT)
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1,'Value',1);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',0);




% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',1);
set(handles.radiobutton3,'Value',0);




% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton1,'Value',0);
set(handles.radiobutton2,'Value',0);
set(handles.radiobutton3,'Value',1);




function numedit_Callback(hObject, eventdata, handles)
% hObject    handle to numedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function numedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmethod.
function popupmethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function popupmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function percentedit_Callback(hObject, eventdata, handles)
% hObject    handle to percentedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function percentedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percentedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in checkepochsbtn.
function checkepochsbtn_Callback(hObject, eventdata, handles)
% hObject    handle to checkepochsbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
disp('*** Starting.');
%loop through files
for filepos=1:length(inputfiles);
    %load header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.lw5'];
    disp(['loading ',st]);
    load(st,'-MAT');
    %load data
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.mat'];
    load(st,'-MAT');
    disp('*** Checking epochs');
    LW_checkepochs(header,data);
end;
disp('*** Finished.');
