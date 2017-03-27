function varargout = GLW_simpleview(varargin)
% GLW_SIMPLEVIEW MATLAB code for GLW_simpleview.fig
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
% Dependencies : varycolor.m, subaxis.m, parseArgs.m




% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_simpleview_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_simpleview_OutputFcn, ...
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




% --- Executes just before GLW_simpleview is made visible.
function GLW_simpleview_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_simpleview (see VARARGIN)
handles.output = hObject;
guidata(hObject, handles);
inputfiles=varargin{2};
%load header data
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
%set yedit and zedit
set(handles.yedit,'String',num2str(dispdata.header.ystart));
set(handles.zedit,'String',num2str(dispdata.header.zstart));
%set xleftedit,xrightedit,ybottomedit,ytopedit
set(handles.xleftedit,'String','0');
set(handles.xrightedit,'String','0');
set(handles.ybottomedit,'String','0');
set(handles.ytopedit,'String','0');
%hide unnecessary items
if dispdata.header.datasize(3)==1;
    set(handles.indextext,'Visible','off');
    set(handles.indexpopup,'Visible','off');
end;
if dispdata.header.datasize(4)==1;
    set(handles.zpositiontext,'Visible','off');
    set(handles.zedit,'Visible','off');
end;
if dispdata.header.datasize(5)==1;
    set(handles.ypositiontext,'Visible','off');
    set(handles.yedit,'Visible','off');
end;
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
%create figure
set(handles.epochbox,'UserData',dispdata);
updategraph(handles);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_simpleview_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on selection change in channelpopup.
function channelpopup_Callback(hObject, eventdata, handles)
% hObject    handle to channelpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.channelpopup,'Value')==1;
    set(handles.epochpopup,'Value',2);
else
    set(handles.epochpopup,'Value',1);
end;
updategraph(handles);





% --- Executes on selection change in epochpopup.
function epochpopup_Callback(hObject, eventdata, handles)
% hObject    handle to epochpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.epochpopup,'Value')==1;
    set(handles.channelpopup,'Value',2);
else
    set(handles.channelpopup,'Value',1);
end;
updategraph(handles);



% --- Executes during object creation, after setting all properties.
function channelpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function epochpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochpopup (see GCBO)
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
currentaxis=[];
%
tp=get(handles.channelpopup,'Value');
%
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get y and z position
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dy=((ypos-dispdata.header.ystart)/dispdata.header.xstep)+1;
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%set tpx;
tpx=1:1:size(dispdata.data,6);
tpx=((tpx-1)*dispdata.header.xstep)+dispdata.header.xstart;
%epochstring,channelstring
epochstring=get(handles.epochbox,'String');
channelstring=get(handles.channelbox,'String');
%fetch data (tpdata)
if tp==1
    tpdata=zeros(length(epochs),length(channels),size(dispdata.data,6));
    for epochi=1:length(epochs);
        for channeli=1:length(channels);
            tpdata(epochi,channeli,:)=dispdata.data(epochs(epochi),channels(channeli),index,dz,dy,:);
            legendstring{epochi,channeli}=['[',epochstring{epochs(epochi)},'] [',channelstring{channels(channeli)},']'];
        end;
    end;
end;
if tp==2;
    tpdata=zeros(length(channels),length(epochs),size(dispdata.data,6));
    for epochi=1:length(epochs);
        for channeli=1:length(channels);
            tpdata(channeli,epochi,:)=dispdata.data(epochs(epochi),channels(channeli),index,dz,dy,:);
            legendstring{channeli,epochi}=[epochstring{epochs(epochi)},' :',channelstring{channels(channeli)}];
        end;
    end;
end;
%update axis edits if set to Auto
if get(handles.yautochk,'Value')==1;
    ymax=max(max(max(tpdata)))*1.1;
    ymin=min(min(min(tpdata)))*1.1;
    set(handles.ybottomedit,'String',num2str(ymin));
    set(handles.ytopedit,'String',num2str(ymax));
end;
if get(handles.xautochk,'Value')==1;
    set(handles.xleftedit,'String',num2str(tpx(1)));
    set(handles.xrightedit,'String',num2str(tpx(length(tpx))));
