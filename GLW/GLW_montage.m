function varargout = GLW_montage(varargin)
% GLW_MONTAGE MATLAB code for GLW_montage.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_montage_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_montage_OutputFcn, ...
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





% --- Executes just before GLW_montage is made visible.
function GLW_montage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_montage (see VARARGIN)
% Choose default command line output for GLW_montage
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%load header
filenames=get(handles.filebox,'String');
header=LW_load_header(filenames{1});
%fill channelboxes
for chanpos=1:length(header.chanlocs);
    chan_labels{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanbox1,'String',chan_labels);
set(handles.chanbox2,'String',chan_labels);
%clear table
set(handles.mtgbox,'UserData',[]);
set(handles.mtgbox,'String','');




% --- Outputs from this function are returned to the command line.
function varargout = GLW_montage_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Create new montage.',1,0);
%cdata and channel_labels
cdata=get(handles.mtgbox,'UserData');
channel_labels=get(handles.mtgbox,'String');
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Applying new montage.',1,0);
    %header
    oheader=header;
    oheader.datasize(2)=size(cdata,1);
    oheader.chanlocs=[];
    for chanpos=1:size(cdata,1);
        oheader.chanlocs(chanpos).labels=channel_labels{chanpos};
        oheader.chanlocs(chanpos).topo_enabled=0;
    end;
    %prepare odata
    odata=zeros(oheader.datasize);
    %loop through new channels
    for chanpos=1:size(cdata,1);
        odata(:,chanpos,:,:,:,:)=data(:,cdata(chanpos,1),:,:,:,:)-data(:,cdata(chanpos,2),:,:,:,:);
    end;
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),oheader,odata);
end;
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on selection change in operation_popup.
function operation_popup_Callback(hObject, eventdata, handles)
% hObject    handle to operation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function operation_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operation_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in chanbox1.
function chanbox1_Callback(hObject, eventdata, handles)
% hObject    handle to chanbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function chanbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in chanbox2.
function chanbox2_Callback(hObject, eventdata, handles)
% hObject    handle to chanbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function chanbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in InsertBtn.
function InsertBtn_Callback(hObject, eventdata, handles)
% hObject    handle to InsertBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%selected row
selected_row=get(handles.mtgbox,'Value');
%fetch table
cdata=get(handles.mtgbox,'UserData');
%active and ref channel
active_chan=get(handles.chanbox1,'Value');
ref_chan=get(handles.chanbox2,'Value');
%shift
cdata(selected_row+1:end+1,:)=cdata(selected_row:end,:);
cdata(selected_row,1)=active_chan;
cdata(selected_row,2)=ref_chan;
%channel labels
channel_labels=get(handles.chanbox1,'String');
%update labels
st=update_mtgbox(cdata,channel_labels);
set(handles.mtgbox,'String',st);
%update table
set(handles.mtgbox,'UserData',cdata);


% --- Executes on button press in AddButton.
function AddButton_Callback(hObject, eventdata, handles)
% hObject    handle to AddButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch table
cdata=get(handles.mtgbox,'UserData');
%active and ref channel
active_chan=get(handles.chanbox1,'Value');
ref_chan=get(handles.chanbox2,'Value');
%index
idx=size(cdata,1);
cdata(idx+1,1)=active_chan;
cdata(idx+1,2)=ref_chan;
%channel labels
channel_labels=get(handles.chanbox1,'String');
%update labels
st=update_mtgbox(cdata,channel_labels);
set(handles.mtgbox,'String',st);
%update table
set(handles.mtgbox,'UserData',cdata);



function mtg_labels=update_mtgbox(cdata,channel_labels);
for i=1:size(cdata,1);
    mtg_labels{i}=[channel_labels{cdata(i,1)} '-' channel_labels{cdata(i,2)}];
end;





% --- Executes on button press in DeleteBtn.
function DeleteBtn_Callback(hObject, eventdata, handles)
% hObject    handle to DeleteBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch table
cdata=get(handles.mtgbox,'UserData');
%selected row
selected_row=get(handles.mtgbox,'Value');
%delete
cdata(selected_row,:)=[];
%channel labels
channel_labels=get(handles.chanbox1,'String');
%update labels
st=update_mtgbox(cdata,channel_labels);
set(handles.mtgbox,'String',st);
%update table
set(handles.mtgbox,'UserData',cdata);









% --- Executes on button press in ClearBtn.
function ClearBtn_Callback(hObject, eventdata, handles)
% hObject    handle to ClearBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.mtgbox,'Value',1);
%channel labels
channel_labels=get(handles.chanbox1,'String');
set(handles.mtgbox,'String','');
%update table
set(handles.mtgbox,'UserData',[]);







% --- Executes on button press in UpBtn.
function UpBtn_Callback(hObject, eventdata, handles)
% hObject    handle to UpBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch table
cdata=get(handles.mtgbox,'UserData');
%selected row
selected_row=get(handles.mtgbox,'Value');
%permute
if selected_row>1;
    tp=cdata(selected_row-1,:);
    cdata(selected_row-1,:)=cdata(selected_row,:);
    cdata(selected_row,:)=tp;
    %update selection
    set(handles.mtgbox,'Value',selected_row-1);
end;
%channel labels
channel_labels=get(handles.chanbox1,'String');
%update labels
st=update_mtgbox(cdata,channel_labels);
set(handles.mtgbox,'String',st);
%update table
set(handles.mtgbox,'UserData',cdata);






% --- Executes on button press in DownBtn.
function DownBtn_Callback(hObject, eventdata, handles)
% hObject    handle to DownBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch table
cdata=get(handles.mtgbox,'UserData');
%selected row
selected_row=get(handles.mtgbox,'Value');
%permute
if selected_row<size(cdata,1);
    tp=cdata(selected_row+1,:);
    cdata(selected_row+1,:)=cdata(selected_row,:);
    cdata(selected_row,:)=tp;
    %update selection
    set(handles.mtgbox,'Value',selected_row+1);
end;
%channel labels
channel_labels=get(handles.chanbox1,'String');
%update labels
st=update_mtgbox(cdata,channel_labels);
set(handles.mtgbox,'String',st);
%update table
set(handles.mtgbox,'UserData',cdata);







% --- Executes on selection change in mtgbox.
function mtgbox_Callback(hObject, eventdata, handles)
% hObject    handle to mtgbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns mtgbox contents as cell array
%        contents{get(hObject,'Value')} returns selected item from mtgbox


% --- Executes during object creation, after setting all properties.
function mtgbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mtgbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
