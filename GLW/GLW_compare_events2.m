function varargout = GLW_compare_events2(varargin)
% GLW_COMPARE_EVENTS2 MATLAB code for GLW_compare_events2.fig
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
                   'gui_OpeningFcn', @GLW_compare_events2_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_compare_events2_OutputFcn, ...
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




% --- Executes just before GLW_compare_events2 is made visible.
function GLW_compare_events2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_compare_events2 (see VARARGIN)
% Choose default command line output for GLW_compare_events2
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
%filebox1
set(handles.filebox1,'String',cleanfiles);
set(handles.filebox1,'Value',1);
%filebox2
set(handles.filebox2,'String',cleanfiles);
set(handles.filebox2,'Value',1);
%eventbox1
eventstring=findevents(handles,get(handles.filebox1,'Value'));
set(handles.eventbox1,'String',eventstring);
set(handles.eventbox1,'Value',1);
%eventbox2
eventstring=findevents(handles,get(handles.filebox2,'Value'))
set(handles.eventbox2,'String',eventstring);
set(handles.eventbox2,'Value',1);
%epochbox1
codes=get(handles.eventbox1,'String');
code=codes{get(handles.eventbox1,'Value')};
filepos=get(handles.filebox1,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox1,'UserData',data);
set(handles.epochbox1,'String',stringlist);
%epochbox2
codes=get(handles.eventbox2,'String');
code=codes{get(handles.eventbox2,'Value')};
filepos=get(handles.filebox2,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox2,'UserData',data);
set(handles.epochbox2,'String',stringlist);
%header
header=LW_load_header(inputfiles{1});
%indexedit,yedit,zedit
set(handles.indexedit,'String','1');
set(handles.yedit,'String',num2str(header.ystart));
set(handles.zedit,'String',num2str(header.zstart));
%channelbox
st={};
for i=1:length(header.chanlocs);
    st{i}=header.chanlocs(i).labels;
end;
set(handles.channelbox,'String',st);






