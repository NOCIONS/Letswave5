function varargout = GLW_eventsviewer(varargin)
% GLW_eventsviewer MATLAB code for GLW_eventsviewer.fig
%
% Author : 
% Andr Mouraux
% Institute of Neurosciences (IONS)
% Universit catholique de louvain (UCL)
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
                   'gui_OpeningFcn', @GLW_eventsviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_eventsviewer_OutputFcn, ...
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






% --- Executes just before GLW_eventsviewer is made visible.
function GLW_eventsviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_eventsviewer (see VARARGIN)
% Choose default command line output for GLW_eventsviewer
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%output
set(handles.sendmat_btn,'Userdata',varargin{3});
axis off;
% Fill eventmenu with event codes
%load header
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});

eventstring=searchevents(handles,header);
if isempty(eventstring)
else
    set(handles.eventmenu,'String',eventstring);
    %get eventlist
    eventlist=get(handles.eventmenu,'String');
    eventlist=eventlist{get(handles.eventmenu,'Value')};
    table=maketable(handles,header,eventlist);
    set(handles.uitable,'Data',table);
end;
%store header
set(handles.uitable,'UserData',header);
%update chan_popup
st={};
for i=1:length(header.chanlocs);
    st{i}=header.chanlocs(i).labels;
end;
set(handles.chan_popup,'String',st);
set(handles.chan_popup,'Value',1);
%update Y, Z, Index edit
set(handles.y_edit,'String',num2str(header.ystart));
set(handles.z_edit,'String',num2str(header.zstart));
set(handles.index_edit,'String',num2str(1));




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




function table=maketable(handles,header,eventlist);
table={};
%loop through events
tablepos=1;
for eventpos=1:length(header.events);
    %check if the eventcode is in the eventlist
    if strcmpi(header.events(eventpos).code,eventlist);
        table{tablepos,1}=header.events(eventpos).code;
        table{tablepos,2}=num2str(header.events(eventpos).epoch);
        table{tablepos,3}=num2str(header.events(eventpos).latency);
        tablepos=tablepos+1;
    end;
end;




% --- Outputs from this function are returned to the command line.
function varargout = GLW_eventsviewer_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on button press in sendmat_btn.
function sendmat_btn_Callback(hObject, eventdata, handles)
% hObject    handle to sendmat_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,'*** Sending to workspace.',1,0);
varname=get(handles.matvarname_edit,'String');
update_status.function(update_status.handles,['Variable name : ' varname],1,0);
%load header data
inputfiles=get(handles.filebox,'String');
[header,data]=LW_load(inputfiles{1});
events=header.events;
%channel
chanpos=get(handles.chan_popup,'Value');
%Y,Z,Index
dy=round(((str2num(get(handles.y_edit,'String'))-header.ystart)/header.ystep)+1);
dz=round(((str2num(get(handles.z_edit,'String'))-header.zstart)/header.zstep)+1);
indexpos=str2num(get(handles.index_edit,'String'));
update_status.function(update_status.handles,['dy : ' num2str(dy) ' dz : ' num2str(dz) ' index : ' num2str(indexpos)],1,0);
%convert events structure to matrix
tp={};
for i=1:length(events);
    tp{i,1}=events(i).code;
    tp{i,2}=events(i).epoch;
    tp{i,3}=events(i).latency;
    dx=round(((events(i).latency-header.xstart)/header.xstep))+1;
    tp{i,4}=data(events(i).epoch,chanpos,indexpos,dz,dy,dx);
end;
update_status.function(update_status.handles,'Column 1 = code',1,0);
update_status.function(update_status.handles,'Column 2 = epoch',1,0);
update_status.function(update_status.handles,'Column 3 = latency',1,0);
update_status.function(update_status.handles,'Column 4 = amplitude',1,0);
assignin('base',varname,tp);
update_status.function(update_status.handles,'Finished!',0,1);








% --- Executes on selection change in eventmenu.
function eventmenu_Callback(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%get eventlist
eventlist=get(handles.eventmenu,'String');
if length(eventlist)>=1;
    eventlist=eventlist{get(handles.eventmenu,'Value')};
    header=get(handles.uitable,'UserData');
    table=maketable(handles,header,eventlist);
    set(handles.uitable,'Data',table);
end;





% --- Executes during object creation, after setting all properties.
function eventmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in delete_events_btn.
function delete_events_btn_Callback(hObject, eventdata, handles)
% hObject    handle to delete_events_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eventpos=fix(str2num(get(handles.eventpos_edit,'String')));
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,['*** Deleting event at position : ' num2str(eventpos)],0,1);
tabledata=get(handles.uitable,'Data');
tabledata(eventpos,:)=[];
set(handles.uitable,'Data',tabledata);





% --- Executes when selected cell(s) is changed in uitable.
function uitable_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
try
    eventpos=eventdata.Indices(1);
    set(handles.eventpos_edit,'String',num2str(eventpos));
end;





function eventpos_edit_Callback(hObject, eventdata, handles)
% hObject    handle to eventpos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function eventpos_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventpos_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in add_events_btn.
function add_events_btn_Callback(hObject, eventdata, handles)
% hObject    handle to add_events_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eventpos=fix(str2num(get(handles.eventpos_edit,'String')));
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,['*** Adding empty event at position : ' num2str(eventpos)],0,1);
tabledata=get(handles.uitable,'Data');
newline={tabledata{1,1} '1' '0'};
tp1=tabledata(1:eventpos,:);
tp2=tabledata(eventpos+1:end,:);
tabledata=vertcat(tp1,newline,tp2);
set(handles.uitable,'Data',tabledata);






% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tabledata=get(handles.uitable,'Data');
header=get(handles.uitable,'UserData');
events=header.events;
eventcode=tabledata{1,1};
di=[];
%delete previous events with that code
for i=1:length(header.events);
    if strcmpi(header.events(i).code,eventcode);
        di=[di i];
    end;
end;
header.events(di)=[];
%add updated events
for i=1:size(tabledata,1);
    event.code=tabledata{i,1};
    event.latency=str2num(tabledata{i,3});
    event.epoch=fix(str2num(tabledata{i,2}));
    header.events(length(header.events)+1)=event;
end;
set(handles.uitable,'UserData',header);
%update table
eventlist=get(handles.eventmenu,'String');
eventlist=eventlist{get(handles.eventmenu,'Value')};
header=get(handles.uitable,'UserData');
table=maketable(handles,header,eventlist);
set(handles.uitable,'Data',table);






% --- Executes on button press in save_btn.
function save_btn_Callback(hObject, eventdata, handles)
% hObject    handle to save_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
header=get(handles.uitable,'UserData');
filename=get(handles.filebox,'String');
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,['Saving header : ' filename{1}],0,1);
save(filename{1},'header');






% --- Executes on button press in deletecat_btn.
function deletecat_btn_Callback(hObject, eventdata, handles)
% hObject    handle to deletecat_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eventlist=get(handles.eventmenu,'String');
selected_event=eventlist{get(handles.eventmenu,'Value')};
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,['Selected event : ' selected_event],0,1);
header=get(handles.uitable,'UserData');
eventcodes={};
for i=1:length(header.events);
    eventcodes{i}=header.events(i).code;
end;
idx=find(strcmpi(eventcodes,selected_event));
update_status.function(update_status.handles,['Number of events found : ' num2str(length(idx))],0,1);
header.events(idx)=[];
set(handles.uitable,'UserData',header);
%update
eventstring=searchevents(handles,header);
set(handles.eventmenu,'String',eventstring);
set(handles.eventmenu,'Value',1);
%get eventlist
eventlist=get(handles.eventmenu,'String');
if length(eventlist)>=1;
    eventlist=eventlist{get(handles.eventmenu,'Value')};
    table=maketable(handles,header,eventlist);
    set(handles.uitable,'Data',table);
else
    set(handles.uitable,'Data',[]);
end;






% --- Executes on button press in readmat_btn.
function readmat_btn_Callback(hObject, eventdata, handles)
% hObject    handle to readmat_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,'Reading from workspace.',1,0);
varname=get(handles.matvarname_edit,'String');
update_status.function(update_status.handles,['Variable name : ' varname],1,0);
header=get(handles.uitable,'UserData');
update_status.function(update_status.handles,['Variable name : ' varname],1,0);
update_status.function(update_status.handles,'Column 1 = code',1,0);
update_status.function(update_status.handles,'Column 2 = epoch',1,0);
update_status.function(update_status.handles,'Column 3 = latency',1,0);
%fetch cell matrix
tp=evalin('base',varname);
%convert matrix to events structure
events=[];
for i=1:length(tp);
     events(i).code=tp{i,1};
     events(i).epoch=tp{i,2};
     events(i).latency=tp{i,3};
end;
header.events=events;
set(handles.uitable,'UserData',header);
%update
eventstring=searchevents(handles,header);
set(handles.eventmenu,'String',eventstring);
set(handles.eventmenu,'Value',1);
%get eventlist
eventlist=get(handles.eventmenu,'String');
if length(eventlist)>=1;
    eventlist=eventlist{get(handles.eventmenu,'Value')};
    table=maketable(handles,header,eventlist);
    set(handles.uitable,'Data',table);
else
    set(handles.uitable,'Data',[]);
end;
update_status.function(update_status.handles,'Finished!',0,1);





function matvarname_edit_Callback(hObject, eventdata, handles)
% hObject    handle to matvarname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function matvarname_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matvarname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in renamecat_btn.
function renamecat_btn_Callback(hObject, eventdata, handles)
% hObject    handle to renamecat_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eventlist=get(handles.eventmenu,'String');
selected_event=eventlist{get(handles.eventmenu,'Value')};
update_status=get(handles.sendmat_btn,'UserData');
update_status.function(update_status.handles,['Selected event : ' selected_event],1,0);
header=get(handles.uitable,'UserData');
%dialog box
newname=cellstr(inputdlg('Enter new code name :','Rename category'));
for i=1:length(header.events);
    if strcmpi(header.events(i).code,selected_event);
        update_status.function(update_status.handles,['Renaming event : ' num2str(i)],1,0);
        header.events(i).code=newname{1};
    end;
end;
set(handles.uitable,'UserData',header);
%update
eventstring=searchevents(handles,header);
set(handles.eventmenu,'String',eventstring);
set(handles.eventmenu,'Value',1);
%get eventlist
eventlist=get(handles.eventmenu,'String');
if length(eventlist)>=1;
    eventlist=eventlist{get(handles.eventmenu,'Value')};
    table=maketable(handles,header,eventlist);
    set(handles.uitable,'Data',table);
else
    set(handles.uitable,'Data',[]);
end;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB


% --- Executes on selection change in chan_popup.
function chan_popup_Callback(hObject, eventdata, handles)
% hObject    handle to chan_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns chan_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from chan_popup


% --- Executes during object creation, after setting all properties.
function chan_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function index_edit_Callback(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of index_edit as text
%        str2double(get(hObject,'String')) returns contents of index_edit as a double


% --- Executes during object creation, after setting all properties.
function index_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of y_edit as text
%        str2double(get(hObject,'String')) returns contents of y_edit as a double


% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of z_edit as text
%        str2double(get(hObject,'String')) returns contents of z_edit as a double


% --- Executes during object creation, after setting all properties.
function z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
