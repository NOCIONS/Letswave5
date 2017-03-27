function varargout = GLW_ica_filter(varargin)
% GLW_ICA_FILTER MATLAB code for GLW_ica_filter.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ica_filter_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ica_filter_OutputFcn, ...
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





% --- Executes just before GLW_ica_filter is made visible.
function GLW_ica_filter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ica_filter (see VARARGIN)
% Choose default command line output for GLW_ica_filter
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
inputfiles={};
inputfiles=varargin{2};
for filepos=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{filepos});
    clean_inputfiles{filepos}=[n];
end;
%inputfiles without path
set(handles.filebox,'String',clean_inputfiles);
set(handles.filebox,'Value',1);
%inputdir
set(handles.inputdir,'String',p);
%load
for filepos=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{filepos});
    %store header and data
    userdata(filepos).header=header;
    userdata(filepos).data=data;
    if isfield(header,'filename_bss');
        filename_bss=header.filename_bss;
    else
        return;
    end;
    %load header of matrix
    [p2,n2,e2]=fileparts(filename_bss);
    filename_bss=[p,filesep,n2,'.lw5'];
    [header,data]=LW_load(filename_bss);
    %store matrix header and data
    userdata(filepos).matrixheader=header;
    userdata(filepos).matrixdata=data;
    %fill ICbox1
    userdata(filepos).acceptedICs=1:1:header.datasize(6);
    userdata(filepos).rejectedICs=[];
    for i=1:header.datasize(6);
        userdata(filepos).ICstring{i}=['IC',num2str(i)];
    end;
end;
set(handles.inputdir,'UserData',userdata);
updatelists(handles);
updateICs(handles);
%applycurrentbutton enabled?
ok=0;
if length(userdata)>1;
    %disp(num2str(length(userdata)));
    ok=1;
    k=length(userdata(1).acceptedICs);
    for i=1:length(userdata);
        j=length(userdata(i).acceptedICs);
        if j==k;
        else
            ok=0;
        end;
    end;
end;
if ok==0;
    %disp('hiding');
    set(handles.applycurrentbutton,'Enable','off');
end;




function updatelists(handles);
userdata=get(handles.inputdir,'UserData');
%filename
index=get(handles.filebox,'Value');
%header
header=userdata(index(1)).header;
%fill epochbox
for epochpos=1:header.datasize(1);
    epochstring{epochpos}=num2str(epochpos);
end;
set(handles.epochbox,'Value',1);
set(handles.epochbox,'ListboxTop',1);
set(handles.epochbox,'String',epochstring);
%fill chanbox
for chanpos=1:header.datasize(2);
    chanstring{chanpos}=header.chanlocs(chanpos).labels;
end;
set(handles.chanbox,'Value',1);
set(handles.chanbox,'ListboxTop',1);
set(handles.chanbox,'String',chanstring);
%enable topos?
oktopo=0;
for chanpos=1:header.datasize(2);
    if header.chanlocs(chanpos).topo_enabled==1;
        oktopo=1;
    end;
end;
if oktopo==0;
    set(handles.ICmapbutton1,'Enable','off');
    set(handles.ICmapbutton2,'Enable','off');
else
    set(handles.ICmapbutton1,'Enable','on');
    set(handles.ICmapbutton2,'Enable','on');
end;
    




