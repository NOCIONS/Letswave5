function varargout = GLW_figure_waves(varargin)
% GLW_FIGURE_WAVES MATLAB code for GLW_figure_waves.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_figure_waves_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_figure_waves_OutputFcn, ...
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





% --- Executes just before GLW_figure_waves is made visible.
function GLW_figure_waves_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_figure_waves (see VARARGIN)
% Choose default command line output for GLW_figure_waves
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
axis off;
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
inputfiles=get(handles.filebox,'UserData');
cleanfiles={};
for i=1:length(inputfiles);
    [p n e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
%load headers and datas
for i=1:length(inputfiles);
    [idata(i).header,idata(i).data]=LW_load(inputfiles{i});
end;
set(handles.epochbox,'UserData',idata);
updateboxes(handles);
%colors
set(handles.axis,'Color',[1 1 1]);
line_handle=plot(handles.axis,[-1 1],[0 0],'-','Color',[0 0 0],'Linewidth',1);
set(handles.axis,'XLim',[-1.5 1.5]);
set(handles.axis, 'XTickLabelMode', 'Manual');
set(handles.axis, 'XTick', []);
set(handles.axis, 'YTickLabelMode', 'Manual');
set(handles.axis, 'YTick', []);
set(handles.axis,'UserData',line_handle);
%
readlinestyle(handles);



    



function updateboxes(handles);
%get filepos
filepos=get(handles.filebox,'Value');
%get data
data=get(handles.epochbox,'UserData');
header=data(filepos).header;
%update epochbox
string={};
for i=1:header.datasize(1);
    string{i}=num2str(i);
end;
set(handles.epochbox,'String',string);
tp=get(handles.epochbox,'Value');
tp(find(tp>header.datasize(1)))=[];
set(handles.epochbox,'Value',tp);
%update channelbox
string={};
for i=1:header.datasize(2);
    string{i}=header.chanlocs(i).labels;
end;
set(handles.channelbox,'String',string);
tp=get(handles.channelbox,'Value');
tp(find(tp>header.datasize(2)))=[];
set(handles.channelbox,'Value',tp);
%update indexbox
string={};
if isfield(header,'indexlabels');
    for i=1:header.datasize(3);
        string{i}=header.indexlabels{i}
    end;
else
    for i=1:header.datasize(3);
        string{i}=num2str(i);
    end;
end;
set(handles.indexbox,'String',string);
tp=get(handles.indexbox,'Value');
tp(find(tp>header.datasize(3)))=[];
set(handles.indexbox,'Value',tp);
%update Y
y=str2num(get(handles.yedit,'String'));
if y<header.ystart;
    y=header.ystart;
end;
if y>header.ystart+((header.datasize(5)-1)*header.ystep);
    y=header.ystart+((header.datasize(5)-1)*header.ystep)
end;
set(handles.yedit,'String',num2str(y));
%update Z
z=str2num(get(handles.zedit,'String'));
if z<header.zstart;
    z=header.zstart;
end;
if z>header.zstart+((header.datasize(4)-1)*header.zstep);
    z=header.zstart+((header.datasize(4)-1)*header.zstep)
end;
set(handles.zedit,'String',num2str(z));







function updatewavebox(handles);
%wavedata
wavedata=get(handles.wavebox,'UserData');
%headerdata
data=get(handles.epochbox,'UserData');
%filestring
filestring=get(handles.filebox,'String');
%build string
st={};
if isempty(wavedata);
else
    for i=1:length(wavedata);
        filepos=wavedata(i).filepos;
        header=data(filepos).header;
        if isfield(header,'indexlabels');
            st{i}=[filestring{filepos} ' E:' num2str(wavedata(i).epochpos) ' C:' header.chanlocs(wavedata(i).channelpos).labels ' I:' header.indexlabels{wavedata(i).indexpos}];
        else
            st{i}=[filestring{filepos} ' E:' num2str(wavedata(i).epochpos) ' C:' header.chanlocs(wavedata(i).channelpos).labels ' I:' num2str(wavedata(i).indexpos)];
        end;
    end;
end;
set(handles.wavebox,'String',st);
    







% --- Outputs from this function are returned to the command line.
function varargout = GLW_figure_waves_OutputFcn(hObject, eventdata, handles) 
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
updateboxes(handles);






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
%data
wavedata=get(handles.wavebox,'UserData');
if length(wavedata)>0;
    h=figure;
    %headers
    data=get(handles.epochbox,'UserData');
    %plot
    hold on;
    for wavepos=1:length(wavedata);
        header=data(wavedata(wavepos).filepos).header;
        epochpos=wavedata(wavepos).epochpos;
        channelpos=wavedata(wavepos).channelpos;
        indexpos=wavedata(wavepos).indexpos;
        y=wavedata(wavepos).y;
        z=wavedata(wavepos).z;
        dy=((y-header.ystart)/header.ystep)+1
        dz=((z-header.zstart)/header.zstep)+1
        tpx=1:1:header.datasize(6);
        tpx=((tpx-1)*header.xstep)+header.xstart;
        tpy=squeeze(data(wavedata(wavepos).filepos).data(epochpos,channelpos,indexpos,dz,dy,:));
        ax=subplot(1,1,1);
        plot(tpx,tpy,'Color',wavedata(wavepos).Color,'LineWidth',wavedata(wavepos).LineWidth,'LineStyle',wavedata(wavepos).LineStyle);
    end;
    %background color
    set(ax,'Color',get(handles.axis,'Color'));
    set(h,'Color',get(handles.axis,'Color'));
    %XLim
    if get(handles.xlimchk,'Value')==1;
        set(ax,'XLim',[str2num(get(handles.xlim1,'String')) str2num(get(handles.xlim2,'String'))]);
    end;
    xlim=get(ax,'XLim');
    set(handles.xlim1,'String',num2str(xlim(1)));
    set(handles.xlim2,'String',num2str(xlim(2)));
    %YLim
    if get(handles.ylimchk,'Value')==1;
        set(ax,'YLim',[str2num(get(handles.ylim1,'String')) str2num(get(handles.ylim2,'String'))]);
    end;
    ylim=get(ax,'YLim');
    set(handles.ylim1,'String',num2str(ylim(1)));
    set(handles.ylim2,'String',num2str(ylim(2)));
    %XInterval
    if get(handles.xtickchk,'Value')==1;
        interval=str2num(get(handles.xintervaledit,'String'));
        anchor=str2num(get(handles.xanchoredit,'String'));
        xtickinterval(interval,anchor);
    end;
    xtick=get(ax,'XTick');
    set(handles.xanchoredit,'String',num2str(xtick(1)));
    set(handles.xintervaledit,'String',num2str(xtick(2)-xtick(1)));
    %YInterval
    if get(handles.ytickchk,'Value')==1;
        interval=str2num(get(handles.yintervaledit,'String'));
        anchor=str2num(get(handles.yanchoredit,'String'));
        ytickinterval(interval,anchor);
    end;
    ytick=get(ax,'YTick');
    set(handles.yanchoredit,'String',num2str(ytick(1)));
    set(handles.yintervaledit,'String',num2str(ytick(2)-ytick(1)));
    %YDir
    if get(handles.ydirchk,'Value')==1;
        set(ax,'YDir','reverse');
    else
        set(ax,'YDir','normal');
    end;
    hold off;
end;




function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
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







% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
wavepos=length(wavedata)+1;
wavedata(wavepos).filepos=get(handles.filebox,'Value');
wavedata(wavepos).epochpos=get(handles.epochbox,'Value');
wavedata(wavepos).channelpos=get(handles.channelbox,'Value');
wavedata(wavepos).indexpos=get(handles.indexbox,'Value');
wavedata(wavepos).y=str2num(get(handles.yedit,'String'));
wavedata(wavepos).z=str2num(get(handles.zedit,'String'));
%style
line_handle=get(handles.axis,'UserData');
wavedata(wavepos).Color=get(line_handle,'Color');
wavedata(wavepos).LineWidth=get(line_handle,'LineWidth');
wavedata(wavepos).LineStyle=get(line_handle,'LineStyle');
set(handles.wavebox,'UserData',wavedata);
updatewavebox(handles);






% --- Executes on selection change in wavebox.
function wavebox_Callback(hObject, eventdata, handles)
% hObject    handle to wavebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
%update using current selection
selected=get(handles.wavebox,'Value');
if isempty(selected);
else
    set(handles.filebox,'Value',wavedata(selected).filepos);
    updateboxes(handles);
    set(handles.epochbox,'Value',wavedata(selected).epochpos);
    set(handles.channelbox,'Value',wavedata(selected).channelpos);
    set(handles.indexbox,'Value',wavedata(selected).indexpos);
    set(handles.yedit,'String',num2str(wavedata(selected).y));
    set(handles.zedit,'String',num2str(wavedata(selected).z));
    %styles
    line_handle=get(handles.axis,'UserData');
    set(line_handle,'Color',wavedata(selected).Color);
    set(line_handle,'LineWidth',wavedata(selected).LineWidth);
    set(line_handle,'LineStyle',wavedata(selected).LineStyle);
    readlinestyle(handles);
end;




% --- Executes during object creation, after setting all properties.
function wavebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in deletebutton.
function deletebutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
wavepos=get(handles.wavebox,'Value');
if isempty(wavedata)
else
    wavedata(wavepos)=[];
    set(handles.wavebox,'UserData',wavedata);
    wavepos2=wavepos-1;
    if wavepos2==0
        wavepos2=1;
    end;
    set(handles.wavebox,'Value',wavepos2);
end;
updatewavebox(handles);






% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavebox,'UserData',[]);
set(handles.wavebox,'Value',[]);
updatewavebox(handles);






% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavepos=get(handles.wavebox,'Value');
if isempty(wavepos);
else
    wavedata=get(handles.wavebox,'UserData');
    if isempty(wavedata);
    else
        wavedata(wavepos).filepos=get(handles.filebox,'Value');
        wavedata(wavepos).epochpos=get(handles.epochbox,'Value');
        wavedata(wavepos).channelpos=get(handles.channelbox,'Value');
        wavedata(wavepos).indexpos=get(handles.indexbox,'Value');
        wavedata(wavepos).y=str2num(get(handles.yedit,'String'));
        wavedata(wavepos).z=str2num(get(handles.zedit,'String'));
        %style
        line_handle=get(handles.axis,'UserData');
        wavedata(wavepos).Color=get(line_handle,'Color');
        wavedata(wavepos).LineWidth=get(line_handle,'LineWidth');
        wavedata(wavepos).LineStyle=get(line_handle,'LineStyle');
        set(handles.wavebox,'UserData',wavedata);
        updatewavebox(handles);
    end;
end;






% --- Executes on button press in linecolorbutton.
function linecolorbutton_Callback(hObject, eventdata, handles)
% hObject    handle to linecolorbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C=get(handles.linecolorbutton,'UserData');
C=uisetcolor(C);
set(handles.linecolorbutton,'UserData',C);
writelinestyle(handles);





