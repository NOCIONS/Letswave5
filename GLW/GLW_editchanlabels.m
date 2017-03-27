function varargout = GLW_editchanlabels(varargin)
% GLW_editchanlabels MATLAB code for GLW_butterhigh.fig
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
                   'gui_OpeningFcn', @GLW_editchanlabels_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_editchanlabels_OutputFcn, ...
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
function GLW_editchanlabels_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_averageepochs (see VARARGIN)
% Choose default command line output for GLW_averageepochs
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
inputfiles=varargin{2};
set(handles.filebox,'String',inputfiles);
header=LW_load_header(inputfiles{1});
%fill channel table (chantable)
for i=1:length(header.chanlocs);
    chanstring{i,1}=header.chanlocs(i).labels;
    chanstring{i,2}=header.chanlocs(i).labels;    
end;
set(handles.chantable,'Data',chanstring);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;









% --- Outputs from this function are returned to the command line.
function varargout = GLW_editchanlabels_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on button press in loadbutton.
function loadbutton_Callback(hObject, eventdata, handles)
% hObject    handle to loadbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
[p,n,e]=fileparts(inputfiles{1});
filterspec=[p,filesep,'*.txt'];
[filename,pathname]=uigetfile(filterspec);
filename=fullfile(pathname,filename);
tfile=fopen(filename);
c=textscan(tfile,'%s');
c=c{1};
fclose(tfile);
t=get(handles.chantable,'Data');
for i=1:size(t,1);
    t{i,2}=c{i};
end;
set(handles.chantable,'Data',t);


% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Editing channel labels.',1,0);
%chanstring
t=get(handles.chantable,'Data');
for i=1:size(t,1);
    chanstring{i}=t{i,2};
end;
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %change labels
    for i=1:length(header.chanlocs);
        header.chanlocs(i).labels=chanstring{i};
    end;
    LW_save_header(inputfiles{filepos},[],header);

end;
update_status.function(update_status.handles,'Finished!',0,1);
