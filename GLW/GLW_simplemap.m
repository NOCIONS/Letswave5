function varargout = GLW_simplemap(varargin)
% GLW_SIMPLEMAP MATLAB code for GLW_simplemap.fig
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
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_simplemap_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_simplemap_OutputFcn, ...
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





% --- Executes just before GLW_simplemap is made visible.
function GLW_simplemap_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_simplemap (see VARARGIN)
handles.output = hObject;
guidata(hObject, handles);
inputfiles=varargin{2};
%load header
[p,n,e]=fileparts(inputfiles);
st=[p,filesep,n,'.lw5'];
[header,data]=LW_load(st);
dispdata.header=header;
dispdata.data=data;
%fill epochbox
for epochpos=1:size(dispdata.data,1);
    epochlist{epochpos}=[int2str(epochpos)];
end;
set(handles.epochbox,'String',epochlist);
%fill channelbox
for channelpos=1:size(dispdata.data,2);
    channellist{channelpos}=dispdata.header.chanlocs(channelpos).labels;
end;
set(handles.channelbox,'String',channellist);
%fill indexpopup
if isfield(dispdata.header,'indexlabels');
    for indexpos=1:size(dispdata.data,3);
        indexlist{indexpos}=dispdata.header.indexlabels{indexpos};
    end;
else
    for indexpos=1:size(dispdata.data,3);
        indexlist{indexpos}=num2str(indexpos);
    end;
end;
set(handles.indexpopup,'String',indexlist);
%set zedit
set(handles.zedit,'String',num2str(dispdata.header.zstart));
%set xleftedit,xrightedit,ybottomedit,ytopedit,zlowedit,zhighedit
set(handles.xleftedit,'String','0');
set(handles.xrightedit,'String','0');
set(handles.ybottomedit,'String','0');
set(handles.ytopedit,'String','0');
set(handles.zlowedit,'String','0');
set(handles.zhighedit,'String','0');
%hide unnecessary items
if dispdata.header.datasize(3)==1;
    set(handles.indextext,'Visible','off');
    set(handles.indexpopup,'Visible','off');
end;
if dispdata.header.datasize(4)==1;
    set(handles.zpositiontext,'Visible','off');
    set(handles.zedit,'Visible','off');
end;
%hide scalpmap buttons if no chanlocs data
chanlocs_ok=0;
for chanpos=1:length(dispdata.header.chanlocs);
    if dispdata.header.chanlocs(chanpos).topo_enabled==1;
        chanlocs_ok=1;
    end;
end;
if chanlocs_ok==0;
    set(handles.scalppopup,'Enable','off');
    set(handles.topobutton,'Enable','off');
    set(handles.headbutton,'Enable','off');
end;
if isfield(dispdata.header,'filename_spl');
else;
    set(handles.headbutton,'Enable','off');
end;
%userdata
set(handles.epochbox,'UserData',dispdata);
%create figure
updategraph(handles);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_simplemap_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;




% --- Executes on selection change in channelbox.
function channelbox_Callback(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function channelbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
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
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function epochbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called




% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.channelbox,'String','test');




% --- Executes on selection change in indexpopup.
function indexpopup_Callback(hObject, eventdata, handles)
% hObject    handle to indexpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




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




function xleftedit_Callback(hObject, eventdata, handles)
% hObject    handle to xleftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function xleftedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xleftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xrightedit_Callback(hObject, eventdata, handles)
% hObject    handle to xrightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function xrightedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xrightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ybottomedit_Callback(hObject, eventdata, handles)
% hObject    handle to ybottomedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.yautochk,'Value',0);
updategraph(handles);



% --- Executes during object creation, after setting all properties.
function ybottomedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ybottomedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function ytopedit_Callback(hObject, eventdata, handles)
% hObject    handle to ytopedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.yautochk,'Value',0);
updategraph(handles);



