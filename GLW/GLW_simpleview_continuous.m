function varargout = GLW_simpleview_continuous(varargin)
% GLW_SIMPLEVIEW_CONTINUOUS MATLAB code for GLW_simpleview_continuous.fig
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
                   'gui_OpeningFcn', @GLW_simpleview_continuous_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_simpleview_continuous_OutputFcn, ...
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




% --- Executes just before GLW_simpleview_continuous is made visible.
function GLW_simpleview_continuous_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_simpleview_continuous (see VARARGIN)
handles.output = hObject;
guidata(hObject, handles);
axis off;
inputfiles=varargin{2};
%load header data
[p,n,e]=fileparts(inputfiles);
st=[p,filesep,n,'.lw5'];
[header,data]=LW_load(st);
dispdata.header=header;
dispdata.data=data;
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
%set ybottomedit,ytopedit
set(handles.ybottomedit,'String','0');
set(handles.ytopedit,'String','0');
%set xstart_edit,xlength_edit
set(handles.xstart_edit,'String','0');
set(handles.xlength_edit,'String','4');
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
%events
st={};
for i=1:length(dispdata.header.events);
    st{i}=dispdata.header.events(i).code;
    st{i}=[dispdata.header.events(i).code '(' num2str(dispdata.header.events(i).latency,3) ')'];
end;
set(handles.eventsbox,'String',st);
%create figure
set(handles.eventsbox,'UserData',dispdata);
updategraph(handles);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_simpleview_continuous_OutputFcn(hObject, eventdata, handles) 
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






% --- Executes on button press in yautochk.
function yautochk_Callback(hObject, eventdata, handles)
% hObject    handle to yautochk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);






% --- Update graphs ---
function updategraph(handles);
%tpdata(graphs,plots,x)
%data
dispdata=get(handles.eventsbox,'UserData');
currentaxis=[];
%
tp=get(handles.channelpopup,'Value');
%
%get list of selected channels
channels=get(handles.channelbox,'Value');
%get list of selected epochs
epochs=1;
%get index
index=get(handles.indexpopup,'Value');
%get y and z position
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dy=((ypos-dispdata.header.ystart)/dispdata.header.xstep)+1;
dz=((zpos-dispdata.header.zstart)/dispdata.header.zstep)+1;
%set tpx,dxstart,dxend;
tpx=1:1:size(dispdata.data,6);
tpx=((tpx-1)*dispdata.header.xstep)+dispdata.header.xstart;
xstart=str2num(get(handles.xstart_edit,'String'));
[a,b]=min(abs(tpx-xstart));
dxstart=b;
xlength=str2num(get(handles.xlength_edit,'String'));
xend=xstart+xlength;
[a,b]=min(abs(tpx-xend));
dxend=b;
%channelstring
channelstring=get(handles.channelbox,'String');
%fetch data (tpdata)
tpdata=zeros(length(channels),size(dispdata.data,6));
for channeli=1:length(channels);
    tpdata(channeli,:)=dispdata.data(1,channels(channeli),index,dz,dy,:);
    legendstring{channeli}=channelstring{channels(channeli)};
end;
%update axis edits if set to Auto
if get(handles.yautochk,'Value')==1;
    ymax=max(max(max(tpdata)))*1.1;
    ymin=min(min(min(tpdata)))*1.1;
    set(handles.ybottomedit,'String',num2str(ymin));
    set(handles.ytopedit,'String',num2str(ymax));
end;
%numgraphs and numwaves
if tp==1;
    numgraphs=size(tpdata,1);
    numwaves=1;
else
    numgraphs=1;
    numwaves=size(tpdata,1);
