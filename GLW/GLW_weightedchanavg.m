function varargout = GLW_weightedchanavg(varargin)
% GLW_WEIGHTEDCHANAVG MATLAB code for GLW_weightedchanavg.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_weightedchanavg_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_weightedchanavg_OutputFcn, ...
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





% --- Executes just before GLW_weightedchanavg is made visible.
function GLW_weightedchanavg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_weightedchanavg (see VARARGIN)
% Choose default command line output for GLW_weightedchanavg
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.text_label,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%
filename_list=get(handles.filebox,'String');
filename=filename_list{1};
%
[header,data]=LW_load(filename);
template.header=header;
template.data=data;
set(handles.createtemplate_btn,'UserData',template);
%populate chan_listbox
for i=1:length(template.header.chanlocs);
    chan_string{i}=template.header.chanlocs(i).labels;
end;
chan_values=1:1:length(chan_string);
set(handles.chan_listbox,'String',chan_string);
set(handles.chan_listbox,'Value',chan_values);
%set X,Y,Z
set(handles.x_edit,'String',num2str(template.header.xstart));
set(handles.y_edit,'String',num2str(template.header.ystart));
set(handles.z_edit,'String',num2str(template.header.zstart));
if template.header.datasize(4)==1;
    set(handles.z_edit,'Enable','off');
end;
if template.header.datasize(5)==1;
    set(handles.y_edit,'Enable','off');
end;
if template.header.datasize(3)==1;
    set(handles.index_edit,'Enable','off');
end;
if template.header.datasize(1)==1;
    set(handles.epoch_edit,'Enable','off');
end;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_weightedchanavg_OutputFcn(hObject, eventdata, handles) 
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






% --- Executes on button press in load_btn.
function load_btn_Callback(hObject, eventdata, handles)
% hObject    handle to select_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function numchans_edit_Callback(hObject, eventdata, handles)
% hObject    handle to select_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function numchans_edit_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on selection change in chan_listbox.
function chan_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to chan_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function chan_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in select_btn.
function select_btn_Callback(hObject, eventdata, handles)
% hObject    handle to select_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chan_string=get(handles.chan_listbox,'String');
v=1:1:length(chan_string);
set(handles.chan_listbox,'Value',v);





% --- Executes on button press in deselect_btn.
function deselect_btn_Callback(hObject, eventdata, handles)
% hObject    handle to deselect_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chan_listbox,'Value',[]);





function x_edit_Callback(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function x_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to x_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function y_edit_Callback(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function y_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to y_edit (see GCBO)
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






function epoch_edit_Callback(hObject, eventdata, handles)
% hObject    handle to epoch_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function epoch_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epoch_edit (see GCBO)
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






% --- Executes on button press in norm_chk.
function norm_chk_Callback(hObject, eventdata, handles)
% hObject    handle to norm_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in createtemplate_btn.
function createtemplate_btn_Callback(hObject, eventdata, handles)
% hObject    handle to createtemplate_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
update_status=get(handles.text_label,'UserData');
update_status.function(update_status.handles,'*** Weighted channel average.',1,0);
%location
epoch_pos=str2num(get(handles.epoch_edit,'String'));
index_pos=str2num(get(handles.index_edit,'String'));
x_pos=str2num(get(handles.x_edit,'String'));
y_pos=str2num(get(handles.y_edit,'String'));
z_pos=str2num(get(handles.z_edit,'String'));
%sort order
if get(handles.minmax_listbox,'Value')==1;
    sortorder='descend';
    update_status.function(update_status.handles,'Maximum selected.',1,0);
    absmap='no';
end;
if get(handles.minmax_listbox,'Value')==2;
    sortorder='ascend';
    update_status.function(update_status.handles,'Minimum selected.',1,0);
    absmap='no';
end;
if get(handles.minmax_listbox,'Value')==3;
    sortorder='descend';
    update_status.function(update_status.handles,'Absolute maximum selected.',1,0);
    absmap='yes';
end;
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
    input_filename=n;
    load(st,'-MAT');
    %channels and channel labels
    selected_channels=get(handles.chan_listbox,'Value');
    chan_labels=get(handles.chan_listbox,'String');
    for i=1:length(chan_labels);
        chan_labels{i}=[chan_labels{i} ' '];
    end;
    chanlocs=header.chanlocs;
    %fetch vector
    dx_pos=round(((x_pos-header.xstart)/header.xstep))+1;
    dy_pos=round(((y_pos-header.ystart)/header.ystep))+1;
    dz_pos=round(((z_pos-header.zstart)/header.zstep))+1;
    chan_vector=squeeze(data(epoch_pos,:,index_pos,dz_pos,dy_pos,dx_pos));
    chan_vector_idx=1:1:length(chan_vector);
    chan_vector_idx=chan_vector_idx(selected_channels);
    chan_vector_orig=chan_vector;
    chan_vector_idxv=chan_vector(selected_channels);
    update_status.function(update_status.handles,['Search within channels : ' chan_labels{chan_vector_idx}],1,0);    
    %sort
    if strcmpi(absmap,'yes');
        chan_vector_idxv=abs(chan_vector_idxv);
    end;
    [Y,I]=sort(chan_vector_idxv,sortorder);
    %num_channels
    num_channels=str2num(get(handles.numchans_edit,'String'));
    update_status.function(update_status.handles,['Number of channels to include : ' num2str(num_channels)],1,0);    
    chan_vector_idx=chan_vector_idx(I(1:num_channels));
    update_status.function(update_status.handles,['Selected channels : ' chan_labels{chan_vector_idx}],1,0);    
    %adjust vector
    new_chan_vector=chan_vector*0;
    new_chan_vector(chan_vector_idx)=chan_vector(chan_vector_idx);
    %abs
    new_chan_vector=abs(new_chan_vector);
    %normalize?
    if get(handles.norm_chk,'Value')==1;
        new_chan_vector=new_chan_vector/sum(new_chan_vector);
    end;
    %figure
    figure;
    set(gcf,'Name',input_filename);
    subplot(1,2,1);
    %fetch chanlocs
    vector=chan_vector_orig;
    %parse data and chanlocs according to topo_enabled
    k=1;
    for chanpos=1:size(chanlocs,2);
        if chanlocs(chanpos).topo_enabled==1
            vector2(k)=double(vector(chanpos));
            chanlocs2(k)=chanlocs(chanpos);
            k=k+1;
        end;
    end;
    h=topoplot(vector2,chanlocs2);
    subplot(1,2,2);
    %fetch chanlocs
    vector=new_chan_vector;
    %parse data and chanlocs according to topo_enabled
    k=1;
    for chanpos=1:size(chanlocs,2);
        if chanlocs(chanpos).topo_enabled==1
            vector2(k)=double(vector(chanpos));
            chanlocs2(k)=chanlocs(chanpos);
            k=k+1;
        end;
    end;
    h=topoplot(vector2,chanlocs2);
    %prepare data
    data(1,:,1,1,1,1)=new_chan_vector;
    %prepare header
    header.datasize=size(data);
    header.xstart=x_pos;
    header.ystart=y_pos;
    header.zstart=z_pos;    
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








function template_edit_Callback(hObject, eventdata, handles)
% hObject    handle to template_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function template_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to template_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in minmax_listbox.
function minmax_listbox_Callback(hObject, eventdata, handles)
% hObject    handle to minmax_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function minmax_listbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minmax_listbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
