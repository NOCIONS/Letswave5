function varargout = GLW_MLR(varargin)
% GLW_MLR MATLAB code for GLW_butterhigh.fig
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
                   'gui_OpeningFcn', @GLW_MLR_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_MLR_OutputFcn, ...
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
function GLW_MLR_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_averageepochs (see VARARGIN)
% Choose default command line output for GLW_averageepochs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
inputfiles=varargin{2};
set(handles.filebox,'String',inputfiles);
%load header of first inputfile
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
%channelstring
for i=1:header.datasize(2);
    channelstring{i}=header.chanlocs(i).labels;
end;
set(handles.chanbox,'String',channelstring);
set(handles.uitable,'Data',[]);





% --- Outputs from this function are returned to the command line.
function varargout = GLW_MLR_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Single-trial MLR.',1,0);
%channel_idx
channel_idx=get(handles.chanbox,'Value');
%time_interval
time_interval=[str2num(get(handles.timestartedit,'String')) str2num(get(handles.timeendedit,'String'))];
%num_peak
peakdata=get(handles.uitable,'Data');
num_peak=size(peakdata,1);
%peak_interval
peak_interval=[];
for i=1:num_peak;
    peak_interval(i,1)=peakdata{i,1};
    peak_interval(i,2)=peakdata{i,2};
end;
%direction
direction=[];
for i=1:num_peak;
    direction{i}=peakdata{i,3};
end;
%loop through files
regressors=[];
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Applying MLR.',1,0);    
    ST=LW_MLR(header,data,channel_idx,time_interval,num_peak,peak_interval,direction);
    %ST
    [header,data,regressor_header,regressor_data]=LW_ST2LW5(header,data,ST);
    regressors(filepos).regressor_header=regressor_header;
    regressors(filepos).regressor_data=regressor_data;
    regressors(filepos).ST=ST;
    %save header
    LW_save_header(inputfiles{filepos},[],header);
end;
set(handles.saveLW5button,'UserData',regressors);
set(handles.saveMATbutton,'Enable','on');
set(handles.saveLW5button,'Enable','on');
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on selection change in chanbox.
function chanbox_Callback(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function chanbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in saveMATbutton.
function saveMATbutton_Callback(hObject, eventdata, handles)
% hObject    handle to saveMATbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
regressors=get(handles.saveLW5button,'UserData');
inputfiles=get(handles.filebox,'String');
for i=1:length(inputfiles);
    ST(i).data=regressors(i).ST;
    ST(i).filename=inputfiles{i};
end;
uisave('ST');




% --- Executes on button press in saveLW5button.
function saveLW5button_Callback(hObject, eventdata, handles)
% hObject    handle to saveLW5button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Saving regressors.',0,1);
regressors=get(handles.saveLW5button,'UserData');
inputfiles=get(handles.filebox,'String');
for filepos=1:length(inputfiles);
    header=regressors(filepos).regressor_header;
    data=regressors(filepos).regressor_data;
    %save headers
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,'regressors ',n,'.lw5'];
    save(st,'-MAT','header');
    %save data
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,'regressors ',n,'.mat'];
    save(st,'-MAT','data');
end;




function timestartedit_Callback(hObject, eventdata, handles)
% hObject    handle to timestartedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function timestartedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timestartedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function timeendedit_Callback(hObject, eventdata, handles)
% hObject    handle to timeendedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function timeendedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to timeendedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function peakstartedit_Callback(hObject, eventdata, handles)
% hObject    handle to peakstartedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function peakstartedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakstartedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function peakendedit_Callback(hObject, eventdata, handles)
% hObject    handle to peakendedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function peakendedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakendedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in polaritypopup.
function polaritypopup_Callback(hObject, eventdata, handles)
% hObject    handle to polaritypopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function polaritypopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to polaritypopup (see GCBO)
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




% --- Executes on button press in addpeakbtn.
function addpeakbtn_Callback(hObject, eventdata, handles)
% hObject    handle to addpeakbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
data=get(handles.uitable,'Data');
st=get(handles.polaritypopup,'String');
if isempty(data);
    rowpos=1;
else
    rowpos=size(data,1)+1;
end;
data{rowpos,1}=str2num(get(handles.peakstartedit,'String'));
data{rowpos,2}=str2num(get(handles.peakendedit,'String'));
data{rowpos,3}=st{get(handles.polaritypopup,'Value')};
set(handles.uitable,'Data',data);



% --- Executes on button press in clearpeaksbtn.
function clearpeaksbtn_Callback(hObject, eventdata, handles)
% hObject    handle to clearpeaksbtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable,'Data',[]);