function updateICs(handles);
userdata=get(handles.inputdir,'UserData');
index=get(handles.filebox,'Value');
set(handles.ICbox1,'ListboxTop',1);
set(handles.ICbox2,'ListboxTop',1);
set(handles.ICbox1,'Value',[]);
set(handles.ICbox2,'Value',[]);
set(handles.ICbox1,'String',userdata(index).ICstring(userdata(index).acceptedICs));
set(handles.ICbox2,'String',userdata(index).ICstring(userdata(index).rejectedICs));




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ica_filter_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB(
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
updatelists(handles);
updateICs(handles);
updatesignal(handles);
updateicfig(handles);



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
userdata=get(handles.inputdir,'UserData');
inputfiles=get(handles.filebox,'String');
inputdir=get(handles.inputdir,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Applying selected ICA filter.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    %load header and data
    inheader=userdata(filepos).header;
    indata=userdata(filepos).data;
    %load matrix header and data
    %load header of matrix
    matrixheader=userdata(filepos).matrixheader;
    matrixdata=userdata(filepos).matrixdata;
    %unmix signals
    update_status.function(update_status.handles,'Unmixing signals.',1,0);
    [header,data]=LW_ica_unmix(inheader,indata,matrixheader,matrixdata);
    %selectedICs
    selectedICs=userdata(filepos).acceptedICs;
    update_status.function(update_status.handles,['Selected ICs : ',num2str(selectedICs)],1,0);
    %edit matrix
    update_status.function(update_status.handles,'Adjusting ICA matrix.',1,0);
    [matrixheader,matrixdata]=LW_ica_editmatrix(matrixheader,matrixdata,selectedICs);
    %remix signals
    update_status.function(update_status.handles,'Remixing signals.',1,0);
    [header,data]=LW_ica_mix(header,data,matrixheader,matrixdata);
    [p n e]=fileparts(inputfiles{filepos});
    filename=[inputdir filesep n];
    LW_save(filename,get(handles.prefixtext,'String'),header,data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes during object creation, after setting all properties.
function numedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in popupmethod.
function popupmethod_Callback(hObject, eventdata, handles)
% hObject    handle to popupmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function popupmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmethod (see GCBO)
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
updatesignal(handles);
updateicfig(handles);




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
updatesignal(handles);


% --- Executes during object creation, after setting all properties.
function chanbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in ICbox1.
function ICbox1_Callback(hObject, eventdata, handles)
% hObject    handle to ICbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ICbox2,'Value',[]);
updateicfig(handles);




% --- Executes during object creation, after setting all properties.
function ICbox1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in ICbox2.
function ICbox2_Callback(hObject, eventdata, handles)
% hObject    handle to ICbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.ICbox1,'Value',[]);
updateicfig(handles);




% --- Executes during object creation, after setting all properties.
function ICbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ICbox2 (see GCBO)
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
userdata=get(handles.inputdir,'UserData');
sel=get(handles.ICbox1,'Value');
index=get(handles.filebox,'Value');
userdata(index).rejectedICs=sort([userdata(index).rejectedICs,userdata(index).acceptedICs(sel)]);
userdata(index).acceptedICs(sel)=[];
set(handles.inputdir,'UserData',userdata);
updateICs(handles);
updatesignal(handles);
updateicfig(handles);




% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata=get(handles.inputdir,'UserData');
index=get(handles.filebox,'Value');
userdata(index).rejectedICs=1:1:length(userdata(index).ICstring);
userdata(index).acceptedICs=[];
set(handles.inputdir,'UserData',userdata);
updateICs(handles);
updatesignal(handles);
updateicfig(handles);





% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata=get(handles.inputdir,'UserData');
sel=get(handles.ICbox2,'Value');
index=get(handles.filebox,'Value');
userdata(index).acceptedICs=sort([userdata(index).acceptedICs,userdata(index).rejectedICs(sel)]);
userdata(index).rejectedICs(sel)=[];
set(handles.inputdir,'UserData',userdata);
updateICs(handles);
updatesignal(handles);
updateicfig(handles);




% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata=get(handles.inputdir,'UserData');
index=get(handles.filebox,'Value');
userdata(index).acceptedICs=1:1:length(userdata(index).ICstring);
userdata(index).rejectedICs=[];
set(handles.inputdir,'UserData',userdata);
updateICs(handles);
updatesignal(handles);
updateicfig(handles);




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over icafilename.
function icafilename_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to icafilename (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in ICmapbutton1.
function ICmapbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to ICmapbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot IC scalpmaps
userdata=get(handles.inputdir,'UserData');
%select and eventually create figure if it does not exist
if isfield(userdata(1),'topofigure');
    figure(userdata(1).topofigure);
    set(userdata(1).topofigure,'ToolBar','none');
    set(userdata(1).topofigure,'Name','IC maps');
else
    userdata(1).topofigure=figure;  
    set(userdata(1).topofigure,'ToolBar','none');
    set(userdata(1).topofigure,'Name','IC maps');
end;
%index
index=get(handles.filebox,'Value');
%fetch matrix header and data
matrixheader=userdata(index).matrixheader;
matrixdata=userdata(index).matrixdata;
%selectedICs
selectedICs=userdata(index).acceptedICs(get(handles.ICbox1,'Value'));
%loop through selectedICs
for icpos=1:length(selectedICs);
    a=subaxis(1,length(selectedICs),icpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
    title(a,['IC',num2str(selectedICs(icpos))]);
    LW_topoplot(matrixheader,matrixdata,1,2,selectedICs(icpos),1,1,'shading','interp','whitebk','on');
end;
set(handles.inputdir,'UserData',userdata);




% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata=get(handles.inputdir,'UserData');
%select and eventually create figure if it does not exist
if isfield(userdata(1),'signalfigure');
    figure(userdata(1).signalfigure);
    set(userdata(1).signalfigure,'ToolBar','none');
    set(userdata(1).signalfigure,'Name','filtered signals');    
else
    userdata(1).signalfigure=figure;  
    set(userdata(1).signalfigure,'ToolBar','none');
    set(userdata(1).signalfigure,'Name','filtered signals');    
end;
set(handles.inputdir,'UserData',userdata);
updatesignal(handles);




function updateicfig(handles);
userdata=get(handles.inputdir,'UserData');
if isfield(userdata(1),'icfigure');
    figure(userdata(1).icfigure);
    %fetch data to plot
    index=get(handles.filebox,'Value');
    %header and data
    header=userdata(index(1)).header;
    data=userdata(index(1)).data;
    %tpx
    tpx=1:1:header.datasize(6);
    tpx=((tpx-1)*header.xstep)+header.xstart;
    %matrix header and data
    matrixheader=userdata(index(1)).matrixheader;
    matrixdata=userdata(index(1)).matrixdata;
    %selectedICs
    selectedICs=userdata(index(1)).acceptedICs(get(handles.ICbox1,'Value'));
    rejectedICs=userdata(index(1)).rejectedICs(get(handles.ICbox2,'Value'));
    displayedICs=[selectedICs,rejectedICs];
    %legendstring
    if length(displayedICs)>0;
        for i=1:length(displayedICs);
            legendstring{i}=['IC',num2str(displayedICs(i))];
        end;
    end;
    %selected epochs
    epochs=get(handles.epochbox,'Value');
    %selected channels
    channels=get(handles.chanbox,'Value');
    %display signals
    if length(displayedICs)
        %unmix signal
        [header,data]=LW_ica_unmix_epoch(header,data,matrixheader,matrixdata,epochs(1));
        %plot displayedICs
        plot(tpx,squeeze(data(1,displayedICs,1,1,1,:)));
        %legend
        legend(legendstring);
    end;
end;





function updatesignal(handles);
userdata=get(handles.inputdir,'UserData');
if isfield(userdata(1),'signalfigure');
    figure(userdata(1).signalfigure);    
    %fetch data to plot
    index=get(handles.filebox,'Value');
    %header and data
    header=userdata(index(1)).header;
    data=userdata(index(1)).data;
    %tpx
    tpx=1:1:header.datasize(6);
    tpx=((tpx-1)*header.xstep)+header.xstart;
    %matrix header and data
    matrixheader=userdata(index(1)).matrixheader;
    matrixdata=userdata(index(1)).matrixdata;
    %selectedICs
    selectedICs=userdata(index(1)).acceptedICs;
    %selected epochs
    epochs=get(handles.epochbox,'Value');
    %selected channels
    channels=get(handles.chanbox,'Value');
    %plot original signal
    plot(tpx,squeeze(data(epochs(1),channels(1),1,1,1,:)),'k');
    if length(selectedICs)>0;
        %unmix signal
        [header,data]=LW_ica_unmix_epoch(header,data,matrixheader,matrixdata,epochs(1));
        %edit ICA matrix
        [matrixheader,matrixdata]=LW_ica_editmatrix(matrixheader,matrixdata,selectedICs);
        %remix signal with selectedICs
        [header,data]=LW_ica_mix(header,data,matrixheader,matrixdata);
        %plot filtered signal
        hold on;
        plot(tpx,squeeze(data(1,channels(1),1,1,1,:)),'r');
        hold off;
    end;
    legendstring{1}='unfiltered';
    legendstring{2}='filtered';
    legend(legendstring);
end;




% --- Executes on button press in ICmapbutton2.
function ICmapbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to ICmapbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Plot IC scalpmaps
userdata=get(handles.inputdir,'UserData');
%select and eventually create figure if it does not exist
if isfield(userdata(1),'topofigure');
    figure(userdata(1).topofigure);
    set(userdata(1).topofigure,'ToolBar','none');
    set(userdata(1).topofigure,'Name','IC maps');        
else
    userdata(1).topofigure=figure;  
    set(userdata(1).topofigure,'ToolBar','none');
    set(userdata(1).topofigure,'Name','IC maps');
end;
%index
index=get(handles.filebox,'Value');
%fetch matrix header and data
matrixheader=userdata(index).matrixheader;
matrixdata=userdata(index).matrixdata;
%selectedICs
selectedICs=userdata(index).rejectedICs(get(handles.ICbox2,'Value'));
%loop through selectedICs
if isempty(selectedICs);
    disp('No IC selected, unable to plot an IC map.');
else
    for icpos=1:length(selectedICs);
        a=subaxis(1,length(selectedICs),icpos,'MarginLeft',0.01,'MarginRight',0.01,'MarginTop',0.01,'MarginBottom',0.01);
        title(a,['IC',num2str(selectedICs(icpos))]);
        LW_topoplot(matrixheader,matrixdata,1,2,selectedICs(icpos),1,1,'shading','interp','whitebk','on');
    end;
end;
set(handles.inputdir,'UserData',userdata);




% --- Executes on button press in pushbutton10.
function pushbutton10_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton10 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
userdata=get(handles.inputdir,'UserData');
%select and eventually create figure if it does not exist
if isfield(userdata(1),'icfigure');
    figure(userdata(1).icfigure);
    set(userdata(1).icfigure,'ToolBar','none');
    set(userdata(1).icfigure,'Name','IC timecourse');        
else
    userdata(1).icfigure=figure;  
    set(userdata(1).icfigure,'ToolBar','none');
    set(userdata(1).icfigure,'Name','IC timecourse');        
end;
set(handles.inputdir,'UserData',userdata);
updateicfig(handles);





% --- Executes on button press in applycurrentbutton.
function applycurrentbutton_Callback(hObject, eventdata, handles)
% hObject    handle to applycurrentbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
index=get(handles.filebox,'Value');
userdata=get(handles.inputdir,'UserData');
rejectedICs=userdata(index).rejectedICs;
acceptedICs=userdata(index).acceptedICs;
for i=1:length(userdata);
    userdata(i).rejectedICs=rejectedICs;
    userdata(i).acceptedICs=acceptedICs;
end;
set(handles.inputdir,'UserData',userdata);
