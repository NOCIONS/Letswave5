function varargout = GLW_findpeaks_waves(varargin)
% GLW_FINDPEAKS_WAVES MATLAB code for GLW_findpeaks_waves.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_findpeaks_waves_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_findpeaks_waves_OutputFcn, ...
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





% --- Executes just before GLW_findpeaks_waves is made visible.
function GLW_findpeaks_waves_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_findpeaks_waves (see VARARGIN)
% Choose default command line output for GLW_findpeaks_waves
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
%output
set(handles.close_btn,'Userdata',varargin{3});
axis off;
inputfiles=get(handles.filebox,'UserData');
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    filenames{i}=n;
end;
set(handles.filebox,'String',filenames);
set(handles.filebox,'Value',1);
%prepare peakdata
inputfiles=get(handles.filebox,'UserData');
for filepos=1:length(inputfiles);
    %load header
    header=LW_load_header(inputfiles{filepos});
    peakdata(filepos).lat=nan(header.datasize(1),1);
    %also store the header for later use
    peakdata(filepos).header=header;
end;
set(handles.peakbox,'UserData',peakdata);
set(handles.filetext,'UserData',1);
%fill peakbox
selected=get(handles.filebox,'Value');
tp={};
for epochpos=1:length(peakdata(selected).lat);
    tp{epochpos}=num2str(peakdata(selected).lat(epochpos));
end;
set(handles.filetext,'UserData',selected);
set(handles.peakbox,'String',tp);
%fill chanbox
for chanpos=1:header.datasize(2);
    st{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanbox,'String',st);
set(handles.chanbox,'Value',1);
%fill indexbox
st={};
if isfield(header,'indexlabels');
    for indexpos=1:header.datasize(3);
        st{indexpos}=header.indexlabels{indexpos};
    end;
else
    for indexpos=1:header.datasize(3);
        st{indexpos}=num2str(indexpos);
    end;
end;
set(handles.indexbox,'String',st);
set(handles.indexbox,'Value',1);
%set Y and Z
set(handles.yedit,'String',num2str(header.ystart));
set(handles.zedit,'String',num2str(header.zstart));
%check to see whether Find All should be enabled
ok=0;
if length(peakdata)>1;
    ok=1;
    datasize1=peakdata(1).header.datasize;
    datasize1(1)=1;
    for filepos=2:length(peakdata);
        datasize2=peakdata(filepos).header.datasize;
        datasize2(1)=1;
        if datasize1==datasize2;
        else
            ok=0;
        end;
    end;
end;
if ok==0;
    set(handles.findallbutton,'Enable','off');
end;
%fill eventbox
updateeventbox(handles);
%check whether it is possible to plot scalp maps
peakdata=get(handles.peakbox,'UserData');
selected=get(handles.filebox,'Value');
header=peakdata(selected).header;
ok=0;
for chanpos=1:length(header.chanlocs);
    if header.chanlocs(chanpos).topo_enabled==1;
        ok=1;
    end;
end;
if ok==1;
    set(handles.scalpmapbutton,'Enable','on');
    set(handles.avgscalpmapbutton,'Enable','on');
else
    set(handles.scalpmapbutton,'Enable','off');
    set(handles.avgscalpmapbutton,'Enable','off');
end;
%epochfigure
[epochfigure.figure epochfigure.handles]=GLW_findpeaks_waves_figure;
set(gcf,'MenuBar','none');
set(gcf,'ToolBar','none');
epochfigure.axis=gca;
set(handles.findbutton,'UserData',epochfigure);
%update info for figure
set(epochfigure.handles.xtext,'UserData',handles);
%xaxis
set(handles.xaxis1,'String',num2str(header.xstart));
set(handles.xaxis2,'String',num2str(header.xstart+((header.datasize(6)-1)*header.xstep)));





function updateeventbox(handles);
%load peakdata
peakdata=get(handles.peakbox,'UserData');
eventstring={};
k=1;
for filepos=1:length(peakdata);
    %get list of events if present
    if isfield(peakdata(filepos).header,'events');
        events=peakdata(filepos).header.events;
        for eventpos1=1:length(events);
            ok=1;
            if length(events)>0;
                for eventpos2=1:length(eventstring);
                    if strcmpi(events(eventpos1).code,eventstring{eventpos2});
                        ok=0;
                    end;
                end;
            end;
            if ok==1;
                eventstring{k}=events(eventpos1).code;;
                k=k+1;
            end;
        end;
    end;
