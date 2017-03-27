function varargout = GLW_scalparray(varargin)
% GLW_SCALPARRAY MATLAB code for GLW_scalparray.fig
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
                   'gui_OpeningFcn', @GLW_scalparray_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_scalparray_OutputFcn, ...
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






function updategraph(handles);
%parameters (flatten_index,size_index)
flatten_index=str2num(get(handles.flattenedit,'String'));
size_index=str2num(get(handles.sizeedit,'String'));
%userdata and header
userdata=get(handles.filebox,'UserData');
header=userdata(1).header;
%list of selected channels
selected_channels=get(handles.chanbox,'Value');
%update list of selected channels (keeping only those with topo_enabled==1
chanpos2=1;
for chanpos=1:length(selected_channels);
    if header.chanlocs(selected_channels(chanpos)).topo_enabled==1;
        channels(chanpos2)=selected_channels(chanpos);
        chanpos2=chanpos2+1;
    end;
end;
%list of selected waves(filepos,epochpos,indexpos,ypos,zpos)
waves=get(handles.uitable,'UserData');
%wavestring
wavestring=get(handles.chanbox,'String');
wavestring=wavestring(channels);
%fetch data
tpdata=zeros(size(waves,1),length(channels),header.datasize(6));
for wavepos=1:size(waves,1);
    for chanpos=1:length(channels);
        ypos=waves(wavepos,4);
        zpos=waves(wavepos,5);
        dy=fix((ypos-header.ystart)/header.ystep)+1;
        dz=fix((zpos-header.zstart)/header.zstep)+1;
        tpdata(wavepos,chanpos,:)=squeeze(userdata(waves(wavepos,1)).data(waves(wavepos,2),channels(chanpos),waves(wavepos,3),dz,dy,:));
    end;
end;
%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;
%update axis edits if set to Auto
if get(handles.yautochk,'Value')==1;
    ymax=max(max(max(tpdata)))*1.1;
    ymin=min(min(min(tpdata)))*1.1;
    set(handles.yminedit,'String',num2str(ymin));
    set(handles.ymaxedit,'String',num2str(ymax));
end;
if get(handles.xautochk,'Value')==1;
    set(handles.xminedit,'String',num2str(tpx(1)));
    set(handles.xmaxedit,'String',num2str(tpx(length(tpx))));
end;
%xmin,xmax,ymin,ymax
xmin=str2num(get(handles.xminedit,'String'));
xmax=str2num(get(handles.xmaxedit,'String'));
ymin=str2num(get(handles.yminedit,'String'));
ymax=str2num(get(handles.ymaxedit,'String'));
%chanlocs
for chanpos=1:length(channels);
    chanlocs(chanpos,1)=header.chanlocs(channels(chanpos)).Y;
    chanlocs(chanpos,2)=header.chanlocs(channels(chanpos)).X;
    chanlocs(chanpos,3)=header.chanlocs(channels(chanpos)).Z;
end;
%chanlocs2
for chanpos=1:length(chanlocs);
    chanlocs2(chanpos,1)=chanlocs(chanpos,1)*(flatten_index-chanlocs(chanpos,3));
    chanlocs2(chanpos,2)=chanlocs(chanpos,2)*(flatten_index-chanlocs(chanpos,3));
end;
chanlocs2(:,1)=(chanlocs2(:,1)*(size_index*(xmax-xmin)))-((xmax-xmin)/2);
chanlocs2(:,2)=(chanlocs2(:,2)*(size_index*(ymax-ymin)))-((ymax-ymin)/2);
%dxmin,dxmax
dxmin=round((xmin-header.xstart)/header.xstep)+1;
dxmax=round((xmax-header.xstart)/header.xstep)+1;

%tpdata_x,tpdata_y
for chanpos=1:length(chanlocs2);
    tpdata_x(chanpos,:)=tpx(dxmin:dxmax)+chanlocs2(chanpos,1);
    for wavepos=1:size(waves,1);
        tpdata_y(wavepos,chanpos,:)=tpdata(wavepos,chanpos,dxmin:dxmax)+chanlocs2(chanpos,2);
    end;
end;
%min_x,min_y,max_x,max_y
min_x=min(min(tpdata_x));
max_x=max(max(tpdata_x));
min_y=min(min(min(tpdata_y)));
max_y=max(max(max(tpdata_y)));
%linestring
tbl=get(handles.uitable,'Data');
for i=1:size(waves,1);
    linestring{i}=tbl{i,6};
end;
%userdata2 and figure
userdata2=get(handles.chanbox,'UserData');
%figure
figure(userdata2.wavefigure);
subaxis(1,1,1,'MarginLeft',0.02,'MarginRight',0.02,'MarginTop',0.02,'MarginBottom',0.02);
for chanpos=1:length(chanlocs2);
    %draw axes in gray
    %horz
    plot([chanlocs2(chanpos,1)+xmin chanlocs2(chanpos,1)+xmax],[chanlocs2(chanpos,2) chanlocs2(chanpos,2)],'Color',[0.5 0.5 0.5]);
    hold on;
    %vert
    plot([chanlocs2(chanpos,1) chanlocs2(chanpos,1)],[chanlocs2(chanpos,2)+ymin chanlocs2(chanpos,2)+ymax],'Color',[0.5 0.5 0.5]);
    %draw waves
    for wavepos=1:size(waves,1);
        plot(squeeze(tpdata_x(chanpos,:)),squeeze(tpdata_y(wavepos,chanpos,:)),linestring{wavepos});
    end;
    %draw labels
    text(chanlocs2(chanpos,1)+xmin,chanlocs2(chanpos,2)+ymax,wavestring{chanpos});
end;
%set axis
axis([min_x max_x min_y max_y]);
%hide axis
set(gca,'XTick',[]);
set(gca,'YTick',[]);
set(gca,'XColor',[1 1 1]);
set(gca,'YColor',[1 1 1]);
hold off;





% --- Executes just before GLW_scalparray is made visible.
function GLW_scalparray_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_scalparray (see VARARGIN)
% Choose default command line output for GLW_scalparray
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
axis off;
%filebox
st=varargin{2};
set(handles.filebox,'String',st);
st=get(handles.filebox,'String');
for filepos=1:length(st);
    [p,n,e]=fileparts(st{filepos});
    inputfiles{filepos}=[n,e];
end;
set(handles.filebox,'String',inputfiles);
%inputdir
set(handles.inputdir,'String',p);
%UserData
for filepos=1:length(inputfiles);
    %load header data
    [header,data]=LW_load(inputfiles{filepos});
    userdata(filepos).header=header;
    userdata(filepos).data=data;
end;
%create figure
[userdata2.wavefigure userdata2.wavefigure_handles]=GLW_scalparray_figure;
userdata2.mother_handles=handles;
%assign userdata
set(handles.filebox,'UserData',userdata);
set(handles.chanbox,'UserData',userdata2);
%set filepos
set(handles.filebox,'Value',1);
%set chanbox
for chanpos=1:header.datasize(2);
    chanstring{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanbox,'String',chanstring);
set(handles.chanbox,'Value',1);
%set epochbox
for epochpos=1:header.datasize(1);
    epochstring{epochpos}=num2str(epochpos);
end;
set(handles.epochbox,'String',epochstring);
set(handles.epochbox,'Value',1);
%set indexpopup
if isfield(header,'indexlabels');
    for indexpos=1:header.datasize(3);
        indexstring{indexpos}=header.indexlabels{indexpos};
    end;
else
    for indexpos=1:header.datasize(3);
        indexstring{indexpos}=num2str(indexpos);
    end;
end;
set(handles.indexpopup,'String',indexstring);
set(handles.indexpopup,'Value',1);
%set yedit and zedit
set(handles.yedit,'String',num2str(header.ystart));
set(handles.zedit,'String',num2str(header.zstart));
%set line colors
st='kbgrcmy';
set(handles.linecoloredit,'UserData',st);
set(handles.linecoloredit,'Value',1);
%set line styles
st='-:';
set(handles.linestyleedit,'UserData',st);
set(handles.linestyleedit,'Value',1);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_scalparray_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on selection change in indexpopup.
function indexpopup_Callback(hObject, eventdata, handles)
% hObject    handle to indexpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function indexpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to indexpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function yedit_Callback(hObject, eventdata, handles)
% hObject    handle to yedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function yedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit_Callback(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function zedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in yautochk.
function yautochk_Callback(hObject, eventdata, handles)
% hObject    handle to yautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in yminedit.
function yminedit_Callback(hObject, eventdata, handles)
% hObject    handle to yminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.yautochk,'Value',0);




% --- Executes during object creation, after setting all properties.
function yminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




function ymaxedit_Callback(hObject, eventdata, handles)
% hObject    handle to ymaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.yautochk,'Value',0);