% --- Executes during object creation, after setting all properties.
function ytopedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ytopedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in xautochk.
function xautochk_Callback(hObject, eventdata, handles)
% hObject    handle to xautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes on button press in yautochk.
function yautochk_Callback(hObject, eventdata, handles)
% hObject    handle to yautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes on selection change in graphpopup.
function graphpopup_Callback(hObject, eventdata, handles)
% hObject    handle to graphpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function graphpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to graphpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Update graphs ---
function updategraph(handles);
%tpdata(graphs,plots,x)
%data
dispdata=get(handles.epochbox,'UserData');
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get z position
zpos=str2num(get(handles.zedit,'String'));
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%set tpx;
tpx=1:1:size(dispdata.data,6);
tpx=((tpx-1)*dispdata.header.xstep)+dispdata.header.xstart;
%set tpy;
tpy=1:1:size(dispdata.data,5);
tpy=((tpy-1)*dispdata.header.ystep)+dispdata.header.ystart;
%fetch data (tpdata)
tp=get(handles.graphpopup,'Value');
%multiple epochs
if tp==1
    tpdata=zeros(length(epochs),size(dispdata.data,5),size(dispdata.data,6));
    for epochi=1:length(epochs);
        tpdata(epochi,:,:)=squeeze(dispdata.data(epochs(epochi),channels(1),index,dz,:,:));
    end;
end;
if tp==2;
    tpdata=zeros(length(channels),size(dispdata.data,5),size(dispdata.data,6));
    for channeli=1:length(channels);
        tpdata(channeli,:,:)=squeeze(dispdata.data(epochs(1),channels(channeli),index,dz,:,:));
    end;
end;
%update axis edits if set to Auto
%X-Axis
if get(handles.xautochk,'Value')==1;
    set(handles.xleftedit,'String',num2str(tpx(1)));
    set(handles.xrightedit,'String',num2str(tpx(length(tpx))));
end;
%Y-Axis
if get(handles.yautochk,'Value')==1;
    set(handles.ybottomedit,'String',num2str(tpy(1)));
    set(handles.ytopedit,'String',num2str(tpy(length(tpy))));
end;
%Z-Axis (colorscale)
if get(handles.zautochk,'Value')==1;
    zmax=max(max(max(tpdata)))*1.1;
    zmin=min(min(min(tpdata)))*1.1;
    set(handles.zlowedit,'String',num2str(zmin));
    set(handles.zhighedit,'String',num2str(zmax));
end;
%numgraphs 
numgraphs=size(tpdata,1);
%plot data (tpdata)
for graphpos=1:numgraphs;
    currentaxis(graphpos)=subaxis(numgraphs,1,graphpos,'MarginLeft',0.06,'MarginRight',0.01,'MarginTop',0.03,'MarginBottom',0.06);
    if get(handles.zautochk,'Value')==1;
        imagesc(tpx,tpy,squeeze(tpdata(graphpos,:,:)));
    else
        clim=[str2num(get(handles.zlowedit,'String')) str2num(get(handles.zhighedit,'String'))];
        imagesc(tpx,tpy,squeeze(tpdata(graphpos,:,:)),clim);
    end;
    if get(handles.xautochk,'Value')==0
        set(currentaxis,'XLim',[str2num(get(handles.xleftedit,'String')) str2num(get(handles.xrightedit,'String'))]);
    end;
    if get(handles.yautochk,'Value')==0
        set(currentaxis,'YLim',[str2num(get(handles.ybottomedit,'String')) str2num(get(handles.ytopedit,'String'))]);
    end; 
    if get(handles.ydircheck,'Value')==0;
        set(currentaxis,'YDir','normal');
    else
        set(currentaxis,'YDir','reverse');
    end;        
end;
set(handles.channelbox,'UserData',currentaxis);

    


% --- Executes on button press in smoothchk.
function smoothchk_Callback(hObject, eventdata, handles)
% hObject    handle to smoothchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes on button press in xbutton.
function xbutton_Callback(hObject, eventdata, handles)
% hObject    handle to xbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);
updategraph(handles);




% --- Executes on button press in ybutton.
function ybutton_Callback(hObject, eventdata, handles)
% hObject    handle to ybutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.xautochk,'Value',0);
updategraph(handles);




% --- Executes on mouse motion over figure - except title and menu.
function figure_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
set(handles.xtext,'String',num2str(currentpoint(1,1)));
set(handles.ytext,'String',num2str(currentpoint(1,2)));





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
cursor11=currentpoint(1,1);
cursor12=currentpoint(1,2);
set(handles.xtext1,'String',num2str(cursor11));
set(handles.ytext1,'String',num2str(cursor12));
updategraph(handles);
%draw cursor
for i=1:length(currentaxis);
    subplot(currentaxis(i));
    hold on;
    ylim=get(currentaxis(i),'YLim');
    plot([cursor11 cursor11],ylim,'k--');
    xlim=get(currentaxis(i),'XLim');
    plot(xlim,[cursor12 cursor12],'k--');
    hold off;
