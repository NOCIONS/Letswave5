function varargout = GLW_ica_remix(varargin)
% GLW_ICA_REMIX MATLAB code for GLW_ica_remix.fig
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
                   'gui_OpeningFcn', @GLW_ica_remix_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ica_remix_OutputFcn, ...
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




% --- Executes just before GLW_ica_remix is made visible.
function GLW_ica_remix_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ica_remix (see VARARGIN)
% Choose default command line output for GLW_ica_remix
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%load headers
filename_bss='';
inputfiles=get(handles.filebox,'String');
for filepos=1:length(inputfiles);
    [p n e]=fileparts(inputfiles{filepos});
    header=LW_load_header(inputfiles{filepos});
    if strcmpi(filename_bss,header.filename_bss);
        msgbox('This function requires that all inputfiles have the same matrix!');
        return;
    else
        filename_bss=header.filename_bss;
    end;
end;
%load header of matrix
[p2,n2,e2]=fileparts(filename_bss);
filename_bss=[p,filesep,n2,'.lw5'];
header=LW_load_header(filename_bss);
%fill icabox
for icpos=1:header.datasize(6);
    ICstring{icpos}=['IC',num2str(icpos)];
end;
set(handles.icbox,'String',ICstring);
%select all
sel=1:1:header.datasize(6);
set(handles.icbox,'Value',sel);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ica_remix_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** ICA remix.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [p n e]=fileparts(inputfiles{filepos});
    [inheader,indata]=LW_load(inputfiles{filepos});
    %matrix file name
    icafilename=inheader.filename_bss;
    icaheaderfilename=[p,filesep,icafilename];
    [matrixheader,matrixdata]=LW_load(icaheaderfilename);
    %selected ICs
    selectedICs=get(handles.icbox,'Value');
    %edit ICA matrix
    update_status.function(update_status.handles,['Selected ICs : ',num2str(selectedICs)],1,0);
    [matrixheader,matrixdata]=LW_ica_editmatrix(matrixheader,matrixdata,selectedICs);
    %process
    update_status.function(update_status.handles,'Remixing dataset.',1,0);
    [header,data]=LW_ica_mix(inheader,indata,matrixheader,matrixdata);
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
[p,n,e]=fileparts(inputfiles{1});
filterspec=[p,filesep,'*.lw5'];
filename=uigetfile(filterspec);
set(handles.icafilename,'String',filename);



function prefixtext_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function prefixtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in icabox.
function icabox_Callback(hObject, eventdata, handles)
% hObject    handle to icabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function icabox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to icabox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in icbox.
function icbox_Callback(hObject, eventdata, handles)
% hObject    handle to icbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function icbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to icbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.icbox,'String');
sel=1:1:length(st);
set(handles.icbox,'Value',sel);


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.icbox,'Value',[]);
