function varargout = GLW_segmentation_mult(varargin)
% GLW_segmentation_mult MATLAB code for GLW_segmentation_mult.fig
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
                   'gui_OpeningFcn', @GLW_segmentation_mult_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_segmentation_mult_OutputFcn, ...
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






% --- Executes just before GLW_segmentation_mult is made visible.
function GLW_segmentation_mult_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_segmentation_mult (see VARARGIN)
% Choose default command line output for GLW_segmentation_mult
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
% Fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
% Fill eventmenu with event codes
%load header
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
eventstring=searchevents(handles,header);
set(handles.eventmenu,'String',eventstring);




function eventstring=searchevents(handles,header);
eventpos3=1;
eventstring={};
for eventpos=1:length(header.events);
    if isnumeric(header.events(eventpos).code)
        code=num2str(header.events(eventpos).code);
    else
        code=header.events(eventpos).code;
    end;
    found=0;
    if length(eventstring)>0;
        for eventpos2=1:length(eventstring);
            if strcmpi(eventstring{eventpos2},code);
                found=1;
            end;
        end;
    end;
    if found==0;
        eventstring{eventpos3}=code;
        eventpos3=eventpos3+1;
    end;
end;






% --- Outputs from this function are returned to the command line.
function varargout = GLW_segmentation_mult_OutputFcn(hObject, eventdata, handles) 
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
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Segmentation relative to events.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %transfer header and data
    inheader=header;
    indata=data;
    %eventcodes
    eventstring=get(handles.eventmenu,'String');
    eventvalue=get(handles.eventmenu,'Value');
    if length(eventvalue)==0;
        msgbox('No events selected!');
        return;
    else
        for i=1:length(eventvalue);
            eventcodes{i}=eventstring{eventvalue(i)};
        end;
    end;
    %xstart
    xstart=str2num(get(handles.startedit,'String'));
    %xsize
    if get(handles.epochsizechk,'Value')==1;
        xsize=fix(str2num(get(handles.sizeedit,'String')));
    else
        xsize=fix((str2num(get(handles.endedit,'String'))-xstart)/header.xstep)+1;
    end;
    for eventpos=1:length(eventcodes);
        update_status.function(update_status.handles,['Segmentation (epoch size : ',num2str(xsize),')'],1,0);
        neweventcode{1}=eventcodes{eventpos};
        update_status.function(update_status.handles,['Event code : ' neweventcode{1}],1,0);
        [header,data]=LW_segmentation2(inheader,indata,neweventcode,xstart,xsize);
        %save header data
        [p,n,e]=fileparts(inputfiles{filepos});
        st=[p,filesep,get(handles.prefixtext,'String'),'_',eventcodes{eventpos},' ',n,'.lw5'];
        LW_save(st,[],header,data);
    end;
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in outputmenu.
function outputmenu_Callback(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function outputmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in halfcheckbox.
function halfcheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to halfcheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on selection change in eventmenu.
function eventmenu_Callback(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function eventmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function startedit_Callback(hObject, eventdata, handles)
% hObject    handle to startedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function startedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to startedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function lowidthedit_Callback(hObject, eventdata, handles)
% hObject    handle to lowidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function lowidthedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lowidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function endedit_Callback(hObject, eventdata, handles)
% hObject    handle to endedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function endedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function hiwidthedit_Callback(hObject, eventdata, handles)
% hObject    handle to hiwidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function hiwidthedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to hiwidthedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function sizeedit_Callback(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function sizeedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sizeedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in epochendchk.
function epochendchk_Callback(hObject, eventdata, handles)
% hObject    handle to epochendchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.epochendchk,'Value')==1;
    set(handles.epochsizechk,'Value',0);
else
    set(handles.epochsizechk,'Value',1);
end;


% --- Executes on button press in epochsizechk.
function epochsizechk_Callback(hObject, eventdata, handles)
% hObject    handle to epochsizechk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.epochsizechk,'Value')==1;
    set(handles.epochendchk,'Value',0);
else
    set(handles.epochendchk,'Value',1);
end;