end;
cursors=get(handles.indexpopup,'UserData');
cursors.cursor11=cursor11;
cursors.cursor12=cursor12;
set(handles.indexpopup,'UserData',cursors);



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
cursor21=currentpoint(1,1);
cursor22=currentpoint(1,2);
set(handles.xtext2,'String',num2str(cursor21));
set(handles.ytext2,'String',num2str(cursor22));
%draw cursor
for i=1:length(currentaxis);
    subplot(currentaxis(i));
    hold on;
    ylim=get(currentaxis(i),'YLim');
    plot([cursor21 cursor21],ylim,'k--');
    xlim=get(currentaxis(i),'XLim');
    plot(xlim,[cursor22 cursor22],'k--');
    hold off;
end;
cursors=get(handles.indexpopup,'UserData');
cursors.cursor21=cursor21;
cursors.cursor22=cursor22;
set(handles.indexpopup,'UserData',cursors);




% --- Executes on button press in peakbutton.
function peakbutton_Callback(hObject, eventdata, handles)
% hObject    handle to peakbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cursors=get(handles.indexpopup,'UserData');
cursor11=cursors.cursor11;
cursor12=cursors.cursor12;
cursor21=cursors.cursor21;
cursor22=cursors.cursor22;
dispdata=get(handles.epochbox,'UserData');
%set colnames
colnames{1}='epoch';
colnames{2}='channel';
colnames{3}='min (x)';
colnames{4}='min (y)';
colnames{5}='min (z)';
colnames{6}='max (x)';
colnames{7}='max (y)';
colnames{8}='max (z)';
%set tdata
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get z position
zpos=str2num(get(handles.zedit,'String'));
dz=fix(((zpos-dispdata.header.zstart)/dispdata.header.zstep))+1;
%dcursor (bin positions of cursor11,cursor12,cursor21,cursor22)
dcursor11=round(((cursor11-dispdata.header.xstart)/dispdata.header.xstep)+1);
dcursor21=round(((cursor21-dispdata.header.xstart)/dispdata.header.xstep)+1);
if dcursor11>dcursor21
    dcursortp=dcursor11;
    dcursor11=dcursor21;
    dcursor21=dcursortp;
end;
%
dcursor12=round(((cursor12-dispdata.header.ystart)/dispdata.header.ystep)+1);
dcursor22=round(((cursor22-dispdata.header.ystart)/dispdata.header.ystep)+1);
if dcursor12>dcursor22
    dcursortp=dcursor12;
    dcursor12=dcursor22;
    dcursor22=dcursortp;
end;
%loop through selected epochs and channels
epochstring=get(handles.epochbox,'String');
channelstring=get(handles.channelbox,'String');
linepos=1;
for epochpos=1:length(epochs);
    for channelpos=1:length(channels);
        %col1 = epoch name
        tdata{linepos,1}=epochstring{epochs(epochpos)};
        %col2 = channel name
        tdata{linepos,2}=channelstring{channels(channelpos)};
        %fetchdata (min and max)
        tp=squeeze(dispdata.data(epochs(epochpos),channels(channelpos),index,dz,dcursor12:dcursor22,dcursor11:dcursor21));
        %dmaxx
        [i,j]=max(tp,[],2);
        [i2,j2]=max(i);
        dmaxx=j(j2);
        maxz=i2;
        %dminx
        [i,j]=min(tp,[],2);
        [i2,j2]=min(i);
        dminx=j(j2);
        minz=i2;
        %dmaxy
        [i,j]=max(tp,[],1);
        [i2,j2]=max(i);
        dmaxy=j(j2);
        %dminy
        [i,j]=min(tp,[],1);
        [i2,j2]=min(i);
        dminy=j(j2);
        dmaxx=dmaxx+dcursor11;
        dminx=dminx+dcursor11;
        dmaxy=dmaxy+dcursor12;
        dminy=dminy+dcursor12;
        maxx=((dmaxx-1)*dispdata.header.xstep)+dispdata.header.xstart;
        minx=((dminx-1)*dispdata.header.xstep)+dispdata.header.xstart;
        maxy=((dmaxy-1)*dispdata.header.ystep)+dispdata.header.ystart;
        miny=((dminy-1)*dispdata.header.ystep)+dispdata.header.ystart;
        tdata{linepos,3}=num2str(minx);
        tdata{linepos,4}=num2str(miny);
        tdata{linepos,5}=num2str(minz);
        tdata{linepos,6}=num2str(maxx);
        tdata{linepos,7}=num2str(maxy);
        tdata{linepos,8}=num2str(maxz);
        linepos=linepos+1;
    end;
