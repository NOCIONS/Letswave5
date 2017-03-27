function varargout = GLW_exploreinterval(varargin)
% GLW_EXPLOREINTERVAL MATLAB code for GLW_exploreinterval.fig
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
                   'gui_OpeningFcn', @GLW_exploreinterval_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_exploreinterval_OutputFcn, ...
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




% --- Executes just before GLW_exploreinterval is made visible.
function GLW_exploreinterval_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_exploreinterval (see VARARGIN)
% Choose default command line output for GLW_exploreinterval
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.xedit1,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
inputfiles=get(handles.filebox,'String');
%load header of first inputfile
header=LW_load_header(inputfiles{1});
%store header in processbutton.userdata
set(handles.processbutton,'UserData',header);
%set xedits
set(handles.xedit1,'String',num2str(header.xstart,16));
set(handles.xedit2,'String',num2str(header.xstart+((header.datasize(6)-1)*header.xstep),16));
%set yedits
set(handles.yedit1,'String',num2str(header.ystart,16));
set(handles.yedit2,'String',num2str(header.ystart+((header.datasize(5)-1)*header.ystep),16));
%set zedits
set(handles.zedit1,'String',num2str(header.zstart,16));
set(handles.zedit2,'String',num2str(header.zstart+((header.datasize(4)-1)*header.zstep),16));
%dx
tp=str2num(get(handles.xedit1,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.xstart)/header.xstep))+1;
set(handles.dxedit1,'String',num2str(dtp));
tp=str2num(get(handles.xedit2,'String'));
dtp=round(((tp-header.xstart)/header.xstep))+1;
set(handles.dxedit2,'String',num2str(dtp));%dz
tp=str2num(get(handles.yedit1,'String'));
dtp=round(((tp-header.ystart)/header.ystep))+1;
set(handles.dyedit1,'String',num2str(dtp));
tp=str2num(get(handles.yedit2,'String'));
dtp=round(((tp-header.ystart)/header.ystep))+1;
set(handles.dyedit2,'String',num2str(dtp));
%dz
tp=str2num(get(handles.zedit1,'String'));
dtp=round(((tp-header.zstart)/header.zstep))+1;
set(handles.dzedit1,'String',num2str(dtp));
tp=str2num(get(handles.zedit2,'String'));
dtp=round(((tp-header.zstart)/header.zstep))+1;
set(handles.dzedit2,'String',num2str(dtp));

%set visibility
if header.datasize(6)==1;
    set(handles.xpanel,'Visible','off');
    set(handles.xcheck,'Visible','off');
end;
if header.datasize(5)==1;
    set(handles.ypanel,'Visible','off');
    set(handles.ycheck,'Visible','off');
end;
if header.datasize(4)==1;
    set(handles.zpanel,'Visible','off');
    set(handles.zcheck,'Visible','off');
end;





% --- Outputs from this function are returned to the command line.
function varargout = GLW_exploreinterval_OutputFcn(hObject, eventdata, handles) 
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
inputfiles=get(handles.filebox,'String');
update_status=get(handles.xedit1,'UserData');
update_status.function(update_status.handles,'*** Explore interval.',1,0);
%reset linepos
linepos=1;
%top_percent
top_percent=str2num(get(handles.percent_edit,'String'));
%crop
xcrop=get(handles.xcheck,'Value');
ycrop=get(handles.ycheck,'Value');
zcrop=get(handles.zcheck,'Value');
%colheaders
colheaders={'epoch','channel','index','mean','std','min','max','prct25','prct75','median','top%','bot%'};
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %set x1,x2,y1,y2,z1,z2
    x1=str2num(get(handles.xedit1,'String'));
    x2=str2num(get(handles.xedit2,'String'));
    y1=str2num(get(handles.yedit1,'String'));
    y2=str2num(get(handles.yedit2,'String'));
    z1=str2num(get(handles.zedit1,'String'));
    z2=str2num(get(handles.zedit2,'String'));
    %process
    update_status.function(update_status.handles,'Cropping epochs to interval.',1,0);
    update_status.function(update_status.handles,'Extracting interval statistics.',1,0);
    header.datasize(6)
    [header,data]=LW_crop(header,data,xcrop,ycrop,zcrop,x1,x2,y1,y2,z1,z2);
    %loop
    for indexpos=1:header.datasize(3);
        for chanpos=1:header.datasize(2);
            for epochpos=1:header.datasize(1);
                table_data{linepos,1}=epochpos;
                table_data{linepos,2}=header.chanlocs(chanpos).labels;
                table_data{linepos,3}=indexpos;
                tp=data(epochpos,chanpos,indexpos,:,:,:);
                tpx=tp(:);
                table_data{linepos,4}=mean(tpx);
                table_data{linepos,5}=std(tpx);
                table_data{linepos,6}=min(tpx);
                table_data{linepos,7}=max(tpx);
                table_data{linepos,8}=prctile(tpx,25);
                table_data{linepos,9}=prctile(tpx,75);
                table_data{linepos,10}=median(tpx);
                %top%
                tpx=sort(tpx);
                table_data{linepos,11}=mean(tpx(length(tpx)-round(length(tpx)/top_percent)+1:length(tpx)));
                table_data{linepos,12}=mean(tpx(1:round(length(tpx)/top_percent)));
                linepos=linepos+1;
            end;
        end;
    end;
