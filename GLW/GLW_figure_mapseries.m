function varargout = GLW_figure_mapseries(varargin)
% GLW_FIGURE_MAPSERIES MATLAB code for GLW_figure_mapseries.fig
%




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_figure_mapseries_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_figure_mapseries_OutputFcn, ...
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




% --- Executes just before GLW_figure_mapseries is made visible.
function GLW_figure_mapseries_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_figure_mapseries (see VARARGIN)
% Choose default command line output for GLW_figure_mapseries
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
axis off;
%fill listbox with inputfiles (the array of input files is stored in varargin{2})
%The 'UserData' field contains the full path+filename of the LW5 datafile
set(handles.filebox,'UserData',varargin{2});
st=get(handles.filebox,'UserData');
for i=1:length(st);
    [p,n,e]=fileparts(st{i});
    inputfiles{i}=n;
end;
set(handles.filebox,'Value',1);
%The 'String' field only contains the name (without path and extension)
set(handles.filebox,'String',inputfiles);
%Headers
for i=1:length(st);
    header=LW_load_header(st{i});
    userdata(i).header=header;
    userdata(i).filename=st{i};
end;
set(handles.epochbox,'UserData',userdata);
%epochs
filepos=get(handles.filebox,'Value');
header=userdata(filepos).header;
epochlist={};
for i=1:header.datasize(1);
    epochlist{i}=num2str(i);
end;
set(handles.epochbox,'String',epochlist);
set(handles.epochbox,'Value',1);
set(handles.uitable,'Data',{});
set(handles.uitable,'UserData',[]);







% --- Outputs from this function are returned to the command line.
function varargout = GLW_figure_mapseries_OutputFcn(hObject, eventdata, handles) 
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
filepos=get(handles.filebox,'Value');
userdata=get(handles.epochbox,'UserData');
header=userdata(filepos).header;
epochlist={};
for i=1:header.datasize(1);
    epochlist{i}=num2str(i);
end;
set(handles.epochbox,'String',epochlist);
set(handles.epochbox,'Value',1);




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
%userdata
userdata=get(handles.epochbox,'UserData');
%tabledata
dispdata=get(handles.uitable,'UserData');
%cmin,cmax
cmin=str2num(get(handles.cmin_edit,'String'));
cmax=str2num(get(handles.cmax_edit,'String'));
%xi
xstart=str2num(get(handles.xstart_edit,'String'));
xend=str2num(get(handles.xend_edit,'String'));
mapcount=fix(str2num(get(handles.mapcount_edit,'String')));
disp(['Number of maps : ' num2str(mapcount)]);
xi=linspace(xstart,xend,mapcount);
disp(['xi : ' num2str(xi)]);
%figure
figure;
%viewpoint
viewpoint=get(handles.viewpoint_popup,'Value');
% top
% bottom
% front
% back
% left
% right
Az=[0 0 -180 0 -90 90]
El=[90 -90 0 0 0 0] 
%loop through rows
for rowpos=1:size(dispdata,1);
    %filepos,epochpos
    filepos=dispdata(rowpos,1);
    epochpos=dispdata(rowpos,2);
    filename=userdata(filepos).filename;
    [header,data]=LW_load(filename);
    %xi > dxi
    dxi=fix(((xi-header.xstart)/header.xstep))+1;
    %dy,dz,index
    dy=1;
    dz=1;
    index=1;
    %loop through dxi
    for i=1:length(dxi);
        %subplot
        subplot(size(dispdata,1),length(dxi),((rowpos-1)*length(dxi))+i);
        %headplot
        LW_headplot(header,data,epochpos,index,dxi(i),dy,dz,'maplimits',[cmin cmax]);
        %title
        title(gca,num2str(xi(i)));
        %viewpoint
        set(gca,'View',[Az(viewpoint) El(viewpoint)]);
    end;
end;







% --- Executes on selection change in epochbox.
function epochbox_Callback(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filepos=get(handles.filebox,'Value');
epochpos=get(handles.epochbox,'Value');
filenames=get(handles.filebox,'String');
epochnames=get(handles.epochbox,'String');
tabledata=get(handles.uitable,'UserData');
if isempty(tabledata);
    tabledata(1,1)=filepos;
    tabledata(1,2)=epochpos;
else
    tabledata(end+1,1)=filepos;
    tabledata(end,2)=epochpos;
end;
for i=1:size(tabledata,1);
    table{i,1}=filenames{tabledata(i,1)};
    table{i,2}=epochnames{tabledata(i,2)};
end;
set(handles.uitable,'UserData',tabledata);
set(handles.uitable,'Data',table);





% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable,'UserData',[]);
set(handles.uitable,'Data',{});



function mapcount_edit_Callback(hObject, eventdata, handles)
% hObject    handle to mapcount_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of mapcount_edit as text
%        str2double(get(hObject,'String')) returns contents of mapcount_edit as a double


% --- Executes during object creation, after setting all properties.
function mapcount_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to mapcount_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
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



function cmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmin_edit as text
%        str2double(get(hObject,'String')) returns contents of cmin_edit as a double


% --- Executes during object creation, after setting all properties.
function cmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function cmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of cmax_edit as text
%        str2double(get(hObject,'String')) returns contents of cmax_edit as a double


% --- Executes during object creation, after setting all properties.
function cmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in viewpoint_popup.
function viewpoint_popup_Callback(hObject, eventdata, handles)
% hObject    handle to viewpoint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns viewpoint_popup contents as cell array
%        contents{get(hObject,'Value')} returns selected item from viewpoint_popup


% --- Executes during object creation, after setting all properties.
function viewpoint_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to viewpoint_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
