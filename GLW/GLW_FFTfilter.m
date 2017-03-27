function varargout = GLW_FFTfilter(varargin)
% GLW_FFTfilter MATLAB code for GLW_FFTfilter.fig
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
                   'gui_OpeningFcn', @GLW_FFTfilter_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_FFTfilter_OutputFcn, ...
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





% --- Executes just before GLW_FFTfilter is made visible.
function GLW_FFTfilter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_FFTfilter (see VARARGIN)
% Choose default command line output for GLW_FFTfilter
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_FFTfilter_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** FFT filter.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %store header in headertime for iFFT
    headertime=header;
    %FFT
    update_status.function(update_status.handles,'Computing FFT.',1,0);
    [header,data]=LW_FFT(header,data,'complex',0,'no');
    %setup filter vector
    index=get(handles.filtermenu,'Value');
    if index==1;
        %band-pass filter
        update_status.function(update_status.handles,'Bandpass filtering.',1,0);
        locutoff=str2num(get(handles.loedit,'String'));
        locutoffwidth=str2num(get(handles.lowidthedit,'String'));
        hicutoff=str2num(get(handles.hiedit,'String'));
        hicutoffwidth=str2num(get(handles.hiwidthedit,'String'));
        vector=LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth);
    end;
    if index==2;
        %low-pass filter
        update_status.function(update_status.handles,'Lowpass filtering.',1,0);
        locutoff=0;
        locutoffwidth=0;
        hicutoff=str2num(get(handles.hiedit,'String'));
        hicutoffwidth=str2num(get(handles.hiwidthedit,'String'));
        vector=LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth);
    end;
    if index==3;
        %high-pass filter
        update_status.function(update_status.handles,'Highpass filtering.',1,0);
        locutoff=str2num(get(handles.loedit,'String'));
        locutoffwidth=str2num(get(handles.lowidthedit,'String'));
        hicutoff=0;
        hicutoffwidth=0;
        vector=LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth);
    end;
    if index==4;
        %notch filter
        update_status.function(update_status.handles,'Notch filtering.',1,0);
        locutoff=str2num(get(handles.loedit,'String'));
        locutoffwidth=str2num(get(handles.lowidthedit,'String'));
        hicutoff=str2num(get(handles.hiedit,'String'));
        hicutoffwidth=str2num(get(handles.hiwidthedit,'String'));
        vector=LW_buildFFTbandpass(header,locutoff,hicutoff,locutoffwidth,hicutoffwidth);
        %invert vector
        vector=(vector-1)*-1;
    end;
    %filter
    update_status.function(update_status.handles,'Filtering FFT product.',1,0);
    [header,data]=LW_multiplyvector(header,data,vector);
    %iFFT
    update_status.function(update_status.handles,'Computing inverse FFT.',1,0);
    [header,data]=LW_iFFT(header,data,headertime,0);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




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




% --- Executes on button press in halfcheckbox.
function halfcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to halfcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in filtermenu.
function filtermenu_Callback(hObject, eventdata, handles)
% hObject    handle to filtermenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.filtermenu,'Value');
%band-pass filter
if index==1;
    set(handles.lotext,'String','Remove frequencies below :');
    set(handles.hitext,'String','Remove frequencies above :');
    set(handles.lotext,'Visible','on');
    set(handles.loedit,'Visible','on');
    set(handles.lowidthtext,'Visible','on');
    set(handles.lowidthedit,'Visible','on');
    set(handles.hitext,'Visible','on');
    set(handles.hiedit,'Visible','on');
    set(handles.hiwidthtext,'Visible','on');
    set(handles.hiwidthedit,'Visible','on');
end;
%low-pass filter
if index==2;
    set(handles.lotext,'String','Remove frequencies below :');
    set(handles.hitext,'String','Remove frequencies above :');
    set(handles.lotext,'Visible','off');
    set(handles.loedit,'Visible','off');
    set(handles.lowidthtext,'Visible','off');
    set(handles.lowidthedit,'Visible','off');
    set(handles.hitext,'Visible','on');
    set(handles.hiedit,'Visible','on');
    set(handles.hiwidthtext,'Visible','on');
    set(handles.hiwidthedit,'Visible','on');
end;
%high-pass filter
if index==3;
    set(handles.lotext,'String','Remove frequencies below :');
    set(handles.hitext,'String','Remove frequencies above :');
    set(handles.lotext,'Visible','on');
    set(handles.loedit,'Visible','on');
    set(handles.lowidthtext,'Visible','on');
    set(handles.lowidthedit,'Visible','on');
    set(handles.hitext,'Visible','off');
    set(handles.hiedit,'Visible','off');
    set(handles.hiwidthtext,'Visible','off');
    set(handles.hiwidthedit,'Visible','off');
end;
%notch filter
if index==4;
    set(handles.lotext,'String','Keep frequencies below :');
    set(handles.hitext,'String','Keep frequencies above :');
    set(handles.lotext,'Visible','on');
    set(handles.loedit,'Visible','on');
    set(handles.lowidthtext,'Visible','on');
    set(handles.lowidthedit,'Visible','on');
    set(handles.hitext,'Visible','on');
    set(handles.hiedit,'Visible','on');
    set(handles.hiwidthtext,'Visible','on');
    set(handles.hiwidthedit,'Visible','on');
end;




% --- Executes during object creation, after setting all properties.
function filtermenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filtermenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function loedit_Callback(hObject, eventdata, handles)
% hObject    handle to loedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function loedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to loedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function lowidthedit_Callback(hObject, eventdata, handles)
% hObject    handle to lowidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function lowidthedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hiedit_Callback(hObject, eventdata, handles)
% hObject    handle to hiedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hiedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hiedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hiwidthedit_Callback(hObject, eventdata, handles)
% hObject    handle to hiwidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hiwidthedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hiwidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