end;
h=figure;
uitable(h,'Data',table_data,'ColumnName',colheaders,'Units','normalized','Position', [0 0 1 1]);
update_status.function(update_status.handles,'Finished!',0,1);




function yedit1_Callback(hObject, eventdata, handles)
% hObject    handle to yedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.yedit1,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.ystart)/header.ystep))+1;
set(handles.dyedit1,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function yedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function yedit2_Callback(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.yedit2,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.ystart)/header.ystep))+1;
set(handles.dyedit2,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function yedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit2_Callback(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.zedit2,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.zstart)/header.zstep))+1;
set(handles.dzedit2,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function zedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function zedit1_Callback(hObject, eventdata, handles)
% hObject    handle to zedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.zedit1,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.zstart)/header.zstep))+1;
set(handles.dzedit1,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function zedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to zedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit1_Callback(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.xedit1,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.xstart)/header.xstep))+1;
set(handles.dxedit1,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function xedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function xedit2_Callback(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
tp=str2num(get(handles.xedit2,'String'));
header=get(handles.processbutton,'UserData');
dtp=round(((tp-header.xstart)/header.xstep))+1;
set(handles.dxedit2,'String',num2str(dtp));



% --- Executes during object creation, after setting all properties.
function xedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in zcheck.
function zcheck_Callback(hObject, eventdata, handles)
% hObject    handle to zcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in ycheck.
function ycheck_Callback(hObject, eventdata, handles)
% hObject    handle to ycheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in xcheck.
function xcheck_Callback(hObject, eventdata, handles)
% hObject    handle to xcheck (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function dxedit1_Callback(hObject, eventdata, handles)
% hObject    handle to dxedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dxedit1,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.xstep)+header.xstart;
set(handles.xedit1,'String',num2str(tp,16));




% --- Executes during object creation, after setting all properties.
function dxedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dxedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dxedit2_Callback(hObject, eventdata, handles)
% hObject    handle to dxedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dxedit2,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.xstep)+header.xstart;
set(handles.xedit2,'String',num2str(tp,16));




% --- Executes during object creation, after setting all properties.
function dxedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dxedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dyedit2_Callback(hObject, eventdata, handles)
% hObject    handle to dyedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dyedit2,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.ystep)+header.ystart;
set(handles.yedit2,'String',num2str(tp,16));




% --- Executes during object creation, after setting all properties.
function dyedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dyedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dyedit1_Callback(hObject, eventdata, handles)
% hObject    handle to dyedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dyedit1,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.ystep)+header.ystart;
set(handles.yedit1,'String',num2str(tp,16));





% --- Executes during object creation, after setting all properties.
function dyedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dyedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function dzedit2_Callback(hObject, eventdata, handles)
% hObject    handle to dzedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dzedit2,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.zstep)+header.zstart;
set(handles.zedit2,'String',num2str(tp,16));





% --- Executes during object creation, after setting all properties.
function dzedit2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dzedit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function dzedit1_Callback(hObject, eventdata, handles)
% hObject    handle to dzedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
dtp=str2num(get(handles.dzedit1,'String'));
header=get(handles.processbutton,'UserData');
tp=((dtp-1)*header.zstep)+header.zstart;
set(handles.zedit1,'String',num2str(tp,16));




% --- Executes during object creation, after setting all properties.
function dzedit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dzedit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