end;
%numgraphs and numwaves
numgraphs=size(tpdata,1);
numwaves=size(tpdata,2);
%varycolor
lcolors=varycolor(numwaves);
%plot data (tpdata)
for graphpos=1:numgraphs;
    currentaxis(graphpos)=subaxis(numgraphs,1,graphpos,'MarginLeft',0.06,'MarginRight',0.01,'MarginTop',0.03,'MarginBottom',0.06);
    hold off;    
    for wavepos=1:numwaves;
        plot(tpx,squeeze(tpdata(graphpos,wavepos,:)),'Color',lcolors(wavepos,[3,1,2]));
        hold on;
    end;
    %draw legend?
    if get(handles.legendchk,'Value')==1;
        st=legendstring(graphpos,:);
        legend(st);
    end;
    %if get(handles.xautochk,'Value')==0
        set(currentaxis(graphpos),'XLim',[str2num(get(handles.xleftedit,'String')) str2num(get(handles.xrightedit,'String'))]);
    %end;
    %if get(handles.yautochk,'Value')==0
    ybottom=str2num(get(handles.ybottomedit,'String'));
    ytop=str2num(get(handles.ytopedit,'String'));
    if ybottom==ytop;
        ybottom=-1;
        ytop=1;
    end;
    set(currentaxis(graphpos),'YLim',[ybottom ytop]);
    %end; 
    if get(handles.ydircheck,'Value')==0;
        set(currentaxis(graphpos),'YDir','normal');
    else
        set(currentaxis(graphpos),'YDir','reverse');
    end;        
end;
set(handles.channelbox,'UserData',currentaxis);
set(handles.epochbox,'UserData',dispdata);

%3D head (visu)?
visuchk=get(handles.visuchk,'Value');
if visuchk==1;
    selected_epochs=get(handles.epochbox,'Value');
    fig_handle=get(handles.visuchk,'UserData');
    %create figure if it does not exist
    if length(fig_handle)<length(selected_epochs);
        dispdata=get(handles.epochbox,'UserData');
        for i=length(fig_handle)+1:length(selected_epochs);
            fig_handle(i)=show3dhead(dispdata.header,dispdata.data,['epoch ' num2str(selected_epochs(i))]);
        end;
        set(handles.visuchk,'UserData',fig_handle);
    end;
            
    
    %update CLim
    CLim=get(currentaxis(1),'YLim');
    for i=1:length(fig_handle);
        set(fig_handle(i),'CLim',CLim);
    end;
    currentpoint=get(currentaxis(1),'CurrentPoint');
    update_topography(handles,currentpoint(1));
end;




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
set(handles.xtext,'String',num2str(currentpoint(1)));

visuchk=get(handles.visuchk,'Value');
%update topography if enabled
if visuchk==1;
    update_topography(handles,currentpoint(1));
end;




function update_topography(handles,x);
fig_handle=get(handles.visuchk,'UserData');
selected_epochs=get(handles.epochbox,'Value');
for i=1:length(fig_handle);
    index=get(handles.indexpopup,'Value');
    z=str2num(get(handles.zedit,'String'));
    y=str2num(get(handles.yedit,'String'));
    dispdata=get(handles.epochbox,'UserData');
    dz=round(((z-dispdata.header.zstart)/dispdata.header.zstep))+1;
    dy=round(((y-dispdata.header.ystart)/dispdata.header.ystep))+1;
    dx=round(((x-dispdata.header.xstart)/dispdata.header.xstep))+1;
    if dx<1;
        dx=1;
    end;
    if dy<1;
        dy=1;
    end;
    if dz<1;
        dz=1;
    end;
    if dx>dispdata.header.datasize(6);
        dx=dispdata.header.datasize(6);
    end;
    if dy>dispdata.header.datasize(5);
        dy=dispdata.header.datasize(5);
    end;
    if dz>dispdata.header.datasize(4);
        dz=dispdata.header.datasize(4);
    end;
    update3dhead(fig_handle(i),selected_epochs(i),index,dz,dy,dx);
end;





% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
cursors=get(handles.indexpopup,'UserData');
cursor1=currentpoint(1);
set(handles.xtext1,'String',num2str(cursor1));
updategraph(handles);
%draw cursor
for i=1:length(currentaxis);
    subplot(currentaxis(i));
    ylim=get(currentaxis(i),'YLim');
    plot([cursor1 cursor1],ylim,'r:');
