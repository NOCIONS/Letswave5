function varargout = GLW_ANOVA(varargin)
% GLW_ANOVA MATLAB code for GLW_ANOVA.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ANOVA_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ANOVA_OutputFcn, ...
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





% --- Executes just before GLW_ANOVA is made visible.
function GLW_ANOVA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ANOVA (see VARARGIN)
% Choose default command line output for GLW_ANOVA
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%clear table
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
set(handles.uitable2,'ColumnName',{});
set(handles.uitable2,'Data',{});
set(handles.factoredit,'UserData',{});
%inputfiles
inputfiles=get(handles.filebox,'String');
%cleanfiles
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
%set RowName
set(handles.uitable,'RowName',cleanfiles);






% --- Outputs from this function are returned to the command line.
function varargout = GLW_ANOVA_OutputFcn(hObject, eventdata, handles) 
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
fig_title=get(handles.figure,'Name');
disp('*** Starting.');
set(handles.figure,'Name',[fig_title ' (Running']);
%headers
for i=1:length(inputfiles);
    disp(['Loading header : ' inputfiles{i}]);
    load(inputfiles{i},'-mat');
    headers(i).header=header;
end;
%datas
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    inputfile=[p filesep n '.mat'];
    disp(['Loading data : ' inputfile]);
    load(inputfile,'-mat');
    datas(i).data=data;
end;
%groups
%groups : matrix n datafiles x m groups
groups=cell2mat(get(handles.uitable,'Data'));
%within
%within : vector of m groups (0=between;1=within)
factors=get(handles.factoredit,'UserData');
for i=1:length(factors);
    within(i)=factors(i).within;
end;
%model
%model : matrix n outputs x m groups
model=cell2mat(get(handles.uitable2,'Data'));
%anovan
disp('*** Computing ANOVA (this may take a while!)');
[header,data]=LW_mmanova(headers,datas,groups,within,model');
%save
[p2 n2 e2]=fileparts(get(handles.prefixtext,'String'));
st=[p filesep n2 '.lw5'];
%save header
disp(['saving ',st]);
save(st,'-MAT','header');
%save data
st=[p filesep n2 '.mat'];
save(st,'-MAT','data');
disp('*** Finished.');
set(handles.figure,'Name',fig_title);




% --- Executes on button press in addwithinbutton.
function addwithinbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addwithinbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.factoredit,'String');
factordata=get(handles.factoredit,'UserData');
tp=length(factordata)+1;
factordata(tp).label=st;
factordata(tp).within=1;
set(handles.factoredit,'UserData',factordata);
update_table_headers(handles);
%table data
data=get(handles.uitable,'Data');
numrows=get(handles.uitable,'RowName');
tp=num2cell(ones(length(numrows),1));
data=horzcat(data,tp);
set(handles.uitable,'Data',data);
%uitable2 data
data=get(handles.uitable2,'Data');
if isempty(data);
else
tp=num2cell(zeros(size(data,1),1));
    data=horzcat(data,tp);
    set(handles.uitable2,'Data',data);
end;






function update_table_headers(handles);
factordata=get(handles.factoredit,'UserData');
factorstring={};
for i=1:length(factordata);
    if factordata(i).within==1;
        factorstring{i}=['W:' factordata(i).label];
    else
        factorstring{i}=['B:' factordata(i).label];        
    end;
    editable(i)=true;
end;
set(handles.uitable,'ColumnName',factorstring);
set(handles.uitable,'ColumnEditable',editable);
set(handles.uitable2,'ColumnName',factorstring);
set(handles.uitable2,'ColumnEditable',editable);







function factoredit_Callback(hObject, eventdata, handles)
% hObject    handle to factoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function factoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to factoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in addbetweenbutton.
function addbetweenbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbetweenbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.factoredit,'String');
factordata=get(handles.factoredit,'UserData');
tp=length(factordata)+1;
factordata(tp).label=st;
factordata(tp).within=0;
set(handles.factoredit,'UserData',factordata);
update_table_headers(handles);
%table data
data=get(handles.uitable,'Data');
numrows=get(handles.uitable,'RowName');
tp=num2cell(ones(length(numrows),1));
data=horzcat(data,tp);
set(handles.uitable,'Data',data);
%uitable2 data
data=get(handles.uitable2,'Data');
if isempty(data);
else
tp=num2cell(zeros(size(data,1),1));
    data=horzcat(data,tp);
    set(handles.uitable2,'Data',data);
end;


% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
set(handles.uitable2,'ColumnName',{});
set(handles.uitable2,'Data',{});
set(handles.factoredit,'UserData',{});






% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%table data
st=get(handles.factoredit,'UserData');
length(st)
data=get(handles.uitable2,'Data');
if isempty(data);
    %data=num2cell(zeros(1,length(st)));
    data=num2cell(zeros(1,length(st)));
else
    data=vertcat(data,num2cell(zeros(1,length(st))))
end;
set(handles.uitable2,'Data',data);


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%clear table
set(handles.uitable2,'Data',{});
