function varargout = GLW_findpeaks_waves_figure(varargin)
% GLW_FINDPEAKS_WAVES_FIGURE MATLAB code for GLW_findpeaks_waves_figure.fig
% Edit the above text to modify the response to help GLW_findpeaks_waves_figure
%



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_findpeaks_waves_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_findpeaks_waves_figure_OutputFcn, ...
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




% --- Executes just before GLW_findpeaks_waves_figure is made visible.
function GLW_findpeaks_waves_figure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_findpeaks_waves_figure (see VARARGIN)
% Choose default command line output for GLW_findpeaks_waves_figure
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_findpeaks_waves_figure wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_findpeaks_waves_figure_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;
varargout{2} = handles;




% --- Executes on mouse motion over figure - except title and menu.
function figure1_WindowButtonMotionFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mother_handle=get(handles.xtext,'UserData');
if isempty(mother_handle);
else
    epochfigure=get(mother_handle.findbutton,'UserData');
    currentpoint=get(epochfigure.axis,'CurrentPoint');
    set(handles.xtext,'String',[num2str(currentpoint(2,1)) '   ' num2str(currentpoint(1,2))]);
end;



% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mother_handle=get(handles.xtext,'UserData');
epochfigure=get(mother_handle.findbutton,'UserData');
currentpoint=get(epochfigure.axis,'CurrentPoint');
cursor1=currentpoint(2,1);
set(handles.xtext1,'String',num2str(cursor1));
GLW_findpeaks_waves('drawepoch',mother_handle);
%draw cursor
figure(epochfigure.figure);
ylim=get(gca,'YLim');
hold on;
plot([cursor1 cursor1],ylim,'k:');
hold off;




% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
mother_handle=get(handles.xtext,'UserData');
epochfigure=get(mother_handle.findbutton,'UserData');
currentpoint=get(epochfigure.axis,'CurrentPoint');
cursor2=currentpoint(2,1);
set(handles.xtext2,'String',num2str(cursor2));
%draw cursor
figure(epochfigure.figure);
ylim=get(gca,'YLim');
hold on;
plot([cursor2 cursor2],ylim,'k:');
hold off;
%find maximum within range
cursor1=str2num(get(handles.xtext1,'String'));
[a,dx1]=min(abs(epochfigure.tpx-cursor1));
[a,dx2]=min(abs(epochfigure.tpx-cursor2));
%method
method=get(mother_handle.methodbox,'Value');
%find peak
if method==1;
    [a,b]=max(epochfigure.tpy(dx1:dx2));
end;
if method==2;
    [a,b]=min(epochfigure.tpy(dx1:dx2));
end;
if method==3;
    [a,b]=max(abs(epochfigure.tpy(dx1:dx2)));
end;
if method==4;
    [a,b]=min(abs(epochfigure.tpy(dx1:dx2)));
end;
dxpeak=b+dx1-1;
xpeak=epochfigure.tpx(dxpeak);
%update peakbox in mother_handle
peakstring=get(mother_handle.peakbox,'String');
peakpos=get(mother_handle.peakbox,'Value');
peakstring{peakpos}=num2str(xpeak);
set(mother_handle.peakbox,'String',peakstring);
%plot peak
hold on;
plot([xpeak xpeak],ylim,'k--');
hold off;
