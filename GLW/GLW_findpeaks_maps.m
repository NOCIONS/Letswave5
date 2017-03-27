function varargout = GLW_findpeaks_maps(varargin)
% GLW_FINDPEAKS_MAPS MATLAB code for GLW_findpeaks_maps.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_findpeaks_maps_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_findpeaks_maps_OutputFcn, ...
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





% --- Executes just before GLW_findpeaks_maps is made visible.
function GLW_findpeaks_maps_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_findpeaks_maps (see VARARGIN)
% Choose default command line output for GLW_findpeaks_maps
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n{i},e]=fileparts(inputfiles{i});
end;
set(handles.filebox,'String',n);



% --- Outputs from this function are returned to the command line.
function varargout = GLW_findpeaks_maps_OutputFcn(hObject, eventdata, handles) 
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
%enable table buttons
set(handles.epochtable_btn,'Enable','off');
set(handles.chantable_btn,'Enable','off');




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
inputfiles=get(handles.filebox,'UserData');
selected_file=inputfiles{get(handles.filebox,'Value')};
%update_status
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Extract peaks from maps.',0,0);
%load header data
[header,data]=LW_load(selected_file);
%ROI
xmin=str2num(get(handles.xmin_edit,'String'));
xmax=str2num(get(handles.xmax_edit,'String'));
ymin=str2num(get(handles.ymin_edit,'String'));
ymax=str2num(get(handles.ymax_edit,'String'));
update_status.function(update_status.handles,['X-axis range : ' num2str(xmin) ' - ' num2str(xmax)],0,0);
update_status.function(update_status.handles,['Y-axis range : ' num2str(ymin) ' - ' num2str(ymax)],0,0);
%dx,dy
dxmin=round(((xmin-header.xstart)/header.xstep))+1;
dxmax=round(((xmax-header.xstart)/header.xstep))+1;
dymin=round(((ymin-header.ystart)/header.ystep))+1;
dymax=round(((ymax-header.ystart)/header.ystep))+1;
update_status.function(update_status.handles,['X-axis bins : ' num2str(dxmin) ' - ' num2str(dxmax)],0,0);
update_status.function(update_status.handles,['Y-axis bins : ' num2str(dymin) ' - ' num2str(dymax)],0,0);
%Extract method
tp=get(handles.operation_popup,'Value');
if tp==1;
    method='maximum';
end;
if tp==2;
    method='minimum';
end;
if tp==3;
    method='average';
end;
update_status.function(update_status.handles,['Method : ' method],0,0);
%roi_dx, yoi_dy
for dx=dxmin:dxmax;
    for dy=dymin:dymax;
        roi_dx(dy-dymin+1,dx-dxmin+1)=dx;
        roi_dy(dy-dymin+1,dx-dxmin+1)=dy;
    end;
end;
roi_dx_concat=roi_dx(:);
roi_dy_concat=roi_dy(:);
%Top
top_chk=get(handles.percent_chk,'Value');
top_percent=str2num(get(handles.percent_edit,'String'));
if top_chk==1;
    update_status.function(update_status.handles,['Top Percent approach will be used : ' num2str(top_percent)],0,0);
    %num_percent
    num_percent=round(length(roi_dx_concat)*(top_percent/100));
    update_status.function(update_status.handles,['Number of bins : ' num2str(num_percent)],0,0);
end;
%Prepare
roi_x=zeros(header.datasize(1),header.datasize(2),header.datasize(3),header.datasize(4));
roi_y=zeros(header.datasize(1),header.datasize(2),header.datasize(3),header.datasize(4));
roi_v=zeros(header.datasize(1),header.datasize(2),header.datasize(3),header.datasize(4));
%Loop
for epochpos=1:header.datasize(1);
    for chanpos=1:header.datasize(2);
        for indexpos=1:header.datasize(3);
            for dz=1:header.datasize(4);
                roi=data(epochpos,chanpos,indexpos,dz,dymin:dymax,dxmin:dxmax);
                roi_concat=roi(:);
                if top_chk==1;
                    %top percent approach
                    if strcmpi(method,'average');
                        %average
                        std_roi_concat=roi_concat-mean(roi_concat);
                        [dv,di]=sort(roi_concat-mean(roi_concat));
                        dx=mean(roi_dx_concat(di(1:num_percent)));
                        dy=mean(roi_dy_concat(di(1:num_percent)));
                        v=mean(roi_concat(di(1:num_percent)));
                    end;
                    if strcmpi(method,'maximum');
                        %maximum
                        [dv,di]=sort(roi_concat-mean(roi_concat),'descend');
                        dx=mean(roi_dx_concat(di(1:num_percent)));
                        dy=mean(roi_dy_concat(di(1:num_percent)));
                        v=mean(roi_concat(di(1:num_percent)));
                    end;
                    if strcmpi(method,'minimum');
                        %minimum
                        [dv,di]=sort(roi_concat-mean(roi_concat),'ascend');
                        dx=mean(roi_dx_concat(di(1:num_percent)));
                        dy=mean(roi_dy_concat(di(1:num_percent)));
                        v=mean(roi_concat(di(1:num_percent)));
                    end;
                else
                    %not top percent approach
                    if strcmpi(method,'average');
                        %average
                        dx=mean(roi_dx_concat);
                        dy=mean(roi_dy_concat);
                        v=mean(roi_concat);
                    end;
                    if strcmpi(method,'maximum');
                        %maximum
                        [v,i]=max(roi_concat);
                        dx=roi_dx_concat(i);
                        dy=roi_dy_concat(i);
                    end;
                    if strcmpi(method,'minimum');
                        %minimum
                        [v,i]=min(roi_concat);
                        dx=roi_dx_concat(i);
                        dy=roi_dy_concat(i);
                    end;
                end;
                roi_x(epochpos,chanpos,indexpos,dz)=((dx-1)*header.xstep)+header.xstart;
                roi_y(epochpos,chanpos,indexpos,dz)=((dy-1)*header.ystep)+header.ystart;
                roi_v(epochpos,chanpos,indexpos,dz)=v;
            end;
        end;
    end;
