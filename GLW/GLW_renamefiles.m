function varargout = GLW_renamefiles(varargin)
% GLW_RENAMEFILES MATLAB code for GLW_renamefiles.fig
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
                   'gui_OpeningFcn', @GLW_renamefiles_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_renamefiles_OutputFcn, ...
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





% --- Executes just before GLW_renamefiles is made visible.
function GLW_renamefiles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_renamefiles (see VARARGIN)
% Choose default command line output for GLW_renamefiles
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill filenameedit with inputfile(1)
set(handles.filenameedit,'UserData',varargin{2});
inputfiles=get(handles.filenameedit,'UserData');
[p,n,e]=fileparts(inputfiles{1});
set(handles.filenameedit,'String',n);
set(handles.processbutton,'Userdata',varargin{3});
axis off;






% --- Outputs from this function are returned to the command line.
function varargout = GLW_renamefiles_OutputFcn(hObject, eventdata, handles) 
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
inputfiles=get(handles.filenameedit,'UserData');
selectedfile=inputfiles{1};
%newfilename
[p n e]=fileparts(selectedfile);
newfilename=[p,filesep,get(handles.filenameedit,'String'),'.lw5'];
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Renaming datafile.',1,0);
update_status.function(update_status.handles,['New filename : ' newfilename],1,0);
%process
LW_renamefile(selectedfile,newfilename);
update_status.function(update_status.handles,'Finished!',0,1);



function filenameedit_Callback(hObject, eventdata, handles)
% hObject    handle to filenameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of filenameedit as text
%        str2double(get(hObject,'String')) returns contents of filenameedit as a double


% --- Executes during object creation, after setting all properties.
function filenameedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filenameedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
