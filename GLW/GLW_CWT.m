function varargout = GLW_CWT(varargin)
% GLW_CWT MATLAB code for GLW_CWT.fig
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
                   'gui_OpeningFcn', @GLW_CWT_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_CWT_OutputFcn, ...
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




% --- Executes just before GLW_CWT is made visible.
function GLW_CWT_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_CWT (see VARARGIN)
% Choose default command line output for GLW_CWT
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
% Update waveletedit
waveletmenu_Callback(hObject, eventdata, handles);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_CWT_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Continuous Wavelet Transform (CWT).',1,0);
%Setup CWT
%Wavelet Name (wname)
wname=get(handles.waveletedit,'String');
update_status.function(update_status.handles,['Mother wavelet : ',wname],1,0);
%Frequency lines (freqstart,freqstep,freqsize)
freqstart=str2num(get(handles.lofreqedit,'String'));
freqsize=fix(str2num(get(handles.numfreqedit,'String')));
freqend=str2num(get(handles.hifreqedit,'String'));
freqstep=(freqend-freqstart)/freqsize;
%PostProc (none,abs,square,angle)
postproclist={'abs','square','angle','complex'};
postproc=postproclist{get(handles.outputmenu,'Value')};
update_status.function(update_status.handles,['Post-processing : ',postproc],1,0);
%Verbose
verbose='off';
%Average epochs?
average=get(handles.averagecheck,'Value');
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing CWT. This may take a while!',1,0);
    [header,data]=LW_CWT(header,data,freqstart,freqstep,freqsize,wname,postproc,verbose);
    %size(data)
    %header.datasize
    %average if checked
    if average==1;
        update_status.function(update_status.handles,'Averaging epochs.',1,0);
        [header,data]=LW_averageepochs(header,data,'average');
    end;
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




% --- Executes during object creation, after setting all properties.
function waveletedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to waveletedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lofreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to lofreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function lofreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lofreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hifreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to hifreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hifreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hifreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function numfreqedit_Callback(hObject, eventdata, handles)
% hObject    handle to numfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function numfreqedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numfreqedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in outputmenu.
function outputmenu_Callback(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function outputmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in averagecheck.
function averagecheck_Callback(hObject, eventdata, handles)
% hObject    handle to averagecheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
