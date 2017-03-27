function varargout = GLW_searchtags(varargin)
% GLW_SEARCHTAGS MATLAB code for GLW_searchtags.fig
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





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_searchtags_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_searchtags_OutputFcn, ...
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





% --- Executes just before GLW_searchtags is made visible.
function GLW_searchtags_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% Choose default command line output for GLW_searchtags
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_searchtags wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.processbutton,'UserData',varargin{2});
set(handles.tagbox1,'UserData',varargin{3});
searchtags(handles);





function searchtags(handles);
%search for tags
searchpath=get(handles.processbutton,'UserData');
%generate filelist (d)
if searchpath(length(searchpath))==filesep;
    searchpath=[searchpath '*.lw5'];
else
    searchpath=[searchpath filesep '*.lw5'];
end;
disp(['Search path : ' searchpath]);
d=dir(searchpath);
%filelist
filelist={};
for filepos=1:length(d);
    filelist{filepos}=d(filepos).name;;
end;
%loop through files and build list of tags
tags={};
tagpos=1;
for filepos=1:length(filelist);
    %load header
    header=LW_load_header(filelist{filepos});
    if isfield(header,'tags');
        if length(header.tags)>0;
            for i=1:length(header.tags);
                tags{tagpos}=header.tags{i};
                tagpos=tagpos+1;
            end;
        end;
    end;
end;
%delete duplicate tags
%loop through tags
tagindex=ones(length(tags),1);
for tagpos=1:length(tags)-1;
    for tagpos2=tagpos+1:length(tags);
        if strcmpi(tags{tagpos},tags{tagpos2})
            tagindex(tagpos2)=0;
        end;
    end;
end;
%prepare selection
selection=[];
for tagpos=1:length(tags);
    if tagindex(tagpos)==0;
        selection=[selection tagpos];
    end;
end;
tags(selection)=[];
%update tagbox1
set(handles.tagbox1,'String',tags);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_searchtags_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;




% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mainhandles=get(handles.tagbox1,'UserData');
%selected tags
selectedtags=get(handles.tagbox1,'Value');
tags=get(handles.tagbox1,'String');
for i=1:length(selectedtags);
    tags2{i}=tags{selectedtags(i)};
end;
tags=tags2;
%searchpath
searchpath=get(handles.processbutton,'UserData');
%searchoption
if get(handles.ORbutton,'Value')==1;
    searchoption='or';
else
    searchoption='and';
end;
%find tags
filelist=LW_findtags(searchpath,tags,searchoption);
%reformat filelist
if length(filelist)>0;
    for filepos=1:length(filelist);
        [path,name,ext]=fileparts(filelist{filepos});
        filelist{filepos}=name;
    end;
else
    filelist=[];
end;
disp(filelist);
%update listbox of main letswave window
set(mainhandles.filebox,'String',filelist);
set(mainhandles.filebox,'Value',[]);



% --- Executes on selection change in tagbox1.
function tagbox1_Callback(hObject, eventdata, handles)
% hObject    handle to tagbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function tagbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tagbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in ANDbutton.
function ANDbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ANDbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.ANDbutton,'Value')==1;
    set(handles.ORbutton,'Value',0);
else
    set(handles.ORbutton,'Value',1);
end;




% --- Executes on button press in ORbutton.
function ORbutton_Callback(hObject, eventdata, handles)
% hObject    handle to ORbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.ORbutton,'Value')==1;
    set(handles.ANDbutton,'Value',0);
else
    set(handles.ANDbutton,'Value',1);
end;


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
searchtags(handles);
