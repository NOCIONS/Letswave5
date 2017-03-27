function varargout = GLW_scalparray_figure(varargin)
% GLW_SCALPARRAY_FIGURE MATLAB code for GLW_scalparray_figure.fig
% Edit the above text to modify the response to help GLW_scalparray_figure
%



% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_scalparray_figure_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_scalparray_figure_OutputFcn, ...
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




% --- Executes just before GLW_scalparray_figure is made visible.
function GLW_scalparray_figure_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_scalparray_figure (see VARARGIN)
% Choose default command line output for GLW_scalparray_figure
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes GLW_scalparray_figure wait for user response (see UIRESUME)
% uiwait(handles.figure1);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_scalparray_figure_OutputFcn(hObject, eventdata, handles) 
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
userdata2=get(mother_handle.chanbox,'UserData');
for i=1:size(userdata2.currentaxis,2);
    currentpoint=get(userdata2.currentaxis(1,i),'CurrentPoint');
    cp(i)=currentpoint(2,1);
end;
xlim=get(userdata2.currentaxis(1,1),'XLim');
xdist=abs(cp(:)-xlim(1))+abs(cp(:)-xlim(2));
[a,b]=min(xdist);
set(handles.xtext,'String',num2str(cp(b)));
