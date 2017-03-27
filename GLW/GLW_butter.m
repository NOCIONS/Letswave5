function varargout = GLW_butter(varargin)
% GLW_butter MATLAB code for GLW_butter.fig
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
                   'gui_OpeningFcn', @GLW_butter_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_butter_OutputFcn, ...
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




% --- Executes just before GLW_butter is made visible.
function GLW_butter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_butter (see VARARGIN)
% Choose default command line output for GLW_butter
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_butter_OutputFcn(hObject, eventdata, handles) 
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
%locutoff1,locutoff2,hicutoff1,hicutoff2,bandpass,bandstop
locutoff=str2num(get(handles.locutoff,'String'));
hicutoff=str2num(get(handles.hicutoff,'String'));
order=str2num(get(handles.order,'String'));
types=get(handles.typeList,'String');
typeNr = get(handles.typeList,'Value');
typeFilt = types{typeNr};
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Butterworth filter.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    [header,data]=LW_butter(header,data,locutoff,hicutoff,order,typeFilt);
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




% --- Executes on selection change in eventmenu.
function eventmenu_Callback(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function eventmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function locutoff_Callback(hObject, eventdata, handles)
% hObject    handle to locutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function locutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locutoff (see GCBO)
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




function endedit_Callback(hObject, eventdata, handles)
% hObject    handle to endedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function endedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endedit (see GCBO)
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



function sizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function sizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in epochendchk.
function epochendchk_Callback(hObject, eventdata, handles)
% hObject    handle to epochendchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.epochendchk,'Value')==1;
    set(handles.epochsizechk,'Value',0);
else
    set(handles.epochsizechk,'Value',1);
end;


% --- Executes on button press in epochsizechk.
function epochsizechk_Callback(hObject, eventdata, handles)
% hObject    handle to epochsizechk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.epochsizechk,'Value')==1;
    set(handles.epochendchk,'Value',0);
else
    set(handles.epochendchk,'Value',1);
end;


% --- Executes on button press in locheck.
function locheck_Callback(hObject, eventdata, handles)
% hObject    handle to locheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




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




% --- Executes on button press in hicheck.
function hicheck_Callback(hObject, eventdata, handles)
% hObject    handle to hicheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




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



function locutoff2edit_Callback(hObject, eventdata, handles)
% hObject    handle to locutoff2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function locutoff2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to locutoff2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hicutoff_Callback(hObject, eventdata, handles)
% hObject    handle to hicutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hicutoff_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hicutoff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hicutoff2edit_Callback(hObject, eventdata, handles)
% hObject    handle to hicutoff2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hicutoff2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hicutoff2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function order_Callback(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function order_CreateFcn(hObject, eventdata, handles)
% hObject    handle to order (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function passbandedit_Callback(hObject, eventdata, handles)
% hObject    handle to passbandedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function passbandedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to passbandedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typeList.
function typeList_Callback(hObject, eventdata, handles)
% hObject    handle to typeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns typeList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from typeList
types=get(handles.typeList,'String');
typeNr = get(handles.typeList,'Value');
typeFilt = types{typeNr};
switch typeFilt
    case 'lowpass'
        set(handles.locutoffText,'Visible', 'off');
        set(handles.hicutoffText,'Visible', 'on');
        set(handles.locutoff,'Visible', 'off');
        set(handles.hicutoff,'Visible', 'on');

    case 'highpass'
        set(handles.locutoffText,'Visible', 'on');
        set(handles.hicutoffText,'Visible', 'off');
        set(handles.locutoff,'Visible', 'on');
        set(handles.hicutoff,'Visible', 'off');

    case 'bandpass'
        set(handles.locutoffText,'Visible', 'on');
        set(handles.hicutoffText,'Visible', 'on');
        set(handles.locutoff,'Visible', 'on');
        set(handles.hicutoff,'Visible', 'on');

    case 'notch'
        set(handles.locutoffText,'Visible', 'on');
        set(handles.hicutoffText,'Visible', 'on');
        set(handles.locutoff,'Visible', 'on');
        set(handles.hicutoff,'Visible', 'on');

end



% --- Executes during object creation, after setting all properties.
function typeList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typeList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_showfilter.
function pushbutton_showfilter_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_showfilter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%load header of first file
inputfiles=get(handles.filebox,'String');
filepos = 1;
[p,n,e]=fileparts(inputfiles{filepos});
st=[p,filesep,n,'.lw5'];
load(st,'-MAT');

Fs = 1/header.xstep;
fnyquist = Fs/2;

lowcut=str2num(get(handles.locutoff,'String'));
highcut=str2num(get(handles.hicutoff,'String'));
filtOrder=str2num(get(handles.order,'String'));
types=get(handles.typeList,'String');
typeNr = get(handles.typeList,'Value');
typeFilt = lower(types{typeNr});



%dividing filter order by 2 because of the forward-reverse filtering used
%(filtfilt).
if mod(filtOrder,2);
    warning('LW_butter: Even number for filter order is needed\n  -> converting order from %i to %i',filtOrder,filtOrder-1);
    filtOrder = filtOrder-1;
end


switch typeFilt
    case 'lowpass'
        [b,a]   = butter(filtOrder,highcut/fnyquist,'low');
        lowcut = [];
    case 'highpass'
        [b,a]   = butter(filtOrder,lowcut/fnyquist, 'high');
        highcut = [];
    case 'bandpass'
        [bLow,aLow]   = butter(filtOrder,highcut/fnyquist,'low');
        [bHigh,aHigh]   = butter(filtOrder,lowcut/fnyquist, 'high');
        b = [bLow;bHigh];
        a = [aLow;aHigh];
        b = conv(b(1,:),b(2,:));
        a = conv(a(1,:),a(2,:));
        
    case 'notch'
        [b,a]   = butter(filtOrder,[lowcut/fnyquist highcut/fnyquist] , 'stop');
end

figure('color',[1 1 1]);
freqz(b,a,fnyquist);
ax = findall(gcf, 'Type', 'axes');
set(ax, 'XScale', 'log');
title(sprintf('%s filter - [%g %g] Hz - Order: %i',typeFilt,lowcut,highcut,filtOrder));
% set(ax, 'XLim', [0 fnyquist]);