end;   
%launch table
GLW_simplemap_table(tdata,colnames);



% --- Executes on button press in topobutton.
function topobutton_Callback(hObject, eventdata, handles)
% hObject    handle to topobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cursors=get(handles.indexpopup,'UserData');
cursor11=cursors.cursor11;
cursor12=cursors.cursor12;
cursor21=cursors.cursor21;
cursor22=cursors.cursor22;
dispdata=get(handles.epochbox,'UserData');
%set scalpdata (LW_topoplot(data,epoch,index,x,y,z,varargin))
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get z position
zpos=str2num(get(handles.zedit,'String'));
dz=fix(((zpos-dispdata.header.zstart)/dispdata.header.zstep))+1;
%dcursor (bin positions of cursor11,cursor12,cursor21,cursor22)
dcursor11=round(((cursor11-dispdata.header.xstart)/dispdata.header.xstep)+1);
dcursor21=round(((cursor21-dispdata.header.xstart)/dispdata.header.xstep)+1);
if dcursor11>dcursor21
    dcursortp=dcursor11;
    dcursor11=dcursor21;
    dcursor21=dcursortp;
end;
%
dcursor12=round(((cursor12-dispdata.header.ystart)/dispdata.header.ystep)+1);
dcursor22=round(((cursor22-dispdata.header.ystart)/dispdata.header.ystep)+1);
if dcursor12>dcursor22
    dcursortp=dcursor12;
    dcursor12=dcursor22;
    dcursor22=dcursortp;
end;
%launch figure;
topofigure=figure;
set(topofigure,'ToolBar','none');
%loop through selected epochs (will plot one scalp map per selected epoch)
for epochpos=1:length(epochs);
    %find maximum and minimum
    tp=squeeze(dispdata.data(epochs(epochpos),channels(1),index,dz,dcursor12:dcursor22,dcursor11:dcursor21));
    %dmaxx
    [i,j]=max(tp,[],2);
    [i2,j2]=max(i);
    dmaxx=j(j2);
    %dminx
    [i,j]=min(tp,[],2);
    [i2,j2]=min(i);
    dminx=j(j2);
    %dmaxy
    [i,j]=max(tp,[],1);
    [i2,j2]=max(i);
    dmaxy=j(j2);
    %dminy
    [i,j]=min(tp,[],1);
    [i2,j2]=min(i);
    dminy=j(j2);
    dmaxx=dmaxx+dcursor11;
    dminx=dminx+dcursor11;
    dmaxy=dmaxy+dcursor12;
    dminy=dminy+dcursor12;
    %maxx,maxy
    maxx=((dmaxx-1)*dispdata.header.xstep)+dispdata.header.xstart;
    minx=((dminx-1)*dispdata.header.xstep)+dispdata.header.xstart;
    maxy=((dmaxy-1)*dispdata.header.ystep)+dispdata.header.ystart;
    miny=((dminy-1)*dispdata.header.ystep)+dispdata.header.ystart;
    %subplot
    tpaxis=subaxis(1,length(epochs),epochpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.05,'MarginBottom',0.01);
    chanstring=get(handles.channelbox,'String');
    if get(handles.scalppopup,'Value')==1
        dx=dmaxx;
        dy=dmaxy;
        st=['MAX (',num2str(epochs(epochpos)),':',chanstring{channels(1)},') X=',num2str(maxx),' Y=',num2str(maxy)];
    else
        dx=dminx;
        dy=dminy;
        st=['MIN (',num2str(epochs(epochpos)),':',chanstring{channels(1)},') X=',num2str(minx),' Y=',num2str(miny)];
    end;
    tpaxis=LW_topoplot(dispdata.header,dispdata.data,epochs(epochpos),index,dx,dy,dz,'shading','interp','whitebk','on');
    title(gca,st);
end;




% --- Executes on selection change in scalppopup.
function scalppopup_Callback(hObject, eventdata, handles)
% hObject    handle to scalppopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function scalppopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to scalppopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ydircheck.
function ydircheck_Callback(hObject, eventdata, handles)
% hObject    handle to ydircheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);



