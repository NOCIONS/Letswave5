function varargout = GLW_XYZnorm(varargin)
% GLW_XYZNORM M-file for GLW_XYZnorm.fig
%      GLW_XYZNORM, by itself, creates a new GLW_XYZNORM or raises the existing
%      singleton*.
%
%      H = GLW_XYZNORM returns the handle to a new GLW_XYZNORM or the handle to
%      the existing singleton*.
%
%      GLW_XYZNORM('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLW_XYZNORM.M with the given input arguments.
%
%      GLW_XYZNORM('Property','Value',...) creates a new GLW_XYZNORM or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GLW_XYZnorm_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GLW_XYZnorm_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GLW_XYZnorm

% Last Modified by GUIDE v2.5 14-Apr-2014 10:18:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GLW_XYZnorm_OpeningFcn, ...
    'gui_OutputFcn',  @GLW_XYZnorm_OutputFcn, ...
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


% --- Executes just before GLW_XYZnorm is made visible.
function GLW_XYZnorm_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_XYZnorm (see VARARGIN)

% Choose default command line output for GLW_XYZnorm
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%fill listbox with inputfiles
inputfiles=varargin{2};
set(handles.filebox,'String',inputfiles);

%fill channel_box with channel labels
inputfiles=get(handles.filebox,'String');
header=LW_load_header(inputfiles{1});
for i=1:header.datasize(2);
    channel_string{i}=header.chanlocs(i).labels;
end;
set(handles.channel_box,'String',channel_string);





% --- Outputs from this function are returned to the command line.
function varargout = GLW_XYZnorm_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;




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




% --- Executes on button press in process_btn.
function process_btn_Callback(hObject, eventdata, handles)
% hObject    handle to process_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
%process
disp('*** NormXYZ');
%channels
chan_idx=get(handles.channel_box,'Value');
chan_idx
%loop through files
for filepos=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{filepos});
    tpdata=data(:,chan_idx,:,:,:,:);
    tpdata=sqrt((data(:,chan_idx(1),:,:,:,:).^2)+(data(:,chan_idx(2),:,:,:,:).^2)+(data(:,chan_idx(3),:,:,:,:).^2));
    data(:,header.datasize(2)+1,:,:,:,:)=tpdata;
    header.chanlocs(header.datasize(2)+1)=header.chanlocs(chan_idx(1));
    header.chanlocs(header.datasize(2)+1).labels=get(handles.channelname_edit,'String');
    header.datasize=size(data);
    LW_save(inputfiles{filepos},get(handles.prefix_edit,'String'),header,data);
end;
    

disp('**finished');
    
    
    
    
    
    
    
    
    
    
    
    
    
 


% --- Executes on selection change in channel_box.
function channel_box_Callback(hObject, eventdata, handles)
% hObject    handle to channel_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function channel_box_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channel_box (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function channelname_edit_Callback(hObject, eventdata, handles)
% hObject    handle to channelname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function channelname_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelname_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function prefix_edit_Callback(hObject, eventdata, handles)
% hObject    handle to prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of prefix_edit as text
%        str2double(get(hObject,'String')) returns contents of prefix_edit as a double


% --- Executes during object creation, after setting all properties.
function prefix_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefix_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
