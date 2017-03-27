function varargout = GLW_editconditions(varargin)
% GLW_EDITCONDITIONS MATLAB code for GLW_editconditions.fig
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
                   'gui_OpeningFcn', @GLW_editconditions_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_editconditions_OutputFcn, ...
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





% --- Executes just before GLW_editconditions is made visible.
function GLW_editconditions_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_editconditions (see VARARGIN)
% Choose default command line output for GLW_editconditions
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%load header
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
%store header
set(handles.filebox,'UserData',header);
%load conditions if exists
if isfield(header,'condition_labels');
    if isempty(header.condition_labels);
    else
        set(handles.conditionbox,'String',header.condition_labels);
        set(handles.conditionbox,'Value',1);
        set(handles.conditionbox,'UserData',header.conditions);
        updatetable(handles);
    end;
else
    set(handles.conditionbox,'String',[]);
    set(handles.conditionbox,'Value',0);
    set(handles.conditionbox,'UserData',[]);
end;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_editconditions_OutputFcn(hObject, eventdata, handles) 
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
update_status.function(update_status.handles,'*** Editing conditions.',1,0);
%load header
update_status.function(update_status.handles,['Loading : ' inputfiles{1}],1,0);
header=LW_load_header(inputfiles{1});
%condition_labels
condition_labels=get(handles.conditionbox,'String');
%condition_data
condition_data=get(handles.conditionbox,'UserData');
%process
update_status.function(update_status.handles,'Adding conditions.',1,0);
[header]=LW_add_conditions(header,condition_labels,condition_data);
%save header
save(inputfiles{1},'-MAT','header');
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in conditionbox.
function conditionbox_Callback(hObject, eventdata, handles)
% hObject    handle to conditionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
storetable(handles);
updatetable(handles);




% --- Executes during object creation, after setting all properties.
function conditionbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conditionbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in addconditionbutton.
function addconditionbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addconditionbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
storetable(handles);
st=get(handles.conditionedit,'String');
condition_labels=get(handles.conditionbox,'String');
condition_labels{size(condition_labels,1)+1}=st;
set(handles.conditionbox,'String',condition_labels);
set(handles.conditionbox,'Value',1);
%userdata
header=get(handles.filebox,'UserData');
tp=zeros(header.datasize(1),1);
%update table
tab=get(handles.conditionbox,'UserData');
if isempty(tab);
    tab=tp;
else
    tab=horzcat(tab,tp);
end;
set(handles.conditionbox,'UserData',tab);
set(handles.conditionbox,'Value',size(tab,2));
updatetable(handles);




function updatetable(handles);
%selected condition
selected=get(handles.conditionbox,'Value');
%header
header=get(handles.filebox,'UserData');
%trial column
for trialpos=1:header.datasize(1);
    ftab{trialpos,1}=num2str(trialpos);
end;
%data
tab=get(handles.conditionbox,'UserData');
%value column
for trialpos=1:header.datasize(1);
    ftab{trialpos,2}=num2str(tab(trialpos,selected));
end;
%update uitable
set(handles.uitable,'UserData',selected);
set(handles.uitable,'Data',ftab);
    



function storetable(handles);
%selected
selected=get(handles.uitable,'UserData');
if selected>0;
    %table
    ftab=get(handles.uitable,'Data');
    %header
    header=get(handles.filebox,'UserData');
    %tab
    tab=get(handles.conditionbox,'UserData');
    %read values
    ok=1;
    for trialpos=1:header.datasize(1);
        tp=str2num(ftab{trialpos,2});
        if isempty(tp);
            ok=0;
        end;
    end;
    if ok==0;
        msgbox('Error : Only numerical values can be used for condition data');
        return;
    else
        for trialpos=1:header.datasize(1);
            tab(trialpos,selected)=str2num(ftab{trialpos,2});
        end;
        %update tab
        set(handles.conditionbox,'UserData',tab);
    end;
end;



function conditionedit_Callback(hObject, eventdata, handles)
% hObject    handle to conditionedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function conditionedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conditionedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in applybutton.
function applybutton_Callback(hObject, eventdata, handles)
% hObject    handle to applybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
storetable(handles);




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch var in base workspace
tp=evalin('base',get(handles.matedit,'String'));
%header
header=get(handles.filebox,'UserData');
%data
tab=get(handles.conditionbox,'UserData');
%selection
selected=get(handles.uitable,'UserData');
if selected>0;
    %update data with matvar
    if size(tp,1)==header.datasize(1);
        for trialpos=1:header.datasize(1);
            tab(trialpos,selected)=tp(trialpos);
        end;
        set(handles.conditionbox,'UserData',tab);
        updatetable(handles);
    else
        if size(tp,2)==header.datasize(1);
            for trialpos=1:header.datasize(1);
                tab(trialpos,selected)=tp(trialpos);
            end;
            set(handles.conditionbox,'UserData',tab);
            updatetable(handles);
        else
            msgbox('Invalid matlab variable.');
        end;
    end;
else
    msgbox('You must first create a condition');
end;




function matedit_Callback(hObject, eventdata, handles)
% hObject    handle to matedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function matedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to matedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function textfileedit_Callback(hObject, eventdata, handles)
% hObject    handle to textfileedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function textfileedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textfileedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
FilterSpec={'*.txt';'*.TXT';'*.asc';'*.ASC'}
filename=uigetfile(FilterSpec);
if filename==0;
else
    if exist(filename);
        tp=load(filename,'-ascii');
        %header
        header=get(handles.filebox,'UserData');
        %data
        tab=get(handles.conditionbox,'UserData');
        %selection
        selected=get(handles.uitable,'UserData');
        if selected>0
            %update data with matvar
            if size(tp,1)==header.datasize(1);
                for trialpos=1:header.datasize(1);
                    tab(trialpos,selected)=tp(trialpos);
                end;
                set(handles.conditionbox,'UserData',tab);
                updatetable(handles);
            else
                if size(tp,2)==header.datasize(1);
                    for trialpos=1:header.datasize(1);
                        tab(trialpos,selected)=tp(trialpos);
                    end;
                    set(handles.conditionbox,'UserData',tab);
                    updatetable(handles);
                else
                    msgbox('Invalid textfile.');
                end;
            end;
        else
            msgbox('You must first create a condition');
        end;
    end;
end;


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
disp('*** Starting.');
for i=1:length(inputfiles);
    %load header
    header=LW_load_header(inputfiles{i});
    %condition_labels
    condition_labels=[];
    %condition_data
    condition_data=[];
    %process
    disp('*** Deleting conditions');
    %add condition_headers
    if isfield(header,'condition_labels')==1;
        header=rmfield(header,'condition_labels');
    end;
    if isfield(header,'conditions')==1;
        header=rmfield(header,'conditions');
    end;
    LW_save_header(inputfiles{i},[],header);
    disp('*** Finished.');
end;
