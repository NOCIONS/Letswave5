function varargout = GLW_fieldtrip_dipfit_plotdipoles(varargin)
% GLW_FIELDTRIP_DIPFIT_PLOTDIPOLES MATLAB code for GLW_fieldtrip_dipfit_plotdipoles.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_fieldtrip_dipfit_plotdipoles_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fieldtrip_dipfit_plotdipoles_OutputFcn, ...
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





% --- Executes just before GLW_fieldtrip_dipfit_plotdipoles is made visible.
function GLW_fieldtrip_dipfit_plotdipoles_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fieldtrip_dipfit_plotdipoles (see VARARGIN)
% Choose default command line output for GLW_fieldtrip_dipfit_plotdipoles
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
%dipoledata
k=1;
for filepos=1:length(inputfiles);
    %load header
    header=LW_load_header(inputfiles{filepos});
    %get list of dipoles if present
    if isfield(header.fieldtrip_dipfit,'dipole');
        %loop through dipoles
        for dipolepos=1:length(header.fieldtrip_dipfit.dipole);
            dipoledata(k).filepos=filepos;
            dipoledata(k).dipolepos=dipolepos;
            dx=header.fieldtrip_dipfit.dipole(dipolepos).dxpos;
            dy=header.fieldtrip_dipfit.dipole(dipolepos).dypos;
            dz=header.fieldtrip_dipfit.dipole(dipolepos).dzpos;
            x=((dx-1)*header.xstep)+header.xstart;
            y=((dy-1)*header.ystep)+header.ystart;
            z=((dz-1)*header.zstep)+header.zstart;
            dipoledata(k).string=[filename ' (' header.fieldtrip_dipfit.dipole(dipolepos).label ' epoch: ' num2str(header.fieldtrip_dipfit.dipole(dipolepos).epochpos) ' [' num2str(header.fieldtrip_dipfit.dipole(dipolepos).indexpos) ',' num2str(x) ',' num2str(y) ',' num2str(z) '])'];
            k=k+1;
        end;
    end;
end;
%fill dipolebox with all available dipoles
dipolestring={};
for i=1:length(dipoledata);
    dipolestring{i}=dipoledata(i).string;
end;
set(handles.dipolebox,'String',dipolestring);
set(handles.dipolebox,'UserData',dipoledata);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_fieldtrip_dipfit_plotdipoles_OutputFcn(hObject, eventdata, handles) 
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
%dipoledata
dipoledata=get(handles.dipolebox,'UserData')
%selected_dipoles
selected_dipoles=get(handles.dipolebox,'Value')
selected_dipoledata=dipoledata(selected_dipoles);
%display_methods
k=1;
if (get(handles.plot_scalpmap_chk,'Value')==1);
    display_methods(k)=1;
    k=k+1;
end;
if (get(handles.plot_3dtop_chk,'Value')==1);
    display_methods(k)=2;
    k=k+1;
end;
if (get(handles.plot_3dleft_chk,'Value')==1);
    display_methods(k)=3;
    k=k+1;
end;
if (get(handles.plot_3dright_chk,'Value')==1);
    display_methods(k)=4;
    k=k+1;
end;
if (get(handles.plot_3dfront_chk,'Value')==1);
    display_methods(k)=5;
    k=k+1;
end;
if (get(handles.plot_3dback_chk,'Value')==1);
    display_methods(k)=6;
    k=k+1;