end;
cursors.cursor1=cursor1;
set(handles.indexpopup,'UserData',cursors);




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
cursors=get(handles.indexpopup,'UserData');
cursor2=currentpoint(1);
set(handles.xtext2,'String',num2str(cursor2));
%draw cursor
for i=1:length(currentaxis);
    subplot(currentaxis(i));
    ylim=get(currentaxis(i),'YLim');
    plot([cursor2 cursor2],ylim,'m:');
end;
cursors.cursor2=cursor2;
set(handles.indexpopup,'UserData',cursors);




% --- Executes on button press in peakbutton.
function peakbutton_Callback(hObject, eventdata, handles)
% hObject    handle to peakbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.epochbox,'UserData');
cursors=get(handles.indexpopup,'UserData');
cursor1=cursors.cursor1;
cursor2=cursors.cursor2;
%set colnames
colnames{1}='epoch';
colnames{2}='channel';
colnames{3}='min(x)';
colnames{4}='min(y)';
colnames{5}='max(x)';
colnames{6}='max(y)';
colnames{7}='mean(y)';
colnames{8}='std(y)';

%set tdata
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get y and z position
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dy=((ypos-dispdata.header.ystart)/dispdata.header.xstep)+1;
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%dcursor (bin positions of cursor1 and cursor2)
dcursor1=round(((cursor1-dispdata.header.xstart)/dispdata.header.xstep)+1);
dcursor2=round(((cursor2-dispdata.header.xstart)/dispdata.header.xstep)+1);
if dcursor1>dcursor2
    dcursortp=dcursor1;
    dcursor1=dcursor2;
    dcursor2=dcursortp;
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
        tp=squeeze(dispdata.data(epochs(epochpos),channels(channelpos),index,dz,dy,dcursor1:dcursor2));
        [maxy,maxi]=max(tp);
        [miny,mini]=min(tp);
        maxi=maxi+dcursor1;
        mini=mini+dcursor1;
        maxx=((maxi-1)*dispdata.header.xstep)+dispdata.header.xstart;
        minx=((mini-1)*dispdata.header.xstep)+dispdata.header.xstart;
        ymean=mean(tp);
        ystd=std(tp);
        tdata{linepos,3}=num2str(minx);
        tdata{linepos,4}=num2str(miny);
        tdata{linepos,5}=num2str(maxx);
        tdata{linepos,6}=num2str(maxy);
        tdata{linepos,7}=num2str(ymean);
        tdata{linepos,8}=num2str(ystd);
        linepos=linepos+1;
    end;
end;   
%launch table
GLW_simpleview_table(tdata,colnames);




% --- Executes on button press in topobutton.
function topobutton_Callback(hObject, eventdata, handles)
% hObject    handle to topobutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.epochbox,'UserData');
cursors=get(handles.indexpopup,'UserData');
cursor1=cursors.cursor1;
cursor2=cursors.cursor2;
%set scalpdata (LW_topoplot(data,epoch,index,x,y,z,varargin))
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get y and z position
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dy=((ypos-dispdata.header.ystart)/dispdata.header.ystep)+1;
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%dcursor (bin positions of cursor1 and cursor2)
dcursor1=round((cursor1-dispdata.header.xstart)/dispdata.header.xstep)+1;
dcursor2=round((cursor2-dispdata.header.xstart)/dispdata.header.xstep)+1;
if dcursor1>dcursor2
    dcursortp=dcursor1;
    dcursor1=dcursor2;
    dcursor2=dcursortp;