end;
%sort by alphabetical order
eventstring=sort(eventstring);
set(handles.eventbox,'String',eventstring);

   




% --- Outputs from this function are returned to the command line.
function varargout = GLW_findpeaks_waves_OutputFcn(hObject, eventdata, handles) 
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




function updatepeakbox(handles);
%get tabledata
peakdata=get(handles.peakbox,'UserData');
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%store current table data in tabledata
previous_selected=get(handles.filetext,'UserData');
tp=get(handles.peakbox,'String');
for epochpos=1:length(peakdata(previous_selected).lat);
    peakdata(previous_selected).lat(epochpos)=str2num(tp{epochpos,1});
end;
set(handles.peakbox,'UserData',peakdata);
%update table data with current selection
selected=get(handles.filebox,'Value');
tp={};
for epochpos=1:length(peakdata(selected).lat);
    tp{epochpos}=num2str(peakdata(selected).lat(epochpos));
end;
set(handles.filetext,'UserData',selected);
set(handles.peakbox,'String',tp);
%header
header=peakdata(selected).header;
%update chanbox
for chanpos=1:header.datasize(2);
    st{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanbox,'String',st);
tp=get(handles.chanbox,'Value');
if tp>header.datasize(2);
    tp=1;
end;
set(handles.chanbox,'Value',tp);
%fill indexbox
st={};
if isfield(header,'indexlabels');
    for indexpos=1:header.datasize(3);
        st{indexpos}=header.indexlabels{indexpos};
    end;
else
    for indexpos=1:header.datasize(3);
        st{indexpos}=num2str(indexpos);
    end;
end;
set(handles.indexbox,'String',st);
tp=get(handles.indexbox,'Value');
if tp>header.datasize(3);
    tp=1;
end;
set(handles.indexbox,'Value',tp);
%set Y and Z
set(handles.yedit,'String',num2str(header.ystart));
set(handles.zedit,'String',num2str(header.zstart));





