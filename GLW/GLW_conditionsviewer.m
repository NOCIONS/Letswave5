function varargout = GLW_conditionsviewer(varargin)
% GLW_CONDITIONSVIEWER MATLAB code for GLW_conditionsviewer.fig
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
                   'gui_OpeningFcn', @GLW_conditionsviewer_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_conditionsviewer_OutputFcn, ...
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





% --- Executes just before GLW_conditionsviewer is made visible.
function GLW_conditionsviewer_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_conditionsviewer (see VARARGIN)
% Choose default command line output for GLW_conditionsviewer
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%load header
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
%store header
set(handles.filebox,'UserData',header);
%load conditions if exists
if isfield(header,'condition_labels');
    set(handles.uitable,'ColumnName',header.condition_labels);
    set(handles.uitable,'Data',header.conditions);
    set(handles.correl1popup,'String',header.condition_labels);
    set(handles.correl2popup,'String',header.condition_labels);
    set(handles.correl1popup,'Value',1);
    set(handles.correl2popup,'Value',1);
    set(handles.conditionsbox,'String',header.condition_labels);
else
    msgbox('no conditions');
    return;
end;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_conditionsviewer_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on selection change in correl1popup.
function correl1popup_Callback(hObject, eventdata, handles)
% hObject    handle to correl1popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function correl1popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correl1popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in correl2popup.
function correl2popup_Callback(hObject, eventdata, handles)
% hObject    handle to correl2popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function correl2popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to correl2popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
condition_strings=get(handles.correl1popup,'String');
x_index=get(handles.correl1popup,'Value');
y_index=get(handles.correl2popup,'Value');
header=get(handles.filebox,'UserData');
x_data=header.conditions(:,x_index);
y_data=header.conditions(:,y_index);
figure;
scatter(x_data,y_data);
[R,P]=corrcoef(x_data,y_data);
xlim=get(gca,'XLim');
ylim=get(gca,'YLim');
title(['R=' num2str(R(1,2)) ' P=' num2str(P(1,2))]);
xlabel(condition_strings{x_index});
ylabel(condition_strings{y_index});



% --- Executes on selection change in conditionsbox.
function conditionsbox_Callback(hObject, eventdata, handles)
% hObject    handle to conditionsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function conditionsbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to conditionsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
condition_strings=get(handles.conditionsbox,'String');
selected=get(handles.conditionsbox,'Value');
header=get(handles.filebox,'UserData');
tpdata=header.conditions(:,selected);
tpstrings=condition_strings(selected);
for i=1:size(tpdata,2);
    tp=tpdata(:,i);
    tp(find(isnan(tp)))=[];
    mean_tpdata(i)=mean(tp);
    std_tpdata(i)=std(tp);
end;
figure;
tpx=zeros(size(tpdata,1),1);
hold on;
for i=1:size(tpdata,2);
    scatter(tpx+i,tpdata(:,i),'red');
end;
hold off;
set(gca,'XTick',1:1:size(tpdata,2));
set(gca,'XTickLabel',tpstrings);
set(gca,'XLim',[0 size(tpdata,2)+1]);



% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
condition_strings=get(handles.conditionsbox,'String');
selected=get(handles.conditionsbox,'Value');
header=get(handles.filebox,'UserData');
tpdata=header.conditions(:,selected);
tpstrings=condition_strings(selected);
for i=1:size(tpdata,2);
    tp=tpdata(:,i);
    tp(find(isnan(tp)))=[];
    mean_tpdata(i)=mean(tp);
    std_tpdata(i)=std(tp);
end;
figure;
barwitherr(std_tpdata,mean_tpdata);
set(gca,'XTickLabel',tpstrings);