end;
%launch figure;
topofigure=figure;
set(topofigure,'ToolBar','none');
%loop through selected epochs (will plot one scalp map per selected epoch)
for epochpos=1:length(epochs);
    %find maximum and minimum
    tp=squeeze(dispdata.data(epochs(epochpos),channels(1),index,dz,dy,dcursor1:dcursor2));
    [all_maxy,all_maxi]=max(tp);
    [all_miny,all_mini]=min(tp);
    if length(channels)>1
        for channelpos=2:length(channels);
            tp=squeeze(dispdata.data(epochs(epochpos),channels(channelpos),index,dz,dy,dcursor1:dcursor2));
            [maxy,maxi]=max(tp);
            [miny,mini]=min(tp);
            if maxy>all_maxy;
                all_maxy=maxy;
                all_maxi=maxi;
            end;
            if miny<all_miny;
                all_miny=miny;
                all_mini=mini;
            end;
        end;
    end;
    all_maxi=all_maxi+dcursor1-1;
    all_mini=all_mini+dcursor1-1;
    all_maxx=((all_maxi-1)*dispdata.header.xstep)+dispdata.header.xstart;
    all_minx=((all_mini-1)*dispdata.header.xstep)+dispdata.header.xstart;
    %subplot
    tpaxis=subaxis(1,length(epochs),epochpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.05,'MarginBottom',0.01);
    title(gca,num2str(epochs(epochpos)));
    if get(handles.scalppopup,'Value')==1
        dx=all_maxi;
    end;
    if get(handles.scalppopup,'Value')==2
        dx=all_mini;
    end;
    if get(handles.scalppopup,'Value')==3;
        dx=1;
        tp=squeeze(dispdata.data(epochs(epochpos),:,index,dz,dy,dcursor1:dcursor2));
        tp=mean(tp,2);
        dispdata.data(epochs(epochpos),:,index,dx,dy,dz)=tp;
    end;
     if get(handles.scalppopup,'Value')==4;
        dx=1;
        tp=squeeze(dispdata.data(epochs(epochpos),:,index,dz,dy,dcursor1:dcursor2));
        tp=std(tp,0,2);
        dispdata.data(epochs(epochpos),:,index,dx,dy,dz)=tp;
    end;
   
    tpaxis=LW_topoplot(dispdata.header,dispdata.data,epochs(epochpos),index,dx,dy,dz,'shading','interp','whitebk','on');

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


% --- Executes on button press in legendchk.
function legendchk_Callback(hObject, eventdata, handles)
% hObject    handle to legendchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);


% --- Executes on button press in headbutton.
function headbutton_Callback(hObject, eventdata, handles)
% hObject    handle to headbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.epochbox,'UserData');
cursors=get(handles.indexpopup,'UserData');
cursor1=cursors.cursor1;
cursor2=cursors.cursor2;
%set scalpdata (LW_topoplot(data,epoch,index,x,y,z,varargin))
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=get(handles.epochbox,'Value');
%get index
index=get(handles.indexpopup,'Value');
%get y and z position
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dy=((ypos-dispdata.header.ystart)/dispdata.header.ystep)+1;
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%dcursor (bin positions of cursor1 and cursor2)
dcursor1=round((cursor1-dispdata.header.xstart)/dispdata.header.xstep)+1;
dcursor2=round((cursor2-dispdata.header.xstart)/dispdata.header.xstep)+1;
if dcursor1>dcursor2
    dcursortp=dcursor1;
    dcursor1=dcursor2;
    dcursor2=dcursortp;
end;
%launch figure;
topofigure=figure;
set(topofigure,'ToolBar','none');
%loop through selected epochs (will plot one scalp map per selected epoch)
for epochpos=1:length(epochs);
    %find maximum and minimum
    tp=squeeze(dispdata.data(epochs(epochpos),channels(1),index,dz,dy,dcursor1:dcursor2));
    [all_maxy,all_maxi]=max(tp);
    [all_miny,all_mini]=min(tp);
    if length(channels)>1
        for channelpos=2:length(channels);
            tp=squeeze(dispdata.data(epochs(epochpos),channels(channelpos),index,dz,dy,dcursor1:dcursor2));
            [maxy,maxi]=max(tp);
            [miny,mini]=min(tp);
            if maxy>all_maxy;
                all_maxy=maxy;
                all_maxi=maxi;
            end;
            if miny<all_miny;
                all_miny=miny;
                all_mini=mini;
            end;
        end;
    end;
    all_maxi=all_maxi+dcursor1-1;
    all_mini=all_mini+dcursor1-1;
    all_maxx=((all_maxi-1)*dispdata.header.xstep)+dispdata.header.xstart;
    all_minx=((all_mini-1)*dispdata.header.xstep)+dispdata.header.xstart;
    %subplot
    tpaxis=subaxis(1,length(epochs),epochpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.05,'MarginBottom',0.01);
    title(gca,num2str(epochs(epochpos)));
    if get(handles.scalppopup,'Value')==1
        dx=all_maxi;
    else
        dx=all_mini;
    end;
    tpaxis=LW_headplot(dispdata.header,dispdata.data,epochs(epochpos),index,dx,dy,dz);

end;


% --- Executes on button press in visuchk.
function visuchk_Callback(hObject, eventdata, handles)
% hObject    handle to visuchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);