end;
%volpos
volpos=str2num(get(handles.volposedit,'String'));
%brightness
volcolor=[0.85 0.75 0.75];
%figure
h=figure;
set(h,'Color','w');
%loop through selected_dipoles
for rowpos=1:length(selected_dipoles);
    [header,data]=LW_load(inputfiles{selected_dipoledata(rowpos).filepos});
    %filename
    [p,n,e]=fileparts(inputfiles{selected_dipoledata(rowpos).filepos});
    %vol
    filename=[p filesep header.fieldtrip_dipfit.hdmfile];
    disp(['Loading headmodel : ' filename]);
    load(filename,'-mat');
    %dipolepos
    dipolepos=selected_dipoledata(rowpos).dipolepos;
    disp(['Dipole number : ' num2str(dipolepos)]);
    %loop through display_methods
    for colpos=1:length(display_methods);
        graphpos=colpos+((rowpos-1)*length(display_methods));
        a=subaxis(length(selected_dipoles),length(display_methods),graphpos,'MarginLeft',0.02,'MarginRight',0.02,'MarginTop',0.02,'MarginBottom',0.02,'SpacingHoriz',0.02,'SpacingVert',0.02);
        %subplot(length(selected_dipoles),length(display_methods),graphpos);
        method=display_methods(colpos);
        if method==1; %topoplot
            LW_fieldtrip_dipfit_plotdipole(header,data,dipolepos);
        end;
        if method==2; %3D from above
            viewpoint=[0 90];
            LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
        end;
        if method==3; %3D from left
            viewpoint=[270 0];
            LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
        end;
        if method==4; %3D from right
            viewpoint=[90 0];
            LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
        end;
        if method==5; %3D from back
            viewpoint=[180 0];
            LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
        end;
        if method==6; %3D from back
            viewpoint=[0 0];
            LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
        end;
        
    end;
end;




% --- Executes on selection change in dipolebox.
function dipolebox_Callback(hObject, eventdata, handles)
% hObject    handle to dipolebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function dipolebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dipolebox (see GCBO)
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





% --- Executes on button press in plot_scalpmap_chk.
function plot_scalpmap_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_scalpmap_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in plot_3dtop_chk.
function plot_3dtop_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_3dtop_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in plot_3dleft_chk.
function plot_3dleft_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_3dleft_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in plot_3dright_chk.
function plot_3dright_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_3dright_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in plot_3dfront_chk.
function plot_3dfront_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_3dfront_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in plot_3dback_chk.
function plot_3dback_chk_Callback(hObject, eventdata, handles)
% hObject    handle to plot_3dback_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function volposedit_Callback(hObject, eventdata, handles)
% hObject    handle to volposedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function volposedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to volposedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in processbutton2.
function processbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%inputfiles
inputfiles=get(handles.filebox,'String');
%dipoledata
dipoledata=get(handles.dipolebox,'UserData')
%selected_dipoles
selected_dipoles=get(handles.dipolebox,'Value')
selected_dipoledata=dipoledata(selected_dipoles);
%displaymethod
displaymethod=get(handles.methodbox,'Value');
%volpos
volpos=str2num(get(handles.volposedit,'String'));
%volcolor
volcolor=[0.85 0.75 0.75];
%figure
h=figure;
subaxis(1,1,1,'MarginLeft',0.02,'MarginRight',0.02,'MarginTop',0.02,'MarginBottom',0.02,'SpacingHoriz',0.02,'SpacingVert',0.02);
colormap(bone);
set(h,'Color','w');
%loop through selected_dipoles
for pos=1:length(selected_dipoles);
    [header,data]=LW_load(inputfiles{selected_dipoledata(pos).filepos});
    %filename
    [p,n,e]=fileparts(inputfiles{selected_dipoledata(pos).filepos});
    %vol
    filename=[p filesep header.fieldtrip_dipfit.hdmfile];
    disp(['Loading headmodel : ' filename]);
    load(filename,'-mat');
    %dipolepos
    dipolepos=selected_dipoledata(pos).dipolepos;
    disp(['Dipole number : ' num2str(dipolepos)]);
    if displaymethod==1; %3D from above
        viewpoint=[0 90];
    end;
    if displaymethod==2; %3D from left
        viewpoint=[270 0];
    end;
    if displaymethod==3; %3D from right
        viewpoint=[90 0];
    end;
    if displaymethod==4; %3D from back
        viewpoint=[180 0];
    end;
    if displaymethod==5; %3D from back
        viewpoint=[0 0];
    end;
    if pos==1;
        LW_fieldtrip_dipfit_plotdipole2(header,data,vol,volpos,volcolor,dipolepos,viewpoint);
    else
        LW_fieldtrip_dipfit_plotdipole2b(header,dipolepos);
    end;
end;





