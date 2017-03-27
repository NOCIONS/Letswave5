function varargout = GLW_math(varargin)
% GLW_math MATLAB code for GLW_math.fig
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
% Last Modified by GUIDE v2.5 08-Jun-2012 08:27:34





% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_math_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_math_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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





% --- Executes just before GLW_math is made visible.
function GLW_math_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill filebox with inputfiles
st=varargin{2};
set(handles.filebox,'UserData',st);
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
%fill filebox2 with inputfiles
set(handles.filebox2,'String',cleanfiles);
%select first file
set(handles.filebox2,'Value',1);
%update boxes
update_boxes(handles);





function update_boxes(handles);
selected2=get(handles.filebox2,'Value');
inputfiles=get(handles.filebox,'String');
selected1=1:1:length(inputfiles);
selected1(selected2)=[];
set(handles.filebox1,'String',inputfiles(selected1));
%load header
headerfiles=get(handles.filebox,'UserData');
header=LW_load_header(headerfiles{selected2});
%epochbox
st={};
for i=1:header.datasize(1);
    st{i}=num2str(i);
end;
set(handles.epochbox,'String',st);
tp=get(handles.epochbox,'Value');
if tp>length(st);
    set(handles.epochbox,'Value',1);
end;
%channelbox
st={};
for i=1:header.datasize(2);
    st{i}=header.chanlocs(i).labels;
end;
set(handles.channelbox,'String',st);
tp=get(handles.channelbox,'Value');
if tp>length(st);
    set(handles.channelbox,'Value',1);
end;
%indexbox
st={};
for i=1:header.datasize(3);
    if isfield(header,'indexlabels');
        st{i}=header.indexlabels{i};
    else
        st{i}=num2str(i);
    end;
end;
set(handles.indexbox,'String',st);
tp=get(handles.indexbox,'Value');
if tp>length(st);
    set(handles.indexbox,'Value',1);
end;






% --- Outputs from this function are returned to the command line.
function varargout = GLW_math_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;





% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
inputfiles=get(handles.filebox,'UserData');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Math operations.',1,0);
epoch_chk=get(handles.epochchk,'Value');
channel_chk=get(handles.channelchk,'Value');
index_chk=get(handles.indexchk,'Value');
%inputfiles2/inputfiles1
selected2=get(handles.filebox2,'Value');
selected1=1:1:length(inputfiles);
selected1(selected2)=[];
inputfiles2=inputfiles{selected2};
inputfiles1=inputfiles(selected1);
%load inputfile2
update_status.function(update_status.handles,['Loading : ' inputfiles2],1,0);
[header2,data2]=LW_load(inputfiles2);
%operation
operations={'add','subtract','multiply','divide'};
operation=operations{get(handles.operationbox,'Value')};
update_status.function(update_status.handles,['Mathematical operation : ' operation],1,0);
%loop through inputfiles1
for filepos=1:length(inputfiles1);
    %load header1 data1
    update_status.function(update_status.handles,['Loading : ' inputfiles1{filepos}],1,0);
    [header1,data1]=LW_load(inputfiles1{filepos});
    %process
    update_status.function(update_status.handles,'Computing math operation.',1,0);
    %which LW_math function to use
    if and(and(epoch_chk==0,channel_chk==0),index_chk==0);
        %use LW_math
        update_status.function(update_status.handles,'No specific epoch,channel or index selected, using the faster LW_math function',1,0);
        [header,data]=LW_math(header1,data1,header2,data2,operation);
    else
        %use LW_math2
        update_status.function(update_status.handles,'Specific epoch,channel of index selected, using the slower LW_math2 function',1,0);
        if epoch_chk==0;
            epochpos=0;
        else
            epochpos=get(handles.epochbox,'Value');
        end;
        if channel_chk==0;
            channelpos=0;
        else
            channelpos=get(handles.channelbox,'Value');
        end;
        if index_chk==0;
            indexpos=0;
        else
            indexpos=get(handles.indexbox,'Value');
        end;
        [header,data]=LW_math2(header1,data1,header2,data2,epochpos,channelpos,indexpos,operation);
    end;
    %save header data
    LW_save(inputfiles1{filepos},get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




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




% --- Executes on selection change in filebox1.
function filebox1_Callback(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function filebox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in filebox2.
function filebox2_Callback(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_boxes(handles);




% --- Executes during object creation, after setting all properties.
function filebox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





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





% --- Executes on selection change in operationbox.
function operationbox_Callback(hObject, eventdata, handles)
% hObject    handle to operationbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function operationbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operationbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in epochchk.
function epochchk_Callback(hObject, eventdata, handles)
% hObject    handle to epochchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on selection change in epochbox.
function epochbox_Callback(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in channelchk.
function channelchk_Callback(hObject, eventdata, handles)
% hObject    handle to channelchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on selection change in channelbox.
function channelbox_Callback(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function channelbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in indexchk.
function indexchk_Callback(hObject, eventdata, handles)
% hObject    handle to indexchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on selection change in indexbox.
function indexbox_Callback(hObject, eventdata, handles)
% hObject    handle to indexbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function indexbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to indexbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
