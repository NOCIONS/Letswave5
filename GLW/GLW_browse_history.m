function varargout = GLW_browse_history(varargin)
% GLW_BROWSE_HISTORY MATLAB code for GLW_browse_history.fig
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
                   'gui_OpeningFcn', @GLW_browse_history_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_browse_history_OutputFcn, ...
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







function update_history(handles);
%filename
inputfiles=get(handles.filebox,'UserData');
filename=inputfiles{get(handles.filebox,'Value')};
%load header
header=LW_load_header(filename);
if isfield(header,'history');
    history=header.history;
    %build cellarray(lines,cols)
    for i=1:length(history);
        cellarray{i,1}=history(i).description;
        cellarray{i,2}=history(i).date;
    end;
    set(handles.table,'Data',cellarray);
    set(handles.table,'UserData',history);
end;






% --- Executes just before GLW_browse_history is made visible.
function GLW_browse_history_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_browse_history (see VARARGIN)
% Choose default command line output for GLW_browse_history
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
inputfiles=get(handles.filebox,'UserData');
for filepos=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{filepos});
    cleanfiles{filepos}=n;
end;
set(handles.filebox,'String',cleanfiles);
%output
set(handles.text_label,'Userdata',varargin{3});
axis off;
update_history(handles);



% --- Outputs from this function are returned to the command line.
function varargout = GLW_browse_history_OutputFcn(hObject, eventdata, handles) 
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
update_history(handles);




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
%filename
update_status=get(handles.text_label,'UserData');
pos=get(handles.processbutton,'UserData');
if isempty(pos);
    update_status.function(update_status.handles,'ERROR : you must first select history items!',0,1);
else
    rowpos=unique(pos(:,1));
    history=get(handles.table,'UserData');
    update_status.function(update_status.handles,'*** Sending details to Workspace variable history entry',0,1);
    assignin('base','history_entry',history(rowpos));
end;



% --- Executes when selected cell(s) is changed in table.
function table_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)
indices=eventdata.Indices;
set(handles.processbutton,'UserData',indices);




% --- Executes when entered data in editable cell(s) in table.
function table_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to table (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)