% --- Executes during object creation, after setting all properties.
function ymaxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ymaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in xautochk.
function xautochk_Callback(hObject, eventdata, handles)
% hObject    handle to xautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function xmaxedit_Callback(hObject, eventdata, handles)
% hObject    handle to xmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);





% --- Executes during object creation, after setting all properties.
function xmaxedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xmaxedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xminedit_Callback(hObject, eventdata, handles)
% hObject    handle to xminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);




% --- Executes during object creation, after setting all properties.
function xminedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xminedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in ydirchk.
function ydirchk_Callback(hObject, eventdata, handles)
% hObject    handle to ydirchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes on mouse motion over figure - except title and menu.
function figure_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in legendchk.
function legendchk_Callback(hObject, eventdata, handles)
% hObject    handle to legendchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata2=get(handles.chanbox,'UserData');
delete(userdata2.wavefigure);
delete(hObject);





% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
waves=get(handles.uitable,'UserData');
tbl=get(handles.uitable,'Data');
%update waves(wavepos,[filepos,epochpos,indexpos,ypos,zpos])
if isempty(waves);
    wavepos=1;
else
    wavepos=size(waves,1)+1;
end;
waves(wavepos,1)=get(handles.filebox,'Value');
waves(wavepos,2)=get(handles.epochbox,'Value');
waves(wavepos,3)=get(handles.indexpopup,'Value');
waves(wavepos,4)=str2num(get(handles.yedit,'String'));
waves(wavepos,5)=str2num(get(handles.zedit,'String'));
%update tbl
st=get(handles.filebox,'String');
tbl{wavepos,1}=st{waves(wavepos,1)};
st=get(handles.epochbox,'String');
tbl{wavepos,2}=st{waves(wavepos,2)};
st=get(handles.indexpopup,'String');
tbl{wavepos,3}=st{waves(wavepos,3)};
tbl{wavepos,4}=num2str(waves(wavepos,4));
tbl{wavepos,5}=num2str(waves(wavepos,5));
%linestring
st1=get(handles.linecoloredit,'UserData');
st2=get(handles.linestyleedit,'UserData');
v1=get(handles.linecoloredit,'Value');
v2=get(handles.linestyleedit,'Value');
st3=[st1(v1) st2(v2)];
tbl{wavepos,6}=st3;
v1=v1+1;
if v1>length(st1);
    v1=1;
end;
set(handles.linecoloredit,'Value',v1);
set(handles.linestyleedit,'Value',v2);
%store
set(handles.uitable,'UserData',waves);
set(handles.uitable,'Data',tbl);





% --- Executes on button press in pushbutton12.
function pushbutton12_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.chanbox,'String');
set(handles.chanbox,'Value',[1:1:length(st)]);




% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chanbox,'Value',[]);




function flattenedit_Callback(hObject, eventdata, handles)
% hObject    handle to flattenedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function flattenedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to flattenedit (see GCBO)
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



function linecoloredit_Callback(hObject, eventdata, handles)
% hObject    handle to linecoloredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function linecoloredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linecoloredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton14.
function pushbutton14_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton14 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes on button press in labelschk.
function labelschk_Callback(hObject, eventdata, handles)
% hObject    handle to labelschk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function linestyleedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linestyleedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
