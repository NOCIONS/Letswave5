function varargout = GLW_selectepochs_events2(varargin)
% GLW_selectepochs_events2 MATLAB code for GLW_selectepochs_events2.fig
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
                   'gui_OpeningFcn', @GLW_selectepochs_events2_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_selectepochs_events2_OutputFcn, ...
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




% --- Executes just before GLW_selectepochs_events2 is made visible.
function GLW_selectepochs_events2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_selectepochs_events2 (see VARARGIN)
% Choose default command line output for GLW_selectepochs_events2
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
st=varargin{2};
set(handles.filebox,'String',st);
%inputfiles
inputfiles=get(handles.filebox,'String');
%fill eventcodepopup
eventlist={};
for filepos=1:length(inputfiles);
    header=LW_load_header(inputfiles{filepos});
    for i=1:length(header.events);
        if isempty(find(strcmpi(eventlist,header.events(i).code)));
            eventlist=[eventlist header.events(i).code];
        end;
    end;
end;
set(handles.eventcodepopup,'String',eventlist);
set(handles.eventcodepopup,'Value',1);
%lat1edit,lat2edit
set(handles.lat1edit,'String',num2str(header.xstart));
set(handles.lat2edit,'String',num2str(header.xstart+((header.datasize(6)-1)*header.xstep)));
    
    




% --- Outputs from this function are returned to the command line.
function varargout = GLW_selectepochs_events2_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Select epochs based on events.',1,0);
%latency1,latency2
latency1=str2num(get(handles.lat1edit,'String'));
latency2=str2num(get(handles.lat2edit,'String'));
%eventcode
eventlist=get(handles.eventcodepopup,'String');
eventcode=eventlist{get(handles.eventcodepopup,'Value')};
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %selected epochs
    selectedepochs=LW_findepochs_events(header,[],eventcode,latency1,latency2);
    update_status.function(update_status.handles,['Selected ' num2str(length(selectedepochs)) ' epochs.'],1,0);
    %selected channels
    selectedchannels=1:1:header.datasize(2);
    %selected indexes
    selectedindexes=1:1:header.datasize(3);
    %process
    update_status.function(update_status.handles,'Parsing epochs.',1,0);
    [header,data]=LW_selectsignals(header,data,selectedepochs,selectedchannels,selectedindexes);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on button press in processbutton2.
function processbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Select epochs based on events.',1,0);
%latency1,latency2
latency1=str2num(get(handles.lat1edit,'String'));
latency2=str2num(get(handles.lat2edit,'String'));
%eventcode
eventlist=get(handles.eventcodepopup,'String');
eventcode=eventlist{get(handles.eventcodepopup,'Value')};
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    %load header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.lw5'];
    load(st,'-MAT');
    %load data
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.mat'];
    load(st,'-MAT');
    %rejected epochs
    rejectedepochs=LW_findepochs_events(header,[],eventcode,latency1,latency2);
    selectedepochs=1:1:header.datasize(1);
    selectedepochs(rejectedepochs)=[];
    update_status.function(update_status.handles,['Selecting ' num2str(length(selectedepochs)) ' epochs.'],1,0);
    %selected channels
    selectedchannels=1:1:header.datasize(2);
    %selected indexes
    selectedindexes=1:1:header.datasize(3);
    %process
    update_status.function(update_status.handles,'Parsing epochs.',1,0);
    [header,data]=LW_selectsignals(header,data,selectedepochs,selectedchannels,selectedindexes);
    %save header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,get(handles.prefixtext,'String'),' ',n,'.lw5'];
    save(st,'-MAT','header');
    %save data
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,get(handles.prefixtext,'String'),' ',n,'.mat'];
    save(st,'-MAT','data');
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes during object creation, after setting all properties.
function lat1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lat1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function lat2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lat2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function eventcodepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventcodepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in eventcodepopup.
function eventcodepopup_Callback(hObject, eventdata, handles)
% hObject    handle to eventcodepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lat1edit_Callback(hObject, eventdata, handles)
% hObject    handle to lat1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lat2edit_Callback(hObject, eventdata, handles)
% hObject    handle to lat2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function prefixtext_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