end;
%store
results.roi_x=roi_x;
results.roi_y=roi_y;
results.roi_v=roi_v;
set(handles.operation_popup,'UserData',results);
update_status.function(update_status.handles,'Finished!',0,1);
%update table parameters
st={};
for i=1:header.datasize(1);
    st{i}=num2str(i);
end;
set(handles.epoch_popup,'String',st);
set(handles.epoch_popup,'Value',1);
st={};
for i=1:header.datasize(2);
    st{i}=header.chanlocs(i).labels;
end;
set(handles.channel_popup,'String',st);
set(handles.channel_popup,'Value',1);
set(handles.index_edit,'String',num2str(1));
set(handles.z_edit,'String',num2str(header.zstart));
%store header
set(handles.epoch_popup,'UserData',header);
%enable table buttons
set(handles.epochtable_btn,'Enable','on');
set(handles.chantable_btn,'Enable','on');







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





% --- Executes on button press in percent_chk.
function percent_chk_Callback(hObject, eventdata, handles)
% hObject    handle to percent_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function percent_edit_Callback(hObject, eventdata, handles)
% hObject    handle to percent_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function percent_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to percent_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function xmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function xmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function xmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function ymin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ymin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function ymin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function ymax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to ymax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function ymax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function index_edit_Callback(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function index_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to index_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in channel_popup.
function channel_popup_Callback(hObject, eventdata, handles)
% hObject    handle to channel_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function channel_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function z_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function z_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in epoch_popup.
function epoch_popup_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epoch_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in epochtable_btn.
function epochtable_btn_Callback(hObject, eventdata, handles)
% hObject    handle to epochtable_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
results=get(handles.operation_popup,'UserData');
header=get(handles.epoch_popup,'UserData');
table_data={};
chanpos=get(handles.channel_popup,'Value');
indexpos=str2num(get(handles.index_edit,'String'));
dz=round((str2num(get(handles.z_edit,'String'))-header.zstart)/header.zstep)+1;
for epochpos=1:header.datasize(1);
    table_data{epochpos,1}=epochpos;
    table_data{epochpos,2}=results.roi_x(epochpos,chanpos,indexpos,dz);
    table_data{epochpos,3}=results.roi_y(epochpos,chanpos,indexpos,dz);
    table_data{epochpos,4}=results.roi_v(epochpos,chanpos,indexpos,dz);
end;
st{1}='epoch';
st{2}='X';
st{3}='Y';
st{4}='value';
set(handles.uitable,'ColumnName',st);
set(handles.uitable,'Data',table_data);






% --- Executes on button press in chantable_btn.
function chantable_btn_Callback(hObject, eventdata, handles)
% hObject    handle to chantable_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
results=get(handles.operation_popup,'UserData');
header=get(handles.epoch_popup,'UserData');
table_data={};
epochpos=get(handles.epoch_popup,'Value');
indexpos=str2num(get(handles.index_edit,'String'));
dz=round((str2num(get(handles.z_edit,'String'))-header.zstart)/header.zstep)+1;
for chanpos=1:header.datasize(2);
    table_data{chanpos,1}=header.chanlocs(chanpos).labels;
    table_data{chanpos,2}=results.roi_x(epochpos,chanpos,indexpos,dz);
    table_data{chanpos,3}=results.roi_y(epochpos,chanpos,indexpos,dz);
    table_data{chanpos,4}=results.roi_v(epochpos,chanpos,indexpos,dz);
end;
st{1}='channel';
st{2}='X';
st{3}='Y';
st{4}='value';
set(handles.uitable,'ColumnName',st);
set(handles.uitable,'Data',table_data);