% --- Executes on selection change in filebox.
function filebox_Callback(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
updatepeakbox(handles);
set(handles.peakbox,'Value',1);
%check whether it is possible to plot scalp maps
peakdata=get(handles.peakbox,'UserData');
selected=get(handles.filebox,'Value');
header=peakdata(selected).header;
ok=0;
for chanpos=1:length(header.chanlocs);
    if header.chanlocs(chanpos).topo_enabled==1;
        ok=1;
    end;
end;
if ok==1;
    set(handles.scalpmapbutton,'Enable','on');
    set(handles.avgscalpmapbutton,'Enable','on');
else
    set(handles.scalpmapbutton,'Enable','off');
    set(handles.avgscalpmapbutton,'Enable','off');
end;
    




% --- Executes during object creation, after setting all properties.
function filebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in eventbox.
function eventbox_Callback(hObject, eventdata, handles)
% hObject    handle to eventbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function eventbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit1_Callback(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function xedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit2_Callback(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in methodbox.
function methodbox_Callback(hObject, eventdata, handles)
% hObject    handle to methodbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function methodbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function peak_latencies=findpeaks(handles,x1,x2,filepos,method);
%method : 'maximum' 'minimum' 'absolute maximum' 'absolute minimum'
%filename
inputfiles=get(handles.filebox,'UserData');
filename=inputfiles{filepos};
[header,data]=LW_load(filename);
%chanpos
chanpos=get(handles.chanbox,'Value');
%indexpos
indexpos=get(handles.indexbox,'Value');
%dypos,dzpos
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dypos=round((ypos-header.ystart)/header.xstep)+1;
dzpos=round((zpos-header.zstart)/header.zstep)+1;
%dx1,dx2
dx1=round((x1-header.xstart)/header.xstep)+1;
dx2=round((x2-header.xstart)/header.xstep)+1;
%check dx1 and dx2 limits
if dx1<1;
    dx1=1;
end;
if dx2<1;
    dx2=1;
end;
if dx1>header.datasize(6);
    dx1=header.datasize(6);
end;
if dx2>header.datasize(6);
    dx2=header.datasize(6);
end;
%method
methods={'maximum','minimum','absolute maximum','absolute minimum'};
method=find(strcmp(methods,method),1);
%loop through epochs
for epochpos=1:header.datasize(1);
    tp=data(epochpos,chanpos,indexpos,dzpos,dypos,dx1:dx2);
    if method==1;
        [a,b]=max(tp);
    end;
    if method==2;
        [a,b]=min(tp);
    end;
    if method==3;
        [a,b]=max(abs(tp));
    end;
    if method==4;
        [a,b]=min(abs(tp));
    end;
    lat(epochpos)=((b-1)*header.xstep)+x1;
end;
peak_latencies=lat;





% --- Executes on button press in findbutton.
function findbutton_Callback(hObject, eventdata, handles)
% hObject    handle to findbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2num(get(handles.xedit1,'String'));
x2=str2num(get(handles.xedit2,'String'));
filepos=get(handles.filebox,'Value');
methods=get(handles.methodbox,'String');
method=methods{get(handles.methodbox,'Value')};
peak_latencies=findpeaks(handles,x1,x2,filepos,method);
%update peakdata
peakdata=get(handles.peakbox,'UserData');
peakdata(filepos).lat=peak_latencies;
set(handles.peakbox,'UserData',peakdata);
%update peakbox
st={};
for epochpos=1:peakdata(filepos).header.datasize(1);
    st{epochpos}=num2str(peakdata(filepos).lat(epochpos));
end;
set(handles.peakbox,'String',st);





function drawepoch(handles);
%epochfigure
epochfigure=get(handles.findbutton,'UserData');
figure(epochfigure.figure);
%epochpos
epochpos=get(handles.peakbox,'Value');
%epochpos is last selected epoch if more than one epochs are selected
epochpos=epochpos(length(epochpos));
%filename
filepos=get(handles.filebox,'Value');
inputfiles=get(handles.filebox,'UserData');
filename=inputfiles{filepos};
%load header data
[header,data]=LW_load(filename);
%indexpos
indexpos=get(handles.indexbox,'Value');
%chanpos
chanpos=get(handles.chanbox,'Value');
%dypos,dzpos
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dypos=round((ypos-header.ystart)/header.xstep)+1;
dzpos=round((zpos-header.zstart)/header.zstep)+1;
%tpx
tpx=1:1:header.datasize(6);
tpx=((tpx-1)*header.xstep)+header.xstart;
%plot epoch
tpy=squeeze(data(epochpos,chanpos,indexpos,dzpos,dypos,:));
plot(tpx,tpy);
xlim1=str2num(get(handles.xaxis1,'String'));
xlim2=str2num(get(handles.xaxis2,'String'));
set(gca,'XLim',[xlim1 xlim2]);
set(gca,'YDir','reverse');
%ylim
ylim=get(gca,'YLim');
%plot peak search range
hold on;
xedit1=str2num(get(handles.xedit1,'String'));
xedit2=str2num(get(handles.xedit2,'String'));
plot([xedit1 xedit1],ylim,'r:');
plot([xedit2 xedit2],ylim,'r:');
%plot peak location if available
latstr=get(handles.peakbox,'String');
lat=str2num(latstr{epochpos});
if isnan(lat);
else
    plot([lat lat],ylim,'r--');
end;
hold off;
%store tpx and tpy
epochfigure.tpx=tpx;
epochfigure.tpy=tpy;
set(handles.findbutton,'UserData',epochfigure);




% --- Executes on selection change in peakbox.
function peakbox_Callback(hObject, eventdata, handles)
% hObject    handle to peakbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
drawepoch(handles);





% --- Executes during object creation, after setting all properties.
function peakbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peakbox (see GCBO)
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




% --- Executes on button press in findallbutton.
function findallbutton_Callback(hObject, eventdata, handles)
% hObject    handle to findallbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2num(get(handles.xedit1,'String'));
x2=str2num(get(handles.xedit2,'String'));
methods=get(handles.methodbox,'String');
method=methods{get(handles.methodbox,'Value')};
%update peakdata
inputfiles=get(handles.filebox,'String');
peakdata=get(handles.peakbox,'UserData');
for filepos=1:length(inputfiles);
    peak_latencies=findpeaks(handles,x1,x2,filepos,method);
    peakdata(filepos).lat=peak_latencies
end;
set(handles.peakbox,'UserData',peakdata);
%update peakbox
selected=get(handles.filebox,'Value');
st={};
for epochpos=1:length(peakdata(selected).lat);
    st{epochpos}=num2str(peakdata(selected).lat(epochpos));
end;
set(handles.peakbox,'String',st);




% --- Executes on button press in scalpmapbutton.
function scalpmapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to scalpmapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%filename
filepos=get(handles.filebox,'Value');
inputfiles=get(handles.filebox,'UserData');
filename=inputfiles{filepos};
%load header data
[header,data]=LW_load(filename);
%latencies (xpos/dxpos)
latstr=get(handles.peakbox,'String');
for i=1:length(latstr);
    xpos(i)=str2num(latstr{i});
end;
dxpos=round((xpos-header.xstart)/header.xstep)+1;
%indexpos
indexpos=get(handles.indexbox,'Value');
%dypos,dzpos
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dypos=round((ypos-header.ystart)/header.xstep)+1;
dzpos=round((zpos-header.zstart)/header.zstep)+1;
%figure
figure;
for epochpos=1:length(xpos);
    subplot(ceil(length(xpos)/2),2,epochpos);
    LW_topoplot(header,data,epochpos,indexpos,dxpos(epochpos),dypos,dzpos,'shading','interp','whitebk','on');
    title(gca,num2str(epochpos));
end;




% --- Executes on button press in avgscalpmapbutton.
function avgscalpmapbutton_Callback(hObject, eventdata, handles)
% hObject    handle to avgscalpmapbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%filename
filepos=get(handles.filebox,'Value');
inputfiles=get(handles.filebox,'UserData');
filename=inputfiles{filepos};
[header,data]=LW_load(filename);
%latencies (xpos/dxpos)
latstr=get(handles.peakbox,'String');
for i=1:length(latstr);
    xpos(i)=str2num(latstr{i});
end;
dxpos=round((xpos-header.xstart)/header.xstep)+1;
%indexpos
indexpos=get(handles.indexbox,'Value');
%dypos,dzpos
ypos=str2num(get(handles.yedit,'String'));
zpos=str2num(get(handles.zedit,'String'));
dypos=round((ypos-header.ystart)/header.xstep)+1;
dzpos=round((zpos-header.zstart)/header.zstep)+1;
%average data at dxpos
for epochpos=1:length(dxpos);
    tpdata(:,epochpos)=squeeze(data(epochpos,:,indexpos,dzpos,dypos,dxpos(epochpos)));
end;
avtpdata=squeeze(mean(tpdata,2));
%figure
figure;
topoplot(avtpdata,header.chanlocs,'shading','interp','whitebk','on');
set(gcf,'color',[1 1 1]);




function xaxis2_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xaxis2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xaxis1_Callback(hObject, eventdata, handles)
% hObject    handle to xaxis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xaxis1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xaxis1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes when user attempts to close figure.
function figure_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
epochfigure=get(handles.findbutton,'UserData');
delete(epochfigure.figure);
delete(hObject);




% --- Executes on button press in findselectedbutton.
function findselectedbutton_Callback(hObject, eventdata, handles)
% hObject    handle to findselectedbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
x1=str2num(get(handles.xedit1,'String'));
x2=str2num(get(handles.xedit2,'String'));
filepos=get(handles.filebox,'Value');
methods=get(handles.methodbox,'String');
method=methods{get(handles.methodbox,'Value')};
peak_latencies=findpeaks(handles,x1,x2,filepos,method);


%update peakdata (selected epochs)
selected_epochs=get(handles.peakbox,'Value');
peakdata=get(handles.peakbox,'UserData');
peakdata(filepos).lat(selected_epochs)=peak_latencies(selected_epochs);
set(handles.peakbox,'UserData',peakdata);
%update peakbox
st={};
for epochpos=1:peakdata(filepos).header.datasize(1);
    st{epochpos}=num2str(peakdata(filepos).lat(epochpos));
end;
set(handles.peakbox,'String',st);




% --- Executes on button press in addeventbutton.
function addeventbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addeventbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update peakdata tables
updatepeakbox(handles);
update_status=get(handles.close_btn,'UserData');
update_status.function(update_status.handles,'*** Adding event.',1,0);
%fetch peakdata
peakdata=get(handles.peakbox,'UserData');
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%loop through files
for filepos=1:length(inputfiles);  
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    %load header
    header=LW_load_header(inputfiles{filepos});
    %code of the new event
    eventcode=get(handles.peaklabeledit,'String');
    %add events
    if isfield(header,'events');
        k=length(header.events)+1;
    else
        k=1;
    end;
    for epochpos=1:length(peakdata(filepos).lat);
        if isnan(peakdata(filepos).lat(epochpos));
        else
        header.events(k).code=eventcode;
        header.events(k).latency=peakdata(filepos).lat(epochpos);
        header.events(k).epoch=epochpos;
        k=k+1;
        end;
    end;
    %save header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.lw5'];
    save(st,'header');
    %store header
    peakdata(filepos).header=header;
end;
%store peakdata
set(handles.peakbox,'UserData',peakdata);
update_status.function(update_status.handles,'Finished!',0,1);
%update eventbox
updateeventbox(handles);





function peaklabeledit_Callback(hObject, eventdata, handles)
% hObject    handle to peaklabeledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function peaklabeledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to peaklabeledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in readeventbutton.
function readeventbutton_Callback(hObject, eventdata, handles)
% hObject    handle to readeventbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%fetch peakdata
peakdata=get(handles.peakbox,'UserData');
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%selected event code
eventstring=get(handles.eventbox,'String');
selectedcode=eventstring{get(handles.eventbox,'Value')};
update_status=get(handles.close_btn,'UserData');
update_status.function(update_status.handles,['Selected code : ' selectedcode],1,0);
%loop through files
for filepos=1:length(inputfiles);    
    %reset peakdata
    for epochpos=1:length(peakdata(filepos).lat);
        peakdata(filepos).lat(epochpos)=nan;
    end;
    %load header
    header=LW_load_header(inputfiles{filepos});
    %loop through events
    for eventpos=1:length(header.events);
        if strcmpi(selectedcode,header.events(eventpos).code);
            peakdata(filepos).lat(header.events(eventpos).epoch)=header.events(eventpos).latency;
        end;
    end;
end;
%store peakdata
set(handles.peakbox,'UserData',peakdata);
%update peakbox
filepos=get(handles.filebox,'Value');
st={};
for epochpos=1:peakdata(filepos).header.datasize(1);
    st{epochpos}=num2str(peakdata(filepos).lat(epochpos));
end;
set(handles.peakbox,'String',st);
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on button press in updateeventbutton.
function updateeventbutton_Callback(hObject, eventdata, handles)
% hObject    handle to updateeventbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%update peakdata tables
updatepeakbox(handles);
%fetch peakdata
peakdata=get(handles.peakbox,'UserData');
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%selected eventcode
eventstring=get(handles.eventbox,'String');
eventcode=eventstring{get(handles.eventbox,'Value')};
update_status=get(handles.close_btn,'UserData');
update_status.function(update_status.handles,['Selected code : ' eventcode],1,0);
%loop through files
for filepos=1:length(inputfiles);    
    %load header
    header=LW_load_header(inputfiles{filepos});
    %delete previous events with that code
    todelete=[];
    k=1;
    for eventpos=1:length(header.events);
        if strcmpi(header.events(eventpos).code,eventcode);
            todelete(k)=eventpos;
            k=k+1;
        end;
    end;
    header.events(todelete)=[];
    %add events
    k=length(header.events)+1;
    for epochpos=1:length(peakdata(filepos).lat);
        if isnan(peakdata(filepos).lat(epochpos));
        else
        header.events(k).code=eventcode;
        header.events(k).latency=peakdata(filepos).lat(epochpos);
        header.events(k).epoch=epochpos;
        k=k+1;
        end;
    end;
    %save header
    [p,n,e]=fileparts(inputfiles{filepos});
    st=[p,filesep,n,'.lw5'];
    save(st,'header');
    %store header
    peakdata(filepos).header=header;
end;
%store peakdata
set(handles.peakbox,'UserData',peakdata);
%update eventbox
updateeventbox(handles);
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on button press in close_btn.
function close_btn_Callback(hObject, eventdata, handles)
% hObject    handle to close_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;
