function varargout = GLW_correlation(varargin)
% GLW_CORRELATION MATLAB code for GLW_correlation.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_correlation_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_correlation_OutputFcn, ...
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





% --- Executes just before GLW_correlation is made visible.
function GLW_correlation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_correlation (see VARARGIN)
% Choose default command line output for GLW_correlation
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
inputfiles=get(handles.filebox,'UserData');
cleanfiles={};
for i=1:length(inputfiles);
    [p n e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
set(handles.filebox2,'String',cleanfiles);
%load headers and datas
for i=1:length(inputfiles);
    [idata(i).header,idata(i).data]=LW_load(inputfiles{i});
end;
set(handles.epochbox,'UserData',idata);




    









% --- Outputs from this function are returned to the command line.
function varargout = GLW_correlation_OutputFcn(hObject, eventdata, handles) 
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
        header2=data(wavedata(wavepos).filepos2).header;
        epochpos=wavedata(wavepos).epochpos;
        channelpos=wavedata(wavepos).channelpos;
        indexpos=wavedata(wavepos).indexpos;
        y=wavedata(wavepos).y;
        z=wavedata(wavepos).z;
        dy=((y-header.ystart)/header.ystep)+1
        dz=((z-header.zstart)/header.zstep)+1
        epochpos2=wavedata(wavepos).epochpos2;
        channelpos2=wavedata(wavepos).channelpos2;
        indexpos2=wavedata(wavepos).indexpos2;
        y2=wavedata(wavepos).y2;
        z2=wavedata(wavepos).z2;
        dy2=((y2-header2.ystart)/header2.ystep)+1
        dz2=((z2-header2.zstart)/header2.zstep)+1
        tpx=squeeze(data(wavedata(wavepos).filepos).data(epochpos,channelpos,indexpos,dz,dy,:));
        tpy=squeeze(data(wavedata(wavepos).filepos2).data(epochpos2,channelpos2,indexpos2,dz,dy,:));
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











function yedit2_Callback(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function yedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function zedit2_Callback(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function zedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in indexbox2.
function indexbox2_Callback(hObject, eventdata, handles)
% hObject    handle to indexbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function indexbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to indexbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in channelbox2.
function channelbox2_Callback(hObject, eventdata, handles)
% hObject    handle to channelbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function channelbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in epochbox2.
function epochbox2_Callback(hObject, eventdata, handles)
% hObject    handle to epochbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox2 (see GCBO)
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





% --- Executes during object creation, after setting all properties.
function filebox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
