function varargout = GLW_applywaveletfilter(varargin)
% GLW_applywaveletfilter MATLAB code for GLW_butterhigh.fig
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
                   'gui_OpeningFcn', @GLW_applywaveletfilter_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_applywaveletfilter_OutputFcn, ...
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
function GLW_applywaveletfilter_OpeningFcn(hObject, eventdata, handles, varargin)
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





% --- Outputs from this function are returned to the command line.
function varargout = GLW_applywaveletfilter_OutputFcn(hObject, eventdata, handles) 
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
fig_title=get(handles.figure,'Name');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Apply wavelet filter.',1,0);
%loading CWT template
templatename=get(handles.templatetext,'String');
update_status.function(update_status.handles,['Loading template : ',templatename],1,0);
[p,n,e]=fileparts(inputfiles{1});
st=[p filesep templatename]
[template_header,template_data]=LW_load(st);
%channel_idx
channel_idx=get(handles.chanbox,'Value');
if length(channel_idx)==template_header.datasize(2);
else
    msgbox('The number of selected channels must correspond to the number of channels in the template');
    return;
end;
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Applying the TF filter.',1,0);
    include_original=get(handles.originalchk,'Value');
    [header,data]=LW_apply_waveletfilter(header,data,template_header,template_data,channel_idx,include_original);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished',0,1);






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




% --- Executes on button press in selectfilter_button.
function selectfilter_button_Callback(hObject, eventdata, handles)
% hObject    handle to selectfilter_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FilterSpec={'*.lw5;*.LW5'};
filename=uigetfile(FilterSpec);
set(handles.templatetext,'String',filename);
load(filename,'-mat');
ok=0;
for i=1:length(header.history);
    if strcmpi(header.history(i).description,'LW_build_waveletfilter');
        ok=i;
    end;
end;
if ok==0;
    msgbox('WARNING : the selected file is not a wavelet filter template');
end;
if ok>0;
    set(handles.chanbox,'Value',header.history(ok).index);
end;



function prefixtext_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefixtext as text
%        str2double(get(hObject,'String')) returns contents of prefixtext as a double


% --- Executes during object creation, after setting all properties.
function prefixtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in originalchk.
function originalchk_Callback(hObject, eventdata, handles)
% hObject    handle to originalchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of originalchk