end;
%varycolor
lcolors=varycolor(numwaves);
%plot data (tpdata)
indexpos=1;
for graphpos=1:numgraphs;
    currentaxis(graphpos)=subaxis(numgraphs,1,graphpos,'MarginLeft',0.06,'MarginRight',0.01,'MarginTop',0.03,'MarginBottom',0.06);
    hold off;    
    for wavepos=1:numwaves;
        plot(tpx(dxstart:dxend),squeeze(tpdata(indexpos,dxstart:dxend)),'Color',lcolors(wavepos,[3,1,2]));
        indexpos=indexpos+1;
        hold on;
    end;
    %draw events?
    if get(handles.events_chk,'Value')==1;
        %xstart,xend
        for eventpos=1:length(dispdata.header.events);
            if dispdata.header.events(eventpos).epoch==1;
                latency=dispdata.header.events(eventpos).latency;
                if latency>=xstart;
                    if latency<=xend;
                        ybottom=str2num(get(handles.ybottomedit,'String'));
                        ytop=str2num(get(handles.ytopedit,'String'));
                        plot([latency latency],[ybottom ytop],'r:');
                        %text(latency,mean([ybottom ytop]),dispdata.header.events(eventpos).code);
                        if get(handles.ydircheck,'Value')==0;
                            text(latency,ytop-((ytop-ybottom)/20),dispdata.header.events(eventpos).code);
                        else
                            text(latency,ybottom+((ytop-ybottom)/20),dispdata.header.events(eventpos).code);
                        end;    
                    end;
                end;
            end;
        end;
    end;
    %draw legend?
    if get(handles.legendchk,'Value')==1;
        if tp==1;
            legend(legendstring{graphpos});
        else
            legend(legendstring{:});
        end;
    end;
    set(currentaxis(graphpos),'XLim',[xstart xend]);
    set(currentaxis(graphpos),'YLim',[str2num(get(handles.ybottomedit,'String')) str2num(get(handles.ytopedit,'String'))]);
    if get(handles.ydircheck,'Value')==0;
        set(currentaxis(graphpos),'YDir','normal');
    else
        set(currentaxis(graphpos),'YDir','reverse');
    end;        
end;
set(handles.channelbox,'UserData',currentaxis);
set(handles.eventsbox,'UserData',dispdata);





% --- Executes on mouse motion over figure - except title and menu.
function figure_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
currentaxis=get(handles.channelbox,'UserData');
currentpoint=get(currentaxis(1),'CurrentPoint');
set(handles.xtext,'String',num2str(currentpoint(1)));








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




% --- Executes on button press in visuchk.
function visuchk_Callback(hObject, eventdata, handles)
% hObject    handle to visuchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);


% --- Executes on selection change in eventsbox.
function eventsbox_Callback(hObject, eventdata, handles)
% hObject    handle to eventsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.eventsbox,'UserData');
idx=get(handles.eventsbox,'Value');
latency=dispdata.header.events(idx).latency;
set(handles.xstart_edit,'String',num2str(latency));
updategraph(handles);




% --- Executes during object creation, after setting all properties.
function eventsbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventsbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlength_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xlength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xlength_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlength_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in back_button.
function back_button_Callback(hObject, eventdata, handles)
% hObject    handle to back_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xstart=str2num(get(handles.xstart_edit,'String'));
xstep=str2num(get(handles.xstep_edit,'String'));
xstart=xstart-xstep;
set(handles.xstart_edit,'String',xstart);
updategraph(handles);




% --- Executes on button press in forward_button.
function forward_button_Callback(hObject, eventdata, handles)
% hObject    handle to forward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xstart=str2num(get(handles.xstart_edit,'String'));
xstep=str2num(get(handles.xstep_edit,'String'));
xstart=xstart+xstep;
set(handles.xstart_edit,'String',xstart);
updategraph(handles);






% --- Executes on button press in rewind_button.
function rewind_button_Callback(hObject, eventdata, handles)
% hObject    handle to rewind_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.eventsbox,'UserData');
xstart=dispdata.header.xstart;
set(handles.xstart_edit,'String',xstart);
updategraph(handles);





% --- Executes on button press in fastforward_button.
function fastforward_button_Callback(hObject, eventdata, handles)
% hObject    handle to fastforward_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dispdata=get(handles.eventsbox,'UserData');
xstart=(dispdata.header.xstart+(dispdata.header.datasize(6)*dispdata.header.xstep))-str2num(get(handles.xlength_edit,'String'));
set(handles.xstart_edit,'String',xstart);
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
function xstart_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstart_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in channelpopup.
function channelpopup_Callback(hObject, eventdata, handles)
% hObject    handle to channelpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updategraph(handles);



function xstep_edit_Callback(hObject, eventdata, handles)
% hObject    handle to xstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xstep_edit as text
%        str2double(get(hObject,'String')) returns contents of xstep_edit as a double


% --- Executes during object creation, after setting all properties.
function xstep_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xstep_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in events_chk.
function events_chk_Callback(hObject, eventdata, handles)
% hObject    handle to events_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of events_chk
