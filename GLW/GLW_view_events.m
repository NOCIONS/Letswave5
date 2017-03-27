function varargout = GLW_view_events(varargin)
% GLW_VIEW_EVENTS MATLAB code for GLW_view_events.fig
%
% Author : 
% Andr Mouraux
% Institute of Neurosciences (IONS)
% Universit catholique de louvain (UCL)
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
                   'gui_OpeningFcn', @GLW_view_events_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_view_events_OutputFcn, ...
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




% --- Executes just before GLW_view_events is made visible.
function GLW_view_events_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_view_events (see VARARGIN)
% Choose default command line output for GLW_view_events
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.text_label,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
inputfiles=get(handles.filebox,'UserData');
%clean files
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
%extract events
eventdata.codes={};
eventdata.filepos=[];
for filepos=1:length(inputfiles);
    %load header
    header=LW_load_header(inputfiles{filepos});
    %continue if events are present
    if isfield(header,'events');
        eventstring={};
        filelist=[];
        %loop through events
        for i=1:length(header.events);
            %check that header is not already extracted
            if isempty(find(strcmpi(header.events(i).code,eventstring)));
                eventstring{length(eventstring)+1}=header.events(i).code;
                filelist(length(filelist)+1)=filepos;
            end;
        end;
        %add events if some were found
        if isempty(eventstring);
        else
            eventdata.codes=[eventdata.codes eventstring];
            eventdata.filepos=[eventdata.filepos filelist];
        end;
    end;
end;
%store eventdata
set(handles.eventbox,'UserData',eventdata);
%set eventbox string
st={};
for i=1:length(eventdata.codes);
    st{i}=[cleanfiles{eventdata.filepos(i)} ' : ' eventdata.codes{i}];
end;
set(handles.eventbox,'String',st);
%indexedit,yedit,zedit
set(handles.indexedit,'String','1');
set(handles.yedit,'String',num2str(header.ystart));
set(handles.zedit,'String',num2str(header.zstart));
%enable/disable yedit,zedit,index
if header.datasize(5)==1;
    set(handles.yedit,'Enable','off');
end;
if header.datasize(4)==1;
    set(handles.zedit,'Enable','off');
end;
if header.datasize(3)==1;
    set(handles.indexedit,'Enable','off');
end;
%channelbox
st={};
for i=1:length(header.chanlocs);
    st{i}=header.chanlocs(i).labels;
end;
set(handles.channelbox,'String',st);









% --- Outputs from this function are returned to the command line.
function varargout = GLW_view_events_OutputFcn(hObject, eventdata, handles) 
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




