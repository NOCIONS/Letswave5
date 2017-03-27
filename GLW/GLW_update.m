function varargout = GLW_update(varargin)
% GLW_UPDATE MATLAB code for GLW_update.fig
% Last Modified by GUIDE v2.5 11-Jun-2014 10:09:29

%



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_update_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_update_OutputFcn, ...
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





% --- Executes just before GLW_update is made visible.
function GLW_update_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_update (see VARARGIN)
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
set(handles.check_btn,'Userdata',varargin{2});
axis off;






% --- Outputs from this function are returned to the command line.
function varargout = GLW_update_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;






% --- Executes on button press in check_btn.
function check_btn_Callback(hObject, eventdata, handles)
% hObject    handle to check_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_status=get(handles.check_btn,'UserData');
update_status.function(update_status.handles,'*** Checking for updates.',1,0);
[date_localfile date_remotefile]=LW_updatecheck;
update_status.function(update_status.handles,'Finished',0,1);
set(handles.local_txt,'String',['Installed version : ' date_localfile]);
set(handles.current_txt,'String',['Available version : ' date_remotefile]);
set(handles.email_chk,'Value',1);






% --- Executes on button press in forceupdate_btn.
function forceupdate_btn_Callback(hObject, eventdata, handles)
% hObject    handle to forceupdate_btn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_status=get(handles.check_btn,'UserData');
update_status.function(update_status.handles,'*** Letswave is updating.',1,0);
LW_updateforce;
update_status.function(update_status.handles,'Finished updating!',0,1);
update_status.function(update_status.handles,'Sending update statistics.',0,1);
if get(handles.email_chk,'Value')==1;
    date_time=datestr(now);
    address = java.net.InetAddress.getLocalHost;
    IPaddress =  char(address.getHostAddress);
    subject_st='LW5 update';
    body_st=['Letswave5 was updated on ' date_time '. Computer Name : ' getComputerName ' IP : ' IPaddress];
    e_mail('letswave5@gmail.com','gmail','letswave5','gamfi123',subject_st,body_st,[]);
end;
set(handles.email_chk,'Value',1);



% --- Executes on button press in email_chk.
function email_chk_Callback(hObject, eventdata, handles)
% hObject    handle to email_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of email_chk