function [stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
%inputfiles
inputfiles=get(handles.filebox,'UserData');
inputfile=inputfiles{filepos};
%load header
header=LW_load_header(inputfile);
%loop through epochs
eventlist=[];
epochlist=[];
if isfield(header,'events');
    for epochpos=1:header.datasize(1);
        stringlist{epochpos}=[num2str(epochpos) ' : NaN'];
        %loop through events
        for i=1:length(header.events);
            if strcmpi(header.events(i).code,code);
                if header.events(i).epoch==epochpos;
                    if isempty(find(epochlist==epochpos));
                        epochlist=[epochlist epochpos];
                        eventlist=[eventlist i];
                        stringlist{epochpos}=[num2str(epochpos) ' : ' num2str(header.events(i).latency)];
                    end;
                end;
            end;
        end;
    end;
end;






function eventstring=findevents(handles,filepos);
%inputfiles
inputfiles=get(handles.filebox,'UserData');
inputfile=inputfiles{filepos};
%load header
header=LW_load_header(inputfile);
%loop through events
st={};
if isfield(header,'events');
    for i=1:length(header.events);
        if isempty(find(strcmpi(st,header.events(i).code)));
            st{length(st)+1}=header.events(i).code;
        end;
    end;
end;
eventstring=st;




% --- Outputs from this function are returned to the command line.
function varargout = GLW_compare_events2_OutputFcn(hObject, eventdata, handles) 
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





% --- Executes on selection change in eventbox1.
function eventbox1_Callback(hObject, eventdata, handles)
% hObject    handle to eventbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%epochbox1
codes=get(handles.eventbox1,'String');
code=codes{get(handles.eventbox1,'Value')};
filepos=get(handles.filebox1,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox1,'UserData',data);
set(handles.epochbox1,'String',stringlist);







% --- Executes during object creation, after setting all properties.
function eventbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventbox1 (see GCBO)
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
%output
%output.p(chanpos,indexpos,dz,dy)=p;
%output.h(chanpos,indexpos,dz,dy)=h;
%output.header
output=get(handles.comparebutton,'UserData');
%indexpos
indexpos=str2num(get(handles.indexedit,'String'));
%dz
z=str2num(get(handles.zedit,'String'));
dz=1+round((z-output.header.zstart)/output.header.zstep);
%dy
y=str2num(get(handles.yedit,'String'));
dy=1+round((y-output.header.ystart)/output.header.ystep);
%topoplot?
if get(handles.topoplotchk,'Value')==1;
    figure;
    %p
    %subaxis
    subaxis(1,4,1,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    vector=squeeze(output.p(:,indexpos,dz,dy));
    chanlocs=output.header.chanlocs;
    %parse data and chanlocs according to topo_enabled
    k=1;
    for chanpos=1:size(chanlocs,2);
        if chanlocs(chanpos).topo_enabled==1
            vector2(k)=vector(chanpos);
            chanlocs2(k)=chanlocs(chanpos);
            k=k+1;
        end;
    end;
    h=topoplot(vector2,chanlocs2,'gridscale',128,'shading','interp','whitebk','on');
    title('p');
    %h
    %subaxis
    subaxis(1,4,2,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    vector=squeeze(output.h(:,indexpos,dz,dy));
    chanlocs=output.header.chanlocs;
    %parse data and chanlocs according to topo_enabled
    k=1;
    for chanpos=1:size(chanlocs,2);
        if chanlocs(chanpos).topo_enabled==1
            vector2(k)=vector(chanpos);
            chanlocs2(k)=chanlocs(chanpos);
            k=k+1;
        end;
    end;
    h=topoplot(vector2,chanlocs2,'gridscale',128,'shading','interp','whitebk','on');
    title('h');
    %mean1
    %subaxis
    subaxis(1,4,3,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    vector=squeeze(output.mean1(:,indexpos,dz,dy));
    chanlocs=output.header.chanlocs;
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
    title('mean A');
    %mean2
    %subaxis
    subaxis(1,4,4,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    vector=squeeze(output.mean2(:,indexpos,dz,dy));
    chanlocs=output.header.chanlocs;
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
    title('mean B');
    set(gcf,'color',[1 1 1]);
end;
%headplot?
if get(handles.headplotchk,'Value')==1;
    figure;
    vector=squeeze(output.p(:,indexpos,dz,dy));
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
    set(gcf,'color',[1 1 1]);
end;






function eventdata=fetch_eventdata(handles);
data=get(handles.eventbox1,'UserData');
selected=get(handles.eventbox1,'Value');
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
%output
%output.p(chanpos,indexpos,dz,dy)=p;
%output.h(chanpos,indexpos,dz,dy)=h;
%output.mean1(chanpos,indexpos,dz,dy)=h;
%output.std1(chanpos,indexpos,dz,dy)=h;
%output.mean2(chanpos,indexpos,dz,dy)=h;
%output.std2(chanpos,indexpos,dz,dy)=h;
%output.header
output=get(handles.comparebutton,'UserData');
%selected channels
selected_channels=get(handles.channelbox,'Value');
%channel labels
channel_labels=get(handles.channelbox,'String');
%column headers
colnames{1}='channel';
colnames{2}='mean(A)';
colnames{3}='sd(A)';
colnames{4}='mean(B)';
colnames{5}='sd(B)';
colnames{6}='h';
colnames{7}='p';
%indexpos
indexpos=str2num(get(handles.indexedit,'String'));
%dz
z=str2num(get(handles.zedit,'String'));
dz=1+round((z-output.header.zstart)/output.header.zstep);
%dy
y=str2num(get(handles.yedit,'String'));
dy=1+round((y-output.header.ystart)/output.header.ystep);
%(chanpos,indexpos,dz,dy);
tabledata={};
for i=1:length(selected_channels);
    tabledata{i,1}=output.header.chanlocs(selected_channels(i)).labels;
    tabledata{i,2}=num2str(output.mean1(selected_channels(i),indexpos,dz,dy));
    tabledata{i,3}=num2str(output.std1(selected_channels(i),indexpos,dz,dy));
    tabledata{i,4}=num2str(output.mean2(selected_channels(i),indexpos,dz,dy));
    tabledata{i,5}=num2str(output.std2(selected_channels(i),indexpos,dz,dy));
    tabledata{i,6}=num2str(output.h(selected_channels(i),indexpos,dz,dy));
    tabledata{i,7}=num2str(output.p(selected_channels(i),indexpos,dz,dy));
end;
tabledata
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




% --- Executes on selection change in epochbox1.
function epochbox1_Callback(hObject, eventdata, handles)
% hObject    handle to epochbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in filebox1.
function filebox1_Callback(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%eventbox1
eventstring=findevents(handles,get(handles.filebox1,'Value'))
set(handles.eventbox1,'String',eventstring);
set(handles.eventbox1,'Value',1);
%epochbox1
codes=get(handles.eventbox1,'String');
code=codes{get(handles.eventbox1,'Value')};
filepos=get(handles.filebox1,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox1,'UserData',data);
set(handles.epochbox1,'String',stringlist);





% --- Executes during object creation, after setting all properties.
function filebox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in eventbox2.
function eventbox2_Callback(hObject, eventdata, handles)
% hObject    handle to eventbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%epochbox2
codes=get(handles.eventbox2,'String');
code=codes{get(handles.eventbox2,'Value')};
filepos=get(handles.filebox2,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox2,'UserData',data);
set(handles.epochbox2,'String',stringlist);





% --- Executes during object creation, after setting all properties.
function eventbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eventbox2 (see GCBO)
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
%eventbox2
eventstring=findevents(handles,get(handles.filebox2,'Value'))
set(handles.eventbox2,'String',eventstring);
set(handles.eventbox2,'Value',1);
%epochbox2
codes=get(handles.eventbox2,'String');
code=codes{get(handles.eventbox2,'Value')};
filepos=get(handles.filebox2,'Value');
[stringlist,epochlist,eventlist]=findepochs(handles,filepos,code);
data.epochlist=epochlist;
data.eventlist=eventlist;
set(handles.epochbox2,'UserData',data);
set(handles.epochbox2,'String',stringlist);






% --- Executes during object creation, after setting all properties.
function filebox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in parametricpopup.
function parametricpopup_Callback(hObject, eventdata, handles)
% hObject    handle to parametricpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function parametricpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parametricpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on selection change in pairedpopup.
function pairedpopup_Callback(hObject, eventdata, handles)
% hObject    handle to pairedpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function pairedpopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pairedpopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in comparebutton.
function comparebutton_Callback(hObject, eventdata, handles)
% hObject    handle to comparebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%type of test
parametric=get(handles.parametricpopup,'Value');
paired=get(handles.pairedpopup,'Value');
%inputfiles
inputfiles=get(handles.filebox,'UserData');
%events
tp1=get(handles.epochbox1,'UserData');
tp2=get(handles.epochbox2,'UserData');
%if paired, only keep paired events
if paired==1;    
    [tp,tp1i,tp2i]=intersect(tp1.epochlist,tp2.epochlist);
    tp1.epochlist=tp1.epochlist(tp1i);
    tp1.eventlist=tp1.eventlist(tp1i);
    tp2.epochlist=tp2.epochlist(tp2i);
    tp2.eventlist=tp2.eventlist(tp2i);
end;
%inputfile1
inputfile1=inputfiles{get(handles.filebox1,'Value')};
%header1 data1
[header1,data1]=LW_load(inputfile1);
%fetch data
%data1(channel,index,dz,dy,eventpos)
data1=zeros(header1.datasize(2),header1.datasize(3),header1.datasize(4),header1.datasize(5),length(tp1.eventlist));
for i=1:length(tp1.eventlist);
    epochpos=header1.events(tp1.eventlist(i)).epoch;
    lat=header1.events(tp1.eventlist(i)).latency;
    dx=round((lat-header1.xstart)/header1.xstep)+1;
    data1(:,:,:,:,i)=squeeze(data1(epochpos,:,:,:,:,dx));
end;
%inputfile2
inputfile2=inputfiles{get(handles.filebox2,'Value')};
%header2 data2
[header2,data2]=LW_load(inputfile2);
%fetch data
%data2(channel,index,dz,dy,eventpos)
data2=zeros(header2.datasize(2),header2.datasize(3),header2.datasize(4),header2.datasize(5),length(tp2.eventlist));
for i=1:length(tp2.eventlist);
    epochpos=header2.events(tp2.eventlist(i)).epoch;
    lat=header2.events(tp2.eventlist(i)).latency;
    dx=round((lat-header2.xstart)/header2.xstep)+1;
    data2(:,:,:,:,i)=squeeze(data2(epochpos,:,:,:,:,dx));
end;
%disp
update_status=get(handles.text_label,'UserData');
if parametric==1;
    if paired==1;
        update_status.function(update_status.handles,'*** Performing a paired t-test.',0,0);
    else
        update_status.function(update_status.handles,'*** Performing a t-test for 2 independent samples.',0,0);
    end;
else
    if paired==1;
        update_status.function(update_status.handles,'*** Performing a Wilcoxon signed rank test for paired samples.',0,0);
    else
        update_status.function(update_status.handles,'*** Perfoming a Wilcoxon rank sum test for 2 independent samples.',0,0);
    end;
end;
%statistics
%loop through channels
for chanpos=1:header1.datasize(2);
    %loop through index
    for indexpos=1:header1.datasize(3);
        %loop through z
        for dz=1:header1.datasize(4);
            %loop through y
            for dy=1:header1.datasize(5);
                v1=squeeze(data1(chanpos,indexpos,dz,dy,:));
                v2=squeeze(data2(chanpos,indexpos,dz,dy,:));
                if parametric==1;
                    if paired==1;
                        [h,p]=ttest(v1,v2);
                    else
                        [h,p]=ttest2(v1,v2);
                    end;
                else
                    if paired==1;
                        [p,h]=signrank(v1,v2);
                    else
                        [p,h]=ranksum(v1,v2);
                    end;
                end;
                output.p(chanpos,indexpos,dz,dy)=p;
                output.h(chanpos,indexpos,dz,dy)=h;
                output.mean1(chanpos,indexpos,dz,dy)=mean(v1);
                output.mean2(chanpos,indexpos,dz,dy)=mean(v2);
                output.std1(chanpos,indexpos,dz,dy)=std(v1);
                output.std2(chanpos,indexpos,dz,dy)=std(v2);
            end;
        end;
    end;
end;
output.header=header1;
set(handles.comparebutton,'UserData',output);
    