% --- Executes on selection change in linewidthpopup.
function linewidthpopup_Callback(hObject, eventdata, handles)
% hObject    handle to linewidthpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
writelinestyle(handles);





% --- Executes during object creation, after setting all properties.
function linewidthpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linewidthpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in linestylepopup.
function linestylepopup_Callback(hObject, eventdata, handles)
% hObject    handle to linestylepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
writelinestyle(handles);




function readlinestyle(handles);
line_handle=get(handles.axis,'UserData');
%color
C=get(line_handle,'Color');
set(handles.linecolorbutton,'UserData',C);
%width
W=get(line_handle,'LineWidth');
set(handles.linewidthpopup,'Value',W);
%linestyle
st={'-';':';'-.';'--'};
W=get(line_handle,'LineStyle');
set(handles.linestylepopup,'Value',find(strcmpi(W,st)));





function writelinestyle(handles);
line_handle=get(handles.axis,'UserData');
%color
C=get(handles.linecolorbutton,'UserData');
set(line_handle,'Color',C);
%width
W=get(handles.linewidthpopup,'Value');
set(line_handle,'LineWidth',W);
%style
st={'-';':';'-.';'--'};
W=st{get(handles.linestylepopup,'Value')};
set(line_handle,'LineStyle',W);





% --- Executes during object creation, after setting all properties.
function linestylepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to linestylepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in backgroundbutton.
function backgroundbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
C=get(handles.axis,'Color');
C=uisetcolor(C);
set(handles.axis,'Color',C);



function xlim1_Callback(hObject, eventdata, handles)
% hObject    handle to xlim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim1 as text
%        str2double(get(hObject,'String')) returns contents of xlim1 as a double


% --- Executes during object creation, after setting all properties.
function xlim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xlim2_Callback(hObject, eventdata, handles)
% hObject    handle to xlim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xlim2 as text
%        str2double(get(hObject,'String')) returns contents of xlim2 as a double


% --- Executes during object creation, after setting all properties.
function xlim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xlimchk.
function xlimchk_Callback(hObject, eventdata, handles)
% hObject    handle to xlimchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xlimchk



function ylim1_Callback(hObject, eventdata, handles)
% hObject    handle to ylim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim1 as text
%        str2double(get(hObject,'String')) returns contents of ylim1 as a double


% --- Executes during object creation, after setting all properties.
function ylim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ylim2_Callback(hObject, eventdata, handles)
% hObject    handle to ylim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ylim2 as text
%        str2double(get(hObject,'String')) returns contents of ylim2 as a double


% --- Executes during object creation, after setting all properties.
function ylim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in ylimchk.
function ylimchk_Callback(hObject, eventdata, handles)
% hObject    handle to ylimchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ylimchk



function xintervaledit_Callback(hObject, eventdata, handles)
% hObject    handle to xintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xintervaledit as text
%        str2double(get(hObject,'String')) returns contents of xintervaledit as a double


% --- Executes during object creation, after setting all properties.
function xintervaledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xanchoredit_Callback(hObject, eventdata, handles)
% hObject    handle to xanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xanchoredit as text
%        str2double(get(hObject,'String')) returns contents of xanchoredit as a double


% --- Executes during object creation, after setting all properties.
function xanchoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in xtickchk.
function xtickchk_Callback(hObject, eventdata, handles)
% hObject    handle to xtickchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of xtickchk



function yintervaledit_Callback(hObject, eventdata, handles)
% hObject    handle to yintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of yintervaledit as text
%        str2double(get(hObject,'String')) returns contents of yintervaledit as a double


% --- Executes during object creation, after setting all properties.
function yintervaledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yanchoredit_Callback(hObject, eventdata, handles)
% hObject    handle to yanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function yanchoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in ytickchk.
function ytickchk_Callback(hObject, eventdata, handles)
% hObject    handle to ytickchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ydirchk.
function ydirchk_Callback(hObject, eventdata, handles)
% hObject    handle to ydirchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ydirchk
