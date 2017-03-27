function varargout = GLW_weightedchanavg_apply(varargin)
% GLW_WEIGHTEDCHANAVG_APPLY MATLAB code for GLW_weightedchanavg_apply.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_weightedchanavg_apply_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_weightedchanavg_apply_OutputFcn, ...
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





% --- Executes just before GLW_weightedchanavg_apply is made visible.
function GLW_weightedchanavg_apply_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_weightedchanavg_apply (see VARARGIN)
% Choose default command line output for GLW_weightedchanavg_apply
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_weightedchanavg_apply_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Apply weighted channel average.',1,0);
%extract vector
update_status.function(update_status.handles,'Loading weighting vector.',1,0);
template=get(handles.templatename_edit,'UserData');
vector=squeeze(template.data(1,:,1,1,1,1));
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Computing weighted channel average.',1,0);    
    %out_header
    out_header=header;
    out_header.datasize(2)=1;
    out_header.chanlocs=[];
    out_header.chanlocs(1).labels='chanavg';
    out_header.chanlocs(1).topo_enabled=0;
    %out_data
    out_data=zeros(out_header.datasize);
    for epochpos=1:header.datasize(1);
        for indexpos=1:header.datasize(3);
            for dz=1:header.datasize(4);
                for dy=1:header.datasize(5);
                    for dx=1:header.datasize(6);                        
                        out_data(epochpos,1,indexpos,dz,dy,dx)=sum(squeeze(data(epochpos,:,indexpos,dz,dy,dx)).*vector);
                    end;
                end;
            end;
        end;
    end;
    LW_save(inputfiles{filepos},get(handles.prefixtext,'String'),out_header,out_data);
end;
update_status.function(update_status.handles,'Finished!',0,1);


% --- Executes on button press in loadtemplate_btn.
function loadtemplate_btn_Callback(hObject, eventdata, handles)
% hObject    handle to loadtemplate_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
[p,n,e]=fileparts(inputfiles{1});
filterspec=[p,filesep,'*.lw5'];
[filename,pathname]=uigetfile(filterspec);
filename=fullfile(pathname,filename);
[p,n,e]=fileparts(filename);
set(handles.templatename_edit,'String',n);
%load header data
[header,data]=LW_load(filename);
template.header=header;
template.data=data;
set(handles.templatename_edit,'UserData',template);
disp('Template is loaded');
