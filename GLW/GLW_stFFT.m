function varargout = GLW_stFFT(varargin)
% GLW_stFFT MATLAB code for GLW_stFFT.fig
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
                   'gui_OpeningFcn', @GLW_stFFT_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_stFFT_OutputFcn, ...
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





% --- Executes just before GLW_stFFT is made visible.
function GLW_stFFT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_stFFT (see VARARGIN)
% Choose default command line output for GLW_stFFT
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});





% --- Outputs from this function are returned to the command line.
function varargout = GLW_stFFT_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Short term FFT.',1,0);
%Setup stFFT
%Wavelet Name (wname)
%Frequency lines (freqstart,freqstep,freqsize)
freqstart=str2num(get(handles.lofreqedit,'String'));
freqsize=fix(str2num(get(handles.numfreqedit,'String')));
freqend=str2num(get(handles.hifreqedit,'String'));
freqstep=(freqend-freqstart)/freqsize;
%PostProc (none,abs,square,angle)
postproclist={'abs','square','angle','complex'};
postproc=postproclist{get(handles.outputmenu,'Value')};
update_status.function(update_status.handles,['Post-processing : ',postproc],1,0);
%Average epochs? (output)
if get(handles.averagecheck,'Value')==1;
    output='average';
else
    output='single';
end;
%Baseline
baselinelist={'none' 'subtract' 'percent'};
baseline=baselinelist{get(handles.baselinepopup,'Value')};
if strcmpi(baseline,'none');
    baseline_start=0;
    baseline_end=0;
else
    baseline_start=str2num(get(handles.bl1edit,'String'));
    baseline_end=str2num(get(handles.bl2edit,'String'));
end;
%dxstep
dxstep=fix(str2num(get(handles.dxedit,'String')));
%window
window=str2num(get(handles.windowedit,'String'));
%loop through files
for filepos=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing ST-FFT. This may take a while!',1,0);
    [header,data]=LW_stFFT(header,data,freqstart,freqstep,freqsize,window,dxstep,postproc,output,baseline,baseline_start,baseline_end);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in waveletmenu.
function waveletmenu_Callback(hObject, eventdata, handles)
% hObject    handle to waveletmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waveletlist={'cmor1-1.5','cmor1-1','cmor1-0.5','cmor1-0.1','fbsp1-1-1.5','fbsp1-1-1','fbsp1-1-0.5','fbsp2-1-1','fbsp2-1-0.5','fbsp2-1-0.1','shan1-1.5','shan1-1','shan1-0.5','shan1-0.1','shan2-3','cgau1','cgau2','cgau3','cgau4','cgau5'};
set(handles.waveletedit,'String',waveletlist{get(handles.waveletmenu,'Value')});



% --- Executes during object creation, after setting all properties.
function waveletmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveletmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in halfcheckbox.
function halfcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to halfcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function waveletedit_Callback(hObject, eventdata, handles)
% hObject    handle to waveletedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of waveletedit as text
%        str2double(get(hObject,'String')) returns contents of waveletedit as a double


% --- Executes during object creation, after setting all properties.
function waveletedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveletedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lofreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to lofreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lofreqedit as text
%        str2double(get(hObject,'String')) returns contents of lofreqedit as a double


% --- Executes during object creation, after setting all properties.
function lofreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lofreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function hifreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to hifreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of hifreqedit as text
%        str2double(get(hObject,'String')) returns contents of hifreqedit as a double


% --- Executes during object creation, after setting all properties.
function hifreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hifreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to numfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numfreqedit as text
%        str2double(get(hObject,'String')) returns contents of numfreqedit as a double


% --- Executes during object creation, after setting all properties.
function numfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in outputmenu.
function outputmenu_Callback(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns outputmenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from outputmenu


% --- Executes during object creation, after setting all properties.
function outputmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in averagecheck.
function averagecheck_Callback(hObject, eventdata, handles)
% hObject    handle to averagecheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averagecheck



function windowedit_Callback(hObject, eventdata, handles)
% hObject    handle to windowedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of windowedit as text
%        str2double(get(hObject,'String')) returns contents of windowedit as a double


% --- Executes during object creation, after setting all properties.
function windowedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to windowedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dxedit_Callback(hObject, eventdata, handles)
% hObject    handle to dxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dxedit as text
%        str2double(get(hObject,'String')) returns contents of dxedit as a double


% --- Executes during object creation, after setting all properties.
function dxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in baselinepopup.
function baselinepopup_Callback(hObject, eventdata, handles)
% hObject    handle to baselinepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns baselinepopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from baselinepopup


% --- Executes during object creation, after setting all properties.
function baselinepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baselinepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bl1edit_Callback(hObject, eventdata, handles)
% hObject    handle to bl1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bl1edit as text
%        str2double(get(hObject,'String')) returns contents of bl1edit as a double


% --- Executes during object creation, after setting all properties.
function bl1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bl1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bl2edit_Callback(hObject, eventdata, handles)
% hObject    handle to bl2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bl2edit as text
%        str2double(get(hObject,'String')) returns contents of bl2edit as a double


% --- Executes during object creation, after setting all properties.
function bl2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bl2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
