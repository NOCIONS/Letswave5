function varargout = GLW_fieldtrip_dipfit_fitdipole_events(varargin)
% GLW_FIELDTRIP_DIPFIT_FITDIPOLE_EVENTS MATLAB code for GLW_fieldtrip_dipfit_fitdipole_events.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_fieldtrip_dipfit_fitdipole_events_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fieldtrip_dipfit_fitdipole_events_OutputFcn, ...
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





% --- Executes just before GLW_fieldtrip_dipfit_fitdipole_events is made visible.
function GLW_fieldtrip_dipfit_fitdipole_events_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fieldtrip_dipfit_fitdipole_events (see VARARGIN)
% Choose default command line output for GLW_fieldtrip_dipfit_fitdipole_events
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%inputfiles
inputfiles=get(handles.filebox,'String');
%fill eventbox with all available events
eventstring={};
k=1;
for filepos=1:length(inputfiles);
    %load header
    header=LW_load_header(inputfiles{filepos});
    %store header
    headers(filepos).header=header;
    %get list of events if present
    if isfield(header,'events');
        events=header.events;
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
%store headers
set(handles.eventbox,'UserData',headers);
%sort by alphabetical order
eventstring=sort(eventstring);
set(handles.eventbox,'String',eventstring);
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




% --- Outputs from this function are returned to the command line.
function varargout = GLW_fieldtrip_dipfit_fitdipole_events_OutputFcn(hObject, eventdata, handles) 
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
%inputfiles
inputfiles=get(handles.filebox,'String');
%headers
headers=get(handles.eventbox,'UserData');
%selected event
eventstring=get(handles.eventbox,'String');
selected_event=eventstring{get(handles.eventbox,'Value')};
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** DIPFIT : dit dipoles at event latencies.',1,0);
update_status.function(update_status.handles,['Selected event code : ' selected_event],1,0);
%configuration : numdipoles,symmetry,gridresolution,dipolelabel
gridresolution=str2num(get(handles.gridresedit,'String'));
update_status.function(update_status.handles,['Grid resolution : ' num2str(gridresolution)],1,0);
dipolelabel=get(handles.dipolelabeledit,'String');
update_status.function(update_status.handles,['Dipole label : ' dipolelabel],1,0);
dipolecfg=get(handles.dipolepopup,'Value');
%single, two_x,two_y,two_z,two_unconstrained
if dipolecfg==1;
    numdipoles=1;
    symmetry='no';    
end;
if dipolecfg==2;
    numdipoles=2;
    symmetry='x';    
end;
if dipolecfg==3;
    numdipoles=2;
    symmetry='y';    
end;
if dipolecfg==4;
    numdipoles=2;
    symmetry='z';    
end;
if dipolecfg==5;
    numdipoles=2;
    symmetry='no';    
end;
update_status.function(update_status.handles,['Number of dipoles : ' num2str(numdipoles)],1,0);
update_status.function(update_status.handles,['Symmetry constraint : ' symmetry],1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %load headmodel
    st=[p,filesep,header.fieldtrip_dipfit.hdmfile];
    update_status.function(update_status.handles,['Loading headmodel (vol) : ' st],1,0);
    load(st,'-MAT');
    %return if no events
    ok=1;
    if isfield(header, 'events');
    else
        ok=0;
    end;
    if length(header.events)>0;
    else
        ok=0;
    end;
    if ok==0;
        update_status.function(update_status.handles,'No events found in this datafile. Skipping the file ...',1,0);
    else
        %loop through events
        for eventpos=1:length(header.events);
            if strcmpi(header.events(eventpos).code,selected_event);
                %found event
                update_status.function(update_status.handles,'Event found.',1,0);
                %epochpos
                epochpos=header.events(eventpos).epoch;
                update_status.function(update_status.handles,['Epoch : ' num2str(epochpos)],1,0);
                %indexpos
                indexpos=get(handles.indexbox,'Value');
                update_status.function(update_status.handles,['Index : ' num2str(indexpos)],1,0);
                %dz
                z=str2num(get(handles.zedit,'String'));
                update_status.function(update_status.handles,['Z : ' num2str(z)],1,0);
                dz=round(((z-header.zstart)/header.zstep)+1);
                update_status.function(update_status.handles,['Z position : ' num2str(dz)],1,0);
                %dy
                y=str2num(get(handles.yedit,'String'));
                update_status.function(update_status.handles,['Y : ' num2str(y)],1,0);
                dy=round(((y-header.ystart)/header.ystep)+1);
                update_status.function(update_status.handles,['Y position : ' num2str(dy)],1,0);
                %dx
                x=header.events(eventpos).latency;
                update_status.function(update_status.handles,['X : ' num2str(x)],1,0);
                disp();
                dx=round(((x-header.xstart)/header.xstep)+1);
                update_status.function(update_status.handles,['X position : ' num2str(dx)],1,0);
                update_status.function(update_status.handles,'Computing dipole fit. This may take a while.',1,0);
                header=LW_fieldtrip_dipfit_fitdipole(header,data,vol,epochpos,indexpos,dz,dy,dx,numdipoles,symmetry,gridresolution,dipolelabel);                
            end;
        end;
    end;
    %store header
    headers(filepos).header=header;
end;
%store header
set(handles.eventbox,'UserData',headers);
update_status.function(update_status.handles,'Finished!',0,1);





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




% --- Executes on selection change in dipolepopup.
function dipolepopup_Callback(hObject, eventdata, handles)
% hObject    handle to dipolepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function dipolepopup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dipolepopup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function gridresedit_Callback(hObject, eventdata, handles)
% hObject    handle to gridresedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function gridresedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to gridresedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function dipolelabeledit_Callback(hObject, eventdata, handles)
% hObject    handle to dipolelabeledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function dipolelabeledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dipolelabeledit (see GCBO)
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
%save headers
%headers
headers=get(handles.eventbox,'UserData');
%inputfiles
inputfiles=get(handles.filebox,'String');
%loop through files
for filepos=1:length(inputfiles);
    %save header
    header=headers(filepos).header;
    disp(['Saving : ' inputfiles{filepos}]);
    disp(['Header contains ' num2str(length(header.fieldtrip_dipfit.dipole)) ' dipole solutions']);
    LW_save_header(inputfiles{filepos},[],header);

end;
    
