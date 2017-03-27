function varargout = GLW_copyfiles(varargin)
% GLW_COPYFILES MATLAB code for GLW_copyfiles.fig
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
%



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_copyfiles_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_copyfiles_OutputFcn, ...
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





% --- Executes just before GLW_copyfiles is made visible.
function GLW_copyfiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_copyfiles (see VARARGIN)
% Choose default command line output for GLW_copyfiles
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
set(handles.processbutton,'Userdata',varargin{3});
axis off;
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    inputfiles{i}=n;
end;
set(handles.filebox,'String',inputfiles);
set(handles.filebox,'Value',1:1:length(inputfiles));
%outputedit
set(handles.outputedit,'string',p);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_copyfiles_OutputFcn(hObject, eventdata, handles) 
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
%selectedfiles
inputfiles=get(handles.filebox,'UserData');
selectedfiles=inputfiles(get(handles.filebox,'Value'));
%outputpath
outpath=get(handles.outputedit,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Copy files.',1,0);
%loop through files
for filepos=1:length(selectedfiles);
    %inputfile
    inputfile=selectedfiles{filepos};
    %outputfile
    [p,n,e]=fileparts(inputfile);
    outputfile=[outpath,filesep,n,e];
    %process
    update_status.function(update_status.handles,['Copy  : ',inputfile,' > ',outputfile],1,0);
    LW_copyfile(inputfile,outputfile);
end;
update_status.function(update_status.handles,'Finished!',0,1);




function outputedit_Callback(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function outputedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
p=uigetdir(get(handles.outputedit,'String'));
set(handles.outputedit,'String',p);
