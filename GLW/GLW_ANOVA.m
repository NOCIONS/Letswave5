function varargout = GLW_ANOVA(varargin)
%GLW_ANOVA M-file for GLW_ANOVA.fig
%      GLW_ANOVA, by itself, creates a new GLW_ANOVA or raises the existing
%      singleton*.
%
%      H = GLW_ANOVA returns the handle to a new GLW_ANOVA or the handle to
%      the existing singleton*.
%
%      GLW_ANOVA('Property','Value',...) creates a new GLW_ANOVA using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GLW_ANOVA_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GLW_ANOVA('CALLBACK') and GLW_ANOVA('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GLW_ANOVA.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GLW_ANOVA

% Last Modified by GUIDE v2.5 15-Dec-2013 14:11:15

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ANOVA_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ANOVA_OutputFcn, ...
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








% --- Executes just before GLW_ANOVA is made visible.
function GLW_ANOVA_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for GLW_ANOVA
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%clear table
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
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
inputfiles=get(handles.filebox,'String');
fig_title=get(handles.figure,'Name');
disp('*** Starting.');
set(handles.figure,'Name',[fig_title ' (Running']);
%headers datas
for i=1:length(inputfiles);
    [headers(i).header,datas(i).data]=LW_load(inputfiles{i});
end;
%groups
%groups : matrix n datafiles x m groups
groups=cell2mat(get(handles.uitable,'Data'));
groups=groups-1;
%within
%within : vector of m groups (0=between;1=within)
factors=get(handles.factoredit,'UserData');
for i=1:length(factors);
    within(i)=factors(i).within;
    label{i}=factors(i).label;
end;

%within_levels, within_labels
if isempty(find(within==1));
    within_levels=[];
    within_labels={};
else
    within_levels=groups(:,find(within==1));
    within_labels=label(find(within==1));
end;

%between_levels, between_labels
if isempty(find(within==0));
    between_levels=[];
    between_labels={};
else
    between_levels=groups(:,find(within==0));
    between_labels=label(find(within==0));
end;

within_levels
within_labels
between_levels
between_labels

%anovan
disp('*** Computing ANOVA (this may take a while!)');
[outheader_pvalue,outdata_pvalue,outheader_Fvalue,outdata_Fvalue]=LW_custANOVA(headers,datas,within_levels,within_labels,between_levels,between_labels);
%save pvalues
[p n e]=fileparts(inputfiles{1});
[p2 n2 e2]=fileparts(get(handles.prefixtext_p,'String'));
st=[p filesep n2 '.lw5'];
LW_save(st,[],outheader_pvalue,outdata_pvalue);
%save Fvalues
[p2 n2 e2]=fileparts(get(handles.prefixtext_F,'String'));
st=[p filesep n2 '.lw5'];
LW_save(st,[],outheader_Fvalue,outdata_Fvalue);
disp('*** Finished.');
set(handles.figure,'Name',fig_title);






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





% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
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



function prefixtext_F_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function prefixtext_F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixtext_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
