function varargout = GLW_equalize(varargin)
% GLW_EQUALIZE MATLAB code for GLW_equalize.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_equalize_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_equalize_OutputFcn, ...
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





% --- Executes just before GLW_equalize is made visible.
function GLW_equalize_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_equalize (see VARARGIN)
% Choose default command line output for GLW_equalize
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_equalize_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Equalize number of epochs across datasets.',1,0);
update_status.function(update_status.handles,'Comparing the number of epochs across datasets.',1,0);
if get(handles.max_chk,'Value')==1;
    for filepos=1:length(inputfiles);
        update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
        header=LW_load_header(inputfiles{filepos});
        numepochs(filepos)=header.datasize(1);
        update_status.function(update_status.handles,[n ' : ' numepochs(filepos) ' epochs.'],1,0);
    end;
    equalnum=min(numepochs);
    disp(['Number of epochs of equalized files : ' num2str(equalnum)]);
else
    equalnum=round(str2num(get(handles.numepochs_edit,'String')));
    update_status.function(update_status.handles,['Number of epochs of equalized files : ' num2str(equalnum)],1,0);
end;
%select_option
selected_option=get(handles.equal_popup,'Value');
if selected_option==1;
    select_option='random';
end;
if selected_option==2;
    select_option='sequential_first';
end;
if selected_option==3;
    select_option='sequential_last';
end;
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Equalizing number of epochs.',1,0);
    [header,data]=LW_equalize(header,data,equalnum,select_option);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);


% --- Executes on selection change in equal_popup.
function equal_popup_Callback(hObject, eventdata, handles)
% hObject    handle to equal_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function equal_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to equal_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in max_chk.
function max_chk_Callback(hObject, eventdata, handles)
% hObject    handle to max_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of max_chk



function numepochs_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numepochs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of numepochs_edit as text
%        str2double(get(hObject,'String')) returns contents of numepochs_edit as a double


% --- Executes during object creation, after setting all properties.
function numepochs_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numepochs_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
