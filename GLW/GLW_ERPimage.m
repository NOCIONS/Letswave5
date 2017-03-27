function varargout = GLW_ERPimage(varargin)
% GLW_ERPIMAGE MATLAB code for GLW_ERPimage.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ERPimage_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ERPimage_OutputFcn, ...
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





% --- Executes just before GLW_ERPimage is made visible.
function GLW_ERPimage_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ERPimage (see VARARGIN)
% Choose default command line output for GLW_ERPimage
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%inputfiles
inputfiles=get(handles.filebox,'String');
%load header of first file
header=LW_load_header(inputfiles{1});
%fill condition_popup
if isfield(header,'condition_labels');
    set(handles.condition_popup,'String',header.condition_labels);
end;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_ERPimage_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** ERP image.',1,0);
%condition_string
if get(handles.trialorder_chk,'Value')==1;
    update_status.function(update_status.handles,'Trials will be sorted according to their order in the dataset.',1,0);
else
    condition_string=get(handles.condition_popup,'String');
    condition_string=condition_string{get(handles.condition_popup,'Value')};
    update_status.function(update_status.handles,['Selected condition : ' condition_string],1,0);
end;
%hanning width
if get(handles.smooth_chk,'Value')==1;
    han_width=str2num(get(handles.han_edit,'String'));
else
    han_width=1;
end;
update_status.function(update_status.handles,['Hanning width (lines) : ' num2str(han_width)],1,0);
%ysise
ysize=str2num(get(handles.numlines_edit,'String'));
update_status.function(update_status.handles,['YSize : ' num2str(ysize)],1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing ERP image. This may take a while. Check command window for progress.',1,0);
    %epochindex
    epochindex=1:1:header.datasize(1);
    %epochvalue
    %sort according to condition?
    if get(handles.trialorder_chk,'Value')==1;
        %no
        epochvalue=epochindex;
    else
        %yes
        %find condition
        ci=find(strcmpi(header.condition_labels,condition_string));
        if isempty(ci)
            update_status.function(update_status.handles,'Condition not found in the dataset, using original trial order instead.',1,0);
            epochvalue=epochindex;
        else
            update_status.function(update_status.handles,'Condition found.',1,0);
            epochvalue=header.conditions(:,ci);
        end;
    end;
    %ystart,yend
    if get(handles.autorange_chk,'Value')==1;
        ystart=min(epochvalue);
        yend=max(epochvalue);
    else
        ystart=str2num(get(handles.ystart_edit,'String'));
        yend=str2num(get(handles.yend_edit,'String'));
    end;
    update_status.function(update_status.handles,['YStart : ' num2str(ystart)],1,0);
    update_status.function(update_status.handles,['YEnd : ' num2str(yend)],1,0);
    %process
    [header,data]=LW_ERPimage(header,data,epochindex,epochvalue,han_width,ysize,ystart,yend);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
    update_status.function(update_status.handles,'Finished!',0,1);





function numlines_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numlines_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function numlines_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numlines_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function ystart_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ystart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function ystart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ystart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function yend_edit_Callback(hObject, eventdata, handles)
% hObject    handle to yend_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function yend_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yend_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in autorange_chk.
function autorange_chk_Callback(hObject, eventdata, handles)
% hObject    handle to autorange_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.trialorder_chk,'Value')==1;
    set(handles.ystart_edit,'Enable','off');
    set(handles.yend_edit,'Enable','off');    
else
    set(handles.ystart_edit,'Enable','on');
    set(handles.yend_edit,'Enable','on');    
end;





% --- Executes on button press in smooth_chk.
function smooth_chk_Callback(hObject, eventdata, handles)
% hObject    handle to smooth_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.trialorder_chk,'Value')==1;
    set(handles.han_edit,'Enable','on');
else
    set(handles.han_edit,'Enable','off');
end;





function han_edit_Callback(hObject, eventdata, handles)
% hObject    handle to han_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function han_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to han_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in trialorder_chk.
function trialorder_chk_Callback(hObject, eventdata, handles)
% hObject    handle to trialorder_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.trialorder_chk,'Value')==1;
    set(handles.condition_popup,'Enable','off');
else
    set(handles.condition_popup,'Enable','on');
end;
    




% --- Executes on selection change in condition_popup.
function condition_popup_Callback(hObject, eventdata, handles)
% hObject    handle to condition_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function condition_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to condition_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in ascend_popup.
function ascend_popup_Callback(hObject, eventdata, handles)
% hObject    handle to ascend_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function ascend_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ascend_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
