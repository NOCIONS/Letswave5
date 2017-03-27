function varargout = GLW_fieldtrip_dipfit_fitdipole_ics(varargin)
% GLW_FIELDTRIP_DIPFIT_FITDIPOLE_ICS MATLAB code for GLW_fieldtrip_dipfit_fitdipole_ics.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_fieldtrip_dipfit_fitdipole_ics_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fieldtrip_dipfit_fitdipole_ics_OutputFcn, ...
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





% --- Executes just before GLW_fieldtrip_dipfit_fitdipole_ics is made visible.
function GLW_fieldtrip_dipfit_fitdipole_ics_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fieldtrip_dipfit_fitdipole_ics (see VARARGIN)
% Choose default command line output for GLW_fieldtrip_dipfit_fitdipole_ics
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});





% --- Outputs from this function are returned to the command line.
function varargout = GLW_fieldtrip_dipfit_fitdipole_ics_OutputFcn(hObject, eventdata, handles) 
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
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** DIPFIT : fit fipoles onto ICs.',1,0);
inputfiles=get(handles.filebox,'String');
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
update_status.function(update_status.handles,'Starting dipole fit.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{filepos});
    %load headmodel
    st=[p,filesep,header.fieldtrip_dipfit.hdmfile];
    update_status.function(update_status.handles,['Loading headmodel (vol) : ' st],1,0);
    load(st,'-MAT');
    %loop through ICs
    for icpos=1:header.datasize(6);
        %epochpos
        epochpos=1;
        %indexpos
        indexpos=2;
        %dz
        dz=1;
        %dy
        dy=1;
        %dx
        dx=icpos;
        update_status.function(update_status.handles,['IC : ' num2str(dx)],1,0);
        header=LW_fieldtrip_dipfit_fitdipole(header,data,vol,epochpos,indexpos,dz,dy,dx,numdipoles,symmetry,gridresolution,dipolelabel);
    end;
    %save header
    update_status.function(update_status.handles,['Total : ' num2str(length(header.fieldtrip_dipfit.dipole)) ' dipole solutions'],1,0);
    LW_save_header(inputfiles{filepos},[],header);
end;
update_status.function(update_status.handles,'Finished!',0,1);




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
