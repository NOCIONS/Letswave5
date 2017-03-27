function varargout = GLW_fieldtrip_dipfit_assign_mri(varargin)
% GLW_FIELDTRIP_DIPFIT_ASSIGN_MRI MATLAB code for GLW_fieldtrip_dipfit_assign_mri.fig
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
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
                   'gui_OpeningFcn', @GLW_fieldtrip_dipfit_assign_mri_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fieldtrip_dipfit_assign_mri_OutputFcn, ...
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




% --- Executes just before GLW_fieldtrip_dipfit_assign_mri is made visible.
function GLW_fieldtrip_dipfit_assign_mri_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fieldtrip_dipfit_assign_mri (see VARARGIN)
% Choose default command line output for GLW_fieldtrip_dipfit_assign_mri
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});




% --- Outputs from this function are returned to the command line.
function varargout = GLW_fieldtrip_dipfit_assign_mri_OutputFcn(hObject, eventdata, handles) 
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
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** DIPFIT : assign MRI data.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %save MRI
    [p2,n2,e2]=fileparts(get(handles.mrifilename,'String'));
    st_mri=[p filesep n2 '.mat'];
    update_status.function(update_status.handles,['Saving MRI data : ' st_mri],1,0);
    mri=get(handles.mrifilename,'UserData');
    save(st_mri,'mri');
    %update header
    update_status.function(update_status.handles,['Assigning MRI data : ' n2 '.mat'],1,0);
    header=LW_fieldtrip_dipfit_assign_mri(header,[n2 '.mat']);
    LW_save_header(inputfiles{filepos},[],header);
end;
update_status.function(update_status.handles,'Finished!',1,0);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filterspec={'*.mat; *.MAT'};
[filename,pathname]=uigetfile(filterspec);
filename=fullfile(pathname,filename);
set(handles.mrifilename,'String',filename);
load(filename);
if exist('mri');
    set(handles.mrifilename,'UserData',mri);
else
    msgbox('No MRI data found in selected MAT file');
end;
