function varargout = GLW_fieldtrip_dipfit_assign_hdm(varargin)
% GLW_FIELDTRIP_DIPFIT_ASSIGN_HDM MATLAB code for GLW_fieldtrip_dipfit_assign_hdm.fig
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




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_fieldtrip_dipfit_assign_hdm_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_fieldtrip_dipfit_assign_hdm_OutputFcn, ...
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




% --- Executes just before GLW_fieldtrip_dipfit_assign_hdm is made visible.
function GLW_fieldtrip_dipfit_assign_hdm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_fieldtrip_dipfit_assign_hdm (see VARARGIN)
% Choose default command line output for GLW_fieldtrip_dipfit_assign_hdm
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%figure
hsfigure=figure;
set(handles.SelectAllBtn,'UserData',hsfigure);
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
st=get(handles.filebox,'UserData');
for i=1:length(st);
    [p,n,e]=fileparts(st{i});
    inputfiles{i}=n
end;
set(handles.filebox,'String',inputfiles);
set(handles.filebox,'Value',1);
UpdateChannelbox(handles);





% --- Outputs from this function are returned to the command line.
function varargout = GLW_fieldtrip_dipfit_assign_hdm_OutputFcn(hObject, eventdata, handles) 
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




function UpdateChannelbox(handles);
inputfiles=get(handles.filebox,'UserData');
st=inputfiles{get(handles.filebox,'Value')};
header=LW_load_header(st);
channel_labels={};
j=1;
for chanpos=1:length(header.chanlocs);
    if header.chanlocs(chanpos).fieldtrip_dipfit.enabled==1;
        elec.pnts(j,1)=header.chanlocs(chanpos).fieldtrip_dipfit.X;
        elec.pnts(j,2)=header.chanlocs(chanpos).fieldtrip_dipfit.Y;
        elec.pnts(j,3)=header.chanlocs(chanpos).fieldtrip_dipfit.Z;
        elec.label{j}=header.chanlocs(chanpos).labels;
        channel_labels{j}=header.chanlocs(chanpos).labels;
        j=j+1;
    end;
end;
set(handles.chanbox,'String',channel_labels);
set(handles.chanbox,'UserData',elec);
set(handles.chanbox,'Value',1:1:length(channel_labels));




function PlotHeadmodel(handles);
figure(get(handles.SelectAllBtn,'UserData'));
clf;
hold on;
vol=get(handles.hdmfilename,'UserData');
elec=get(handles.chanbox,'UserData');
if isempty(vol);
else;
    %draw volumes
    hs.hdm(1)=ft_plot_mesh(vol.bnd(1),'facealpha',0.3,'facecolor',[0.9 0.6 0.6],'edgecolor','none');
    hs.hdm(2)=ft_plot_mesh(vol.bnd(2),'facealpha',0.3,'facecolor',[0.3 0.3 0.7],'edgecolor','none');
    hs.hdm(3)=ft_plot_mesh(vol.bnd(3),'facealpha',0.3,'facecolor',[0.3 0.7 0.3],'edgecolor','none');
    %draw electrodes
    if isempty(elec);
    else
        selected=get(handles.chanbox,'Value');
        unselected=1:1:size(elec.pnts,1);
        unselected(selected)=[];
        if length(selected)>0;
            red_elec.pnts=elec.pnts(selected,:);
        else
            red_elec=[];
        end;
        if length(unselected)>0;
            blue_elec.pnts=elec.pnts(unselected,:);
        else
            blue_elec=[];
        end;
        diameter=3;
        s=[];
        [s.x,s.y,s.z]=sphere(20);
        s.x=s.x*diameter;
        s.y=s.y*diameter;
        s.z=s.z*diameter;
        if isempty(red_elec);
        else
            for i=1:size(red_elec.pnts,1);
                hs_electrodes=surf(s.x+red_elec.pnts(i,1),s.y+red_elec.pnts(i,2),s.z+red_elec.pnts(i,3));
                set(hs_electrodes,'FaceColor',[1 0 0],'FaceAlpha',0.5,'edgecolor','none');
            end;
        end;
        if isempty(blue_elec);
        else
            for i=1:size(blue_elec.pnts,1);
                hs_electrodes=surf(s.x+blue_elec.pnts(i,1),s.y+blue_elec.pnts(i,2),s.z+blue_elec.pnts(i,3));
                set(hs_electrodes,'FaceColor',[0 0 1],'FaceAlpha',0.5,'edgecolor','none');
            end;
        end;
    end;
end;
hold off;
camlight;
lighting GOURAUD



% --- Executes on selection change in filebox.
function filebox_Callback(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
UpdateChannelbox(handles);
PlotHeadmodel(handles);





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
inputfiles=get(handles.filebox,'UserData');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** DIPFIT : assign HDM.',1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    header=LW_load_header(inputfiles{filepos});
    %save headmodel
    [p2,n2,e2]=fileparts(get(handles.hdmfilename,'String'));
    st_hdm=[p filesep n2 '.mat'];
    update_status.function(update_status.handles,['Saving headmodel : ' st_hdm],1,0);
    vol=get(handles.hdmfilename,'UserData');
    save(st_hdm,'vol');
    %update header
    update_status.function(update_status.handles,['Assigning headmodel : ' n2 '.mat'],1,0);
    header=LW_fieldtrip_dipfit_assign_hdm(header,[n2 '.mat']);
    LW_save_header(inputfiles{filepos},[],header);
end;
update_status.function(update_status.handles,'Finished!',0,1);





% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
filterspec={'*.mat; *.MAT'};
[filename,pathname]=uigetfile(filterspec);
filename=fullfile(pathname,filename);
set(handles.hdmfilename,'String',filename);
load(filename);
if exist('vol');
    set(handles.hdmfilename,'UserData',vol);
    PlotHeadmodel(handles);
else
    msgbox('No volume found in selected MAT file');
end;




% --- Executes on selection change in chanbox.
function chanbox_Callback(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
PlotHeadmodel(handles);





% --- Executes during object creation, after setting all properties.
function chanbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chanbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in SelectAllBtn.
function SelectAllBtn_Callback(hObject, eventdata, handles)
% hObject    handle to SelectAllBtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.chanbox,'String');
set(handles.chanbox,'Value',1:1:length(st));





% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.chanbox,'Value',[]);