function zlowedit_Callback(hObject, eventdata, handles)
% hObject    handle to zlowedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.zautochk,'Value',0);
updategraph(handles);





% --- Executes during object creation, after setting all properties.
function zlowedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zlowedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function zhighedit_Callback(hObject, eventdata, handles)
% hObject    handle to zhighedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.zautochk,'Value',0);
updategraph(handles);



% --- Executes during object creation, after setting all properties.
function zhighedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zhighedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in zautochk.
function zautochk_Callback(hObject, eventdata, handles)
% hObject    handle to zautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);




% --- Executes on button press in headbutton.
function headbutton_Callback(hObject, eventdata, handles)
% hObject    handle to headbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cursors=get(handles.indexpopup,'UserData');
cursor11=cursors.cursor11;
cursor12=cursors.cursor12;
cursor21=cursors.cursor21;
cursor22=cursors.cursor22;
dispdata=get(handles.epochbox,'UserData');
%set scalpdata (LW_topoplot(data,epoch,index,x,y,z,varargin))
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get z position
zpos=str2num(get(handles.zedit,'String'));
dz=fix(((zpos-dispdata.header.zstart)/dispdata.header.zstep))+1;
%dcursor (bin positions of cursor11,cursor12,cursor21,cursor22)
dcursor11=round(((cursor11-dispdata.header.xstart)/dispdata.header.xstep)+1);
dcursor21=round(((cursor21-dispdata.header.xstart)/dispdata.header.xstep)+1);
if dcursor11>dcursor21
    dcursortp=dcursor11;
    dcursor11=dcursor21;
    dcursor21=dcursortp;
end;
%
dcursor12=round(((cursor12-dispdata.header.ystart)/dispdata.header.ystep)+1);
dcursor22=round(((cursor22-dispdata.header.ystart)/dispdata.header.ystep)+1);
if dcursor12>dcursor22
    dcursortp=dcursor12;
    dcursor12=dcursor22;
    dcursor22=dcursortp;
end;
%launch figure;
topofigure=figure;
set(topofigure,'ToolBar','none');
%loop through selected epochs (will plot one scalp map per selected epoch)
for epochpos=1:length(epochs);
    %find maximum and minimum
    tp=squeeze(dispdata.data(epochs(epochpos),channels(1),index,dz,dcursor12:dcursor22,dcursor11:dcursor21));
    %dmaxx
    [i,j]=max(tp,[],2);
    [i2,j2]=max(i);
    dmaxx=j(j2);
    %dminx
    [i,j]=min(tp,[],2);
    [i2,j2]=min(i);
    dminx=j(j2);
    %dmaxy
    [i,j]=max(tp,[],1);
    [i2,j2]=max(i);
    dmaxy=j(j2);
    %dminy
    [i,j]=min(tp,[],1);
    [i2,j2]=min(i);
    dminy=j(j2);
    dmaxx=dmaxx+dcursor11;
    dminx=dminx+dcursor11;
    dmaxy=dmaxy+dcursor12;
    dminy=dminy+dcursor12;
    %maxx,maxy
    maxx=((dmaxx-1)*dispdata.header.xstep)+dispdata.header.xstart;
    minx=((dminx-1)*dispdata.header.xstep)+dispdata.header.xstart;
    maxy=((dmaxy-1)*dispdata.header.ystep)+dispdata.header.ystart;
    miny=((dminy-1)*dispdata.header.ystep)+dispdata.header.ystart;
    %subplot
    tpaxis=subaxis(1,length(epochs),epochpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.05,'MarginBottom',0.01);
    chanstring=get(handles.channelbox,'String');
    if get(handles.scalppopup,'Value')==1
        dx=dmaxx;
        dy=dmaxy;
        st=['MAX (',num2str(epochs(epochpos)),':',chanstring{channels(1)},') X=',num2str(maxx),' Y=',num2str(maxy)];
    else
        dx=dminx;
        dy=dminy;
        st=['MIN (',num2str(epochs(epochpos)),':',chanstring{channels(1)},') X=',num2str(minx),' Y=',num2str(miny)];
    end;
    tpaxis=LW_headplot(dispdata.header,dispdata.data,epochs(epochpos),index,dx,dy,dz);
    title(gca,st);
end;
