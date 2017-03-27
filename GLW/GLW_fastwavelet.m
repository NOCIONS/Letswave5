function varargout = GLW_fastwavelet(varargin)
% GLW_FASTWAVELET MATLAB code for GLW_fastwavelet.fig
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
                   'gui_OpeningFcn', @GLW_fastwavelet_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fastwavelet_OutputFcn, ...
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




% --- Executes just before GLW_fastwavelet is made visible.
function GLW_fastwavelet_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fastwavelet (see VARARGIN)
% Choose default command line output for GLW_fastwavelet
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





% --- Outputs from this function are returned to the command line.
function varargout = GLW_fastwavelet_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Fast Continuous Wavelet Transform (CWT).',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %frequency parameters
    ystart=str2num(get(handles.lofreqedit,'String'));
    ysize=round(str2num(get(handles.numlinesedit,'String')));
    yend=str2num(get(handles.hifreqedit,'String'));
    ystep=(yend-ystart)/ (ysize-1);
    %mother parameters
    mothertype={'morlet' 'hanning'};
    type=mothertype{get(handles.motherpopup,'Value')};
    periods=str2num(get(handles.motherfreqedit,'String'));
    stdev=str2num(get(handles.motherspreadedit,'String'));
    mothersize=round(str2num(get(handles.mothersizeedit,'String')));
    %postprocess
    postprocesslist={'amplitude' 'power' 'phase' 'real' 'imag'};
    postprocess=postprocesslist{get(handles.postprocesspopup,'Value')};
    %baseline
    baselinelist={'none' 'subtract' 'percent'};
    baseline=baselinelist{get(handles.baselinepopup,'Value')};
    if strcmpi(baseline,'none');
        baseline_start=0;
        baseline_end=0;
    else
        baseline_start=str2num(get(handles.bl1edit,'String'));
        baseline_end=str2num(get(handles.bl2edit,'String'));
    end;
    %output
    if get(handles.averagechk,'Value')==1;
        output='average';
    else
        output='single';
    end;
    %process
    update_status.function(update_status.handles,'Computing Fast CWT. This may take a while!',1,0);
    %[header,data]=LW_fastwavelet_BU(header,data,ystart,ystep,ysize,type,periods,stdev,mothersize,postprocess,baseline,baseline_start,baseline_end,output);
    [header,data]=LW_fastwavelet(header,data,ystart,ystep,ysize,type,periods,stdev,mothersize,postprocess,baseline,baseline_start,baseline_end,output);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




function yedit1_Callback(hObject, eventdata, handles)
% hObject    handle to yedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function yedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yedit2_Callback(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function yedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit2_Callback(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function zedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit1_Callback(hObject, eventdata, handles)
% hObject    handle to zedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function zedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit1_Callback(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function xedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit2_Callback(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function xedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in zcheck.
function zcheck_Callback(hObject, eventdata, handles)
% hObject    handle to zcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in ycheck.
function ycheck_Callback(hObject, eventdata, handles)
% hObject    handle to ycheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in xcheck.
function xcheck_Callback(hObject, eventdata, handles)
% hObject    handle to xcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in motherpopup.
function motherpopup_Callback(hObject, eventdata, handles)
% hObject    handle to motherpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns motherpopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from motherpopup


% --- Executes during object creation, after setting all properties.
function motherpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motherpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function motherfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to motherfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of motherfreqedit as text
%        str2double(get(hObject,'String')) returns contents of motherfreqedit as a double


% --- Executes during object creation, after setting all properties.
function motherfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motherfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function motherspreadedit_Callback(hObject, eventdata, handles)
% hObject    handle to motherspreadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of motherspreadedit as text
%        str2double(get(hObject,'String')) returns contents of motherspreadedit as a double


% --- Executes during object creation, after setting all properties.
function motherspreadedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to motherspreadedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function mothersizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to mothersizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mothersizeedit as text
%        str2double(get(hObject,'String')) returns contents of mothersizeedit as a double


% --- Executes during object creation, after setting all properties.
function mothersizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mothersizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in postprocesspopup.
function postprocesspopup_Callback(hObject, eventdata, handles)
% hObject    handle to postprocesspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns postprocesspopup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from postprocesspopup


% --- Executes during object creation, after setting all properties.
function postprocesspopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to postprocesspopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in averagechk.
function averagechk_Callback(hObject, eventdata, handles)
% hObject    handle to averagechk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of averagechk



function numlinesedit_Callback(hObject, eventdata, handles)
% hObject    handle to numlinesedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numlinesedit as text
%        str2double(get(hObject,'String')) returns contents of numlinesedit as a double


% --- Executes during object creation, after setting all properties.
function numlinesedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numlinesedit (see GCBO)
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