% --- Executes on button press in topoplotbutton.
function topoplotbutton_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%eventdata
eventdata=fetch_eventdata(handles);
%mean (tpm(channels,events)
tp=[];
tpm=[];
for i=1:length(eventdata);
    for j=1:length(eventdata(i).events);
        tp(:,j)=eventdata(i).events(j).data;
    end;
    tpm(:,i)=mean(tp,2);    
end;
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%topoplot?
if get(handles.topoplotchk,'Value')==1;
    figure;
    for i=1:size(tpm,2);
        %subaxis
        subaxis(1,size(tpm,2),i,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
        %load header
        header=LW_load_header(inputfiles{eventdata(i).events(1).filepos});
        vector=tpm(:,i);
        chanlocs=header.chanlocs;
        %parse data and chanlocs according to topo_enabled
        k=1;
        for chanpos=1:size(chanlocs,2);
            if chanlocs(chanpos).topo_enabled==1
                vector2(k)=vector(chanpos);
                chanlocs2(k)=chanlocs(chanpos);
                k=k+1;
            end;
        end;
        CLim=[str2num(get(handles.clim1edit,'String')) str2num(get(handles.clim2edit,'String'))]
        h=topoplot(vector2,chanlocs2,'gridscale',128,'shading','interp','whitebk','on','maplimits',CLim);
        [p,n,e]=fileparts(inputfiles{eventdata(i).events(1).filepos});
        title([n ' : ' eventdata(i).events(1).code]);
    end;
    set(gcf,'color',[1 1 1]);
end;
%headplot?
if get(handles.headplotchk,'Value')==1;
    figure;
    for i=1:size(tpm,2);
        %subaxis
        subaxis(1,size(tpm,2),i,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
        %load header
        header=LW_load_header(inputfiles{eventdata(i).events(1).filepos});
        vector=tpm(:,i);
        chanlocs=header.chanlocs;
        %parse data and chanlocs according to topo_enabled
        k=1;
        for chanpos=1:size(chanlocs,2);
            if chanlocs(chanpos).topo_enabled==1
                vector2(k)=vector(chanpos);
                chanlocs2(k)=chanlocs(chanpos);
                k=k+1;
            end;
        end;
        CLim=[str2num(get(handles.clim1edit,'String')) str2num(get(handles.clim2edit,'String'))]
        h=headplot(vector2,header.filename_spl,'maplimits',CLim);
        [p,n,e]=fileparts(inputfiles{eventdata(i).events(1).filepos});
        title([n ' : ' eventdata(i).events(1).code]);
    end;
    set(gcf,'color',[1 1 1]);
end;






function eventdata=fetch_eventdata(handles);
data=get(handles.eventbox,'UserData');
selected=get(handles.eventbox,'Value');
eventcodes=data.codes(selected)
eventfiles=data.filepos(selected)
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%y,z,indexpos
indexpos=str2num(get(handles.indexedit,'String'));
y=str2num(get(handles.yedit,'String'));
z=str2num(get(handles.zedit,'String'));
%fetch data
for i=1:length(eventcodes);
    %filename
    filename=inputfiles{eventfiles(i)};
    %load header data
    [header,data]=LW_load(filename);
    %dz
    dz=1+round((z-header.zstart)/header.zstep);
    %dy
    dy=1+round((y-header.ystart)/header.ystep);
    %loop through events
    eventpos2=1;
    for eventpos=1:length(header.events);
        if strcmpi(header.events(eventpos).code,eventcodes{i});
            eventdata(i).events(eventpos2).code=header.events(eventpos).code;
            eventdata(i).events(eventpos2).filepos=eventfiles(i);
            eventdata(i).events(eventpos2).latency=header.events(eventpos).latency;
            eventdata(i).events(eventpos2).epoch=header.events(eventpos).epoch;
            %dx
            dx=1+round((eventdata(i).events(eventpos2).latency-header.xstart)/header.xstep);
            eventdata(i).events(eventpos2).data=squeeze(data(eventdata(i).events(eventpos2).epoch,:,indexpos,dz,dy,dx));
            eventpos2=eventpos2+1;
        end;
    end;    
end;





% --- Executes on button press in topoplotchk.
function topoplotchk_Callback(hObject, eventdata, handles)
% hObject    handle to topoplotchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function indexedit_Callback(hObject, eventdata, handles)
% hObject    handle to indexedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function indexedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to indexedit (see GCBO)
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




% --- Executes on button press in headplotchk.
function headplotchk_Callback(hObject, eventdata, handles)
% hObject    handle to headplotchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function clim1edit_Callback(hObject, eventdata, handles)
% hObject    handle to clim1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function clim1edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim1edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function clim2edit_Callback(hObject, eventdata, handles)
% hObject    handle to clim2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function clim2edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clim2edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in tablebutton.
function tablebutton_Callback(hObject, eventdata, handles)
% hObject    handle to tablebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%eventdata
eventdata=fetch_eventdata(handles);
%selected channels
selected_channels=get(handles.channelbox,'Value');
%channel labels
channel_labels=get(handles.channelbox,'String');
%inputfiles
inputfiles=get(handles.filebox,'String');
%mean latency
%std latency
%mean amplitude at selected channels
%std amplitude at selected channels
table=[];
for linepos=1:length(eventdata);
    latency=[];
    amplitude=[];
    std_latency=[];
    std_amplitude=[];
    mean_latency=[];
    mean_amplitude=[];
    for eventpos=1:length(eventdata(linepos).events);
        %latency
        latency(eventpos)=eventdata(linepos).events(eventpos).latency;
        %amplitude
        amplitude(eventpos,:)=eventdata(linepos).events(eventpos).data(selected_channels);
    end;
    mean_latency=squeeze(mean(latency));
    mean_amplitude=squeeze(mean(amplitude,1));
    std_latency=squeeze(std(latency));
    std_amplitude=squeeze(std(amplitude,0,1));
    table(1,linepos)=mean_latency;
    table(2,linepos)=std_latency;
    for i=1:length(mean_amplitude);
        table(3+(2*(i-1)),linepos)=mean_amplitude(i);
        table(4+(2*(i-1)),linepos)=std_amplitude(i);
    end;        
end;
%column headers
colnames{1}='data';
colnames{2}='event';
colnames{3}='lat ';
colnames{4}='lat (sd)';
for i=1:length(selected_channels);
    colnames{5+(2*(i-1))}=channel_labels{selected_channels(i)};
    colnames{6+(2*(i-1))}=[channel_labels{selected_channels(i)} ' (sd)'];
end;
tabledata={};
for i=1:length(eventdata);
    %columns 1 and 2
    tabledata{i,1}=inputfiles{eventdata(i).events(1).filepos};
    tabledata{i,2}=eventdata(i).events(1).code; 
    %other columns
    for j=1:size(table,1);
        tabledata{i,j+2}=num2str(table(j,i));
    end;
end;
GLW_events_table(tabledata,colnames);







% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
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


% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%eventdata
eventdata=fetch_eventdata(handles);
%selected channels
selected_channels=get(handles.channelbox,'Value');
%channel labels
channel_labels=get(handles.channelbox,'String');
%inputfiles
inputfiles=get(handles.filebox,'String');
%mean latency
%std latency
%mean amplitude at selected channels
%std amplitude at selected channels
table=[];
k=1;
for linepos=1:length(eventdata);
    for eventpos=1:length(eventdata(linepos).events);
        %filename
        eventdata(linepos).events.filepos
        table{k,1}=inputfiles{eventdata(linepos).events(eventpos).filepos};
        %eventcode
        table{k,2}=eventdata(linepos).events(eventpos).code;
        %eventepoch
        table{k,3}=num2str(eventdata(linepos).events(eventpos).epoch);
        %latency
        table{k,4}=num2str(eventdata(linepos).events(eventpos).latency);
        %amplitude
        table{k,5}=num2str(eventdata(linepos).events(eventpos).data(selected_channels(1)));
        k=k+1;
    end;
end;
%column headers
colnames{1}='filename';
colnames{2}='eventcode';
colnames{3}='eventepoch ';
colnames{4}='latency';
colnames{5}='amplitude';

GLW_events_table(table,colnames);
