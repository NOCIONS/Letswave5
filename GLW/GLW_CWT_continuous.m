function varargout = GLW_CWT_continuous(varargin)
% GLW_CWT_continuous MATLAB code for GLW_CWT_continuous.fig
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
                   'gui_OpeningFcn', @GLW_CWT_continuous_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_CWT_continuous_OutputFcn, ...
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




% --- Executes just before GLW_CWT_continuous is made visible.
function GLW_CWT_continuous_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_CWT_continuous (see VARARGIN)
% Choose default command line output for GLW_CWT_continuous
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
% Added for continuous
%Add events
%Load header
filenames=get(handles.filebox,'String');
header=LW_load_header(filenames{1});
%
eventstring=searchevents(handles,header);
set(handles.event_listbox,'String',eventstring);





function eventstring=searchevents(handles,header);
eventpos3=1;
eventstring={};
for eventpos=1:length(header.events);
    if isnumeric(header.events(eventpos).code)
        code=num2str(header.events(eventpos).code);
    else
        code=header.events(eventpos).code;
    end;
    found=0;
    if length(eventstring)>0;
        for eventpos2=1:length(eventstring);
            if strcmpi(eventstring{eventpos2},code);
                found=1;
            end;
        end;
    end;
    if found==0;
        eventstring{eventpos3}=code;
        eventpos3=eventpos3+1;
    end;
end;







% --- Outputs from this function are returned to the command line.
function varargout = GLW_CWT_continuous_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Continuous Wavelet Transform (CWT) (continuous data).',1,0);
%Setup CWT
%Wavelet Name (wname)
wname=get(handles.waveletedit,'String');
update_status.function(update_status.handles,['Wavelet name : ',wname],1,0);
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
%Segment epochs?
segment=get(handles.segment_chk,'Value');
if segment==1;
    eventlist=get(handles.event_listbox,'String');
    eventcode=eventlist(get(handles.event_listbox,'Value'));
    disp(['Event code : ' eventcode]);
    xstart=str2num(get(handles.xstart_edit,'String'));
    xend=str2num(get(handles.xend_edit,'String'));
    update_status.function(update_status.handles,['X xtart : ' num2str(xstart) ' end : ' num2str(xend)],1,0);
end;
%Average epochs?
average=get(handles.averagecheck,'Value');
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing CWT. This may take a while!',1,0);
    [header,data]=LW_CWT(header,data,freqstart,freqstep,freqsize,wname,postproc,verbose);
    size(data)
    header.datasize
    %segment if checked
    if segment==1;
        xsize=fix((xend-xstart)/header.xstep)+1;
        disp(['X size : ' num2str(xsize)]);
        [header,data]=LW_segmentation2(header,data,eventcode,xstart,xsize);
        %average if checked
        if average==1;
            update_status.function(update_status.handles,'Averaging epochs.',1,0);
            [header,data]=LW_averageepochs(header,data,'average');
        end;
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


% --- Executes on button press in segment_chk.
function segment_chk_Callback(hObject, eventdata, handles)
% hObject    handle to segment_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of segment_chk


% --- Executes on selection change in event_listbox.
function event_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to event_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns event_listbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from event_listbox


% --- Executes during object creation, after setting all properties.
function event_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to event_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xstart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xstart_edit as text
%        str2double(get(hObject,'String')) returns contents of xstart_edit as a double


% --- Executes during object creation, after setting all properties.
function xstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xend_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xend_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xend_edit as text
%        str2double(get(hObject,'String')) returns contents of xend_edit as a double


% --- Executes during object creation, after setting all properties.
function xend_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xend_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
