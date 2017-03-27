function varargout = letswave_gui(varargin)
% LETSWAVE_GUI MATLAB code for letswave_gui.fig
%      H = LETSWAVE_GUI returns the handle to a new LETSWAVE_GUI or the handle to
%      the existing singleton*.
%
% Author : 
% Andre Mouraux
% Institute of Neurosciences (IONS)
% University of Louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of letswave_gui 5
% See http://nocions.webnode.com/letswave_gui for additional information



% Begin initialization code - DO NOT EDIT
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @letswave_gui_OpeningFcn, ...
                   'gui_OutputFcn',  @letswave_gui_OutputFcn, ...
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





% --- Executes just before letswave_gui is made visible.
function letswave_gui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to letswave_gui (see VARARGIN)
% Choose default command line output for letswave_gui
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes letswave_gui wait for user response (see UIRESUME)
% uiwait(handles.figure);
axis off;
%set path
set(handles.pathedit,'String',pwd);
[p,n,e]=fileparts(mfilename('fullpath'));
addpath([p filesep 'LW']);
addpath([p filesep 'GLW']);
addpath([p filesep 'external']);
addpath([p filesep 'external' filesep 'fieldtrip']);
addpath([p filesep 'external' filesep 'eeglab']);
addpath([p filesep 'external' filesep 'anteepimport1.09']);
addpath([p filesep 'external' filesep 'singletrial toolbox']);
addpath([p filesep 'external' filesep 'CSD toolbox']);
addpath([p filesep 'external' filesep 'pica']);
addpath([p filesep 'external' filesep 'visualisationmodule']);
addpath([p filesep 'external' filesep 'csd_maker']);
addpath([p filesep 'external' filesep 'neurone']);
addpath([p filesep 'plugins']);
addpath([p filesep 'override']);
%update
    set(handles.filterbox,'Value',[]);
update(handles);
%plugins
find_plugins(handles,p);





% --- Outputs from this function are returned to the command line.
function varargout = letswave_gui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;



%%%%%%%%%%%
%update functin for external calls
%%%%%%%%%%
function update_status(handles,text_string,status,filebox_update);
%update letswave_gui logtext
if isempty(text);
else
    st=get(handles.logtext,'String');
    st{length(st)+1}=text_string;
    set(handles.logtext,'String',st);
    set(handles.logtext,'Value',length(st));
end;
%update letswave_gui logtext
% 0=ready
% 1=busy
if status==0;
    set(handles.statustext,'String','Ready');
    set(handles.statustext,'ForegroundColor',[0 0.5 0]);
else
    set(handles.statustext,'String','Busy');
    set(handles.statustext,'ForegroundColor',[1 0 0]);
end;
%if filebox_update
if filebox_update==1;
    update(handles);
end;
drawnow expose;


function result=send_update_status(handles);
result.function=@update_status;
result.handles=handles;

% --- Executes on selection change in filebox.
function filebox_Callback(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.figure,'SelectionType');
inputfiles=getfiles(handles);
try
    load(inputfiles{1},'-MAT');
    info_string=['E:' num2str(header.datasize(1)) ' C:' num2str(header.datasize(2)) ' X:' num2str(header.datasize(6)) ' Y:' num2str(header.datasize(5)) ' Z:' num2str(header.datasize(4)) ' I:' num2str(header.datasize(3))];
    set(handles.info_text,'String',info_string);
    if strcmpi(st,'open');
        cb='test';
        %if YSize=1
        if header.datasize(5)==1;
            GLW_simpleview(cb,inputfiles{1},handles);
        end;
        if header.datasize(5)>1;
            GLW_simplemap(cb,inputfiles{1},handles);
        end;
    end;
end;




% --- Executes during object creation, after setting all properties.
function filebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in refreshbutton.
function refreshbutton_Callback(hObject, eventdata, handles)
% hObject    handle to refreshbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update(handles);





function find_plugins(handles,p);
%search for plugins
disp(['Searching for plugins in : ' p filesep 'plugins']);
tp=dir([p filesep 'plugins' filesep '*.plugin']);
if length(tp)>0;
   disp('Some plugins were found');
   plugOrder = 1:length(tp);
   %1.load the pluggins once to get the description names to allow
   %sortting the pluggins based on description (it makes it easier to
   %navigate through pluggins when there are a bunch of them.
   pluginDescription={};
   for i=1:length(tp);
       load([p filesep 'plugins' filesep tp(plugOrder(i)).name],'-mat');
       pluginDescription{i} = plugin_data.string;
   end
   %sort pluggins description disregarding capitalized first letter
   [dumy plugOrder] = sort(lower(pluginDescription));

  %2. load pluggins in the order specified by pluggin description.
   st={};
   for i=1:length(tp);
       load([p filesep 'plugins' filesep tp(plugOrder(i)).name],'-mat');
       disp(['Found : ' plugin_data.string]);
fh=uimenu(handles.mb_plugin,'Label',plugin_data.string,'Callback',{@plugin_callback,i},'UserData',plugin_data.function);
       st{i}=plugin_data.function;
   end;
   set(handles.mb_plugin,'UserData',st);
end;
%%%%%%%%%%%%


%plugin function
function plugin_callback(src,evt,plugin_index);
handles=guidata(src);
try
   inputfiles=getfiles(handles);
catch
   inputfiles={};
end
disp(inputfiles);
cb='test';
st=get(handles.mb_plugin,'UserData');
eval_st=[st{plugin_index} '(cb,inputfiles)']
eval(eval_st);



%refresh input listboxes
function update(handles);
set(handles.filebox,'Value',1);
st=get(handles.pathedit,'String');
%set text string to dir
set(handles.text,'String',st);
%set work dir to dir
cd(st); 
clear d;
d=dir(st);
%update dirlist and filelist
j=1;
k=1;
filelist=[];
dirlist=[];
for i=1:length(d);
    if d(i).isdir==1;
        dirlist{j}=d(i).name;
        j=j+1;
    end;
    if d(i).isdir==0;
        st=d(i).name;
        [path,name,ext]=fileparts(d(i).name);
        if strcmpi(ext,'.lw5')==1;
           filelist{k}=name;
           k=k+1;
        end,
    end;
end;
filterstring=findfilters(filelist);
updatefilterbox(handles,filterstring);
if get(handles.filterchk,'Value')==1;
    filelist=filterfilelist(handles,filelist);
end;
set(handles.filebox,'String',filelist);
set(handles.info_text,'String','');




%find filters
function filterstring=findfilters(filelist);
filterstring={};
sp=' ';
for i=1:length(filelist);
    st=textscan(filelist{i},'%s');
    st=st{1};
    for j=1:length(st);
        filterstring{end+1}=st{j};
    end;
end;
filterstring=unique(filterstring);
filterstring=sort(filterstring);





%update filterbox
function updatefilterbox(handles,filterstring);
cstring=get(handles.filterbox,'String');
cvalues=get(handles.filterbox,'Value');
set(handles.filterbox,'String',filterstring);
ns=[];
if isempty(cvalues);
else
    if isempty(filterstring);
    else
        selected_filters=cstring(cvalues);
        for i=1:length(filterstring);
            for j=1:length(selected_filters);
                if strcmpi(filterstring{i},selected_filters{j});
                    ns=[ns i];
                end;
            end;
        end;
    end;
end;
set(handles.filterbox,'Value',ns);



%
function outputlist=filterfilelist(handles,filelist);
tp=get(handles.filterbox,'Value');
st=get(handles.filterbox,'String');
filterstring=st(tp);
all_idx=1:1:length(filelist);
for i=1:length(filterstring);
    idx=[];
    for j=1:length(filelist);
        a=strfind(filelist{j},filterstring{i});
        if isempty(a);
        else
            idx=[idx j];
        end;
    end;
    all_idx=intersect(all_idx,idx);
end;
outputlist=filelist(all_idx);
    




%parse and analyse selection of datafiles
function [inputfiles]=getfiles(handles);
inputfiles=get(handles.filebox,'String');
inputfiles=inputfiles(get(handles.filebox,'Value'));
%get path
p=get(handles.pathedit,'String');
if p(length(p))==filesep;
else
    p(length(p)+1)=filesep;
end;
%add path and extension to inputfiles
for i=1:length(inputfiles);
    inputfiles{i}=[p,inputfiles{i},'.lw5'];
end;

    


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=getfiles(handles);
set(handles.debugbox,'String',st);





% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update(handles);




% --- Executes during object creation, after setting all properties.
function pathedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pathedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called





% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
p=get(handles.pathedit,'String');
cb='test';
GLW_searchtags(cb,p,handles);







% --- Executes on selection change in filterbox.
function filterbox_Callback(hObject, eventdata, handles)
% hObject    handle to filterbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isempty(get(handles.filterbox,'Value'));
else
    set(handles.filterchk,'Value',1);
    update(handles);
end;




% --- Executes during object creation, after setting all properties.
function filterbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filterbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in filterchk.
function filterchk_Callback(hObject, eventdata, handles)
% hObject    handle to filterchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update(handles);




function pathedit_Callback(hObject, eventdata, handles)
st=get(handles.pathedit,'String');
if exist(st)==7;
    set(handles.pathedit,'String',st);
    update(handles);
end;



function logtext_Callback(hObject, eventdata, handles)




function logtext_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function pathbutton_Callback(hObject, eventdata, handles)
st=get(handles.pathedit,'String');
st=uigetdir(st);
if st==0;
else
    if exist(st)==7;
        set(handles.pathedit,'String',st);
        set(handles.filterchk,'Value',0);
        set(handles.filterbox,'Value',[]);
        update(handles);
    end;
end;





% --- Executes on button press in sendworkspacebtn.
function sendworkspacebtn_Callback(hObject, eventdata, handles)
% hObject    handle to sendworkspacebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=getfiles(handles);
if length(inputfiles)>1;
    disp('!!! Cannot send more than one datafile to the workspace');
else
    %load header
    disp(['Loading header : ' inputfiles{1}]);
    load(inputfiles{1},'-mat');
    %load data
    [p,n,e]=fileparts(inputfiles{1});
    st=[p filesep n '.mat'];
    disp(['Load data : ' st]);
    load(st,'-mat');
    lwdata.data=data;
    lwdata.header=header;
    disp('Sending to workspace : lwdata');
    assignin('base','lwdata',lwdata);
end;






% --- Executes on button press in readworkspacebtn.
function readworkspacebtn_Callback(hObject, eventdata, handles)
% hObject    handle to readworkspacebtn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=getfiles(handles);
if length(inputfiles)>1;
    disp('!!! No more than one file can be selected');
else
    try
        lwdata=evalin('base','lwdata');
    catch
        disp('lwdata variable not found,in workspace');
        return;
    end;
    if isfield(lwdata,'header');
        if isfield(lwdata,'data');
            t=questdlg('Are you sure?');
            if strcmpi(t,'Yes');
                header=lwdata.header;
                data=lwdata.data;
                disp(['saving header : ' inputfiles{1}]);
                save(inputfiles{1},'header','-mat');
                [p,n,e]=fileparts(inputfiles{1});
                st=[p filesep n '.mat'];
                disp(['saving data : ' st]);
                save(st,'data','-mat');
                disp('*** Done!');
            else
                disp('Operation cancelled.');
            end;
        else;
            disp('!!! Data field not found');
            return,
        end;
    else
        disp('!!! Header field not found');
        return;
    end;
end;

% --- Executes on button press in copyfiles_button.
function copyfiles_button_Callback(hObject, eventdata, handles)
% hObject    handle to copyfiles_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=getfiles(handles);
if length(inputfiles)>0;
    st=get(handles.pathedit,'String');
    [FILENAME, PATHNAME, FILTERINDEX]=uiputfile('selected_datasets',st);
    [outpath,n,e]=fileparts(PATHNAME);
    for i=1:length(inputfiles);
        %inheader
        stin=inputfiles{i};
        %outheader
        [p,n,e]=fileparts(inputfiles{i});
        stout=[outpath filesep n e];
        disp([stin ' > ' stout]);
        copyfile(stin,stout,'f');
        %indata
        stin=[p filesep n '.mat'];
        stout=[outpath filesep n '.mat'];
        disp([stin ' > ' stout]);
        copyfile(stin,stout,'f');
    end;
    set(handles.pathedit,'String',outpath);
    update(handles);
end;


% --- Executes on button press in movefiles_button.
function movefiles_button_Callback(hObject, eventdata, handles)
% hObject    handle to movefiles_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=getfiles(handles);
if length(inputfiles)>0;
    st=get(handles.pathedit,'String');
    [FILENAME, PATHNAME, FILTERINDEX]=uiputfile('selected_datasets',st);
    [outpath,n,e]=fileparts(PATHNAME);
    for i=1:length(inputfiles);
        %inheader
        stin=inputfiles{i};
        %outheader
        [p,n,e]=fileparts(inputfiles{i});
        stout=[outpath filesep n e];
        disp([stin ' > ' stout]);
        movefile(stin,stout,'f');
        %indata
        stin=[p filesep n '.mat'];
        stout=[outpath filesep n '.mat'];
        disp([stin ' > ' stout]);
        movefile(stin,stout,'f');
    end;
    set(handles.pathedit,'String',outpath);
    update(handles);
end;




%$$$$$$$$$$$$$$$$$$$$
%BEGIN MENU FUNCTIONS
%$$$$$$$$$$$$$$$$$$$$

% --------------------------------------------------------------------
function Untitled_36_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_37_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_44_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_49_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_54_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_55_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_58_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_edit_chanlabels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if SameChannels==0
    msgbox('This function requires identical Channels across datafiles');
else
    cb='test';
    GLW_editchanlabels(cb,inputfiles,send_update_status(handles));
end,



% --------------------------------------------------------------------
function proc_assignlocations_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if SameChannels==0
    msgbox('This function requires identical Channels across datafiles');
else
    cb='test';
    GLW_lookupchannels(cb,inputfiles,send_update_status(handles));
end,



% --------------------------------------------------------------------
function proc_buildsplinefile_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_buildsplinefile(cb,inputfiles,send_update_status(handles));




% --------------------------------------------------------------------
function proc_assignsplinefile_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if SameChannels==0
    msgbox('This function requires identical Channels across datafiles');
else
    cb='test';
    GLW_assignsplinefile(cb,inputfiles,send_update_status(handles));
end,




% --------------------------------------------------------------------
function proc_properties_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_properties(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_history_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_browse_history(cb,inputfiles,send_update_status(handles));




% --------------------------------------------------------------------
function Untitled_47_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_copyfiles_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_copyfiles(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_renamefile_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_renamefiles(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_movefiles_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_deletefiles_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_deletefiles(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_deletefolder_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_createfolder_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_baseline_correction_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if SameX==0
    msgbox('This function requires identical X dimensions across datafiles');
else
    cb='test';
    GLW_baselinesubtract(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function Untitled_60_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_61_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_FFTfilter_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_FFTfilter(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_butternotch_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_butternotch(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function Untitled_62_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_CWT_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_CWT(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function Untitled_65_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_67_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_average_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_averageepochs(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function Untitled_66_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_68_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_averagechannels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if SameChannels==0
    msgbox('This function requires identical Channels across datafiles');
else
    cb='test';
    GLW_averagechannels(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function proc_FFT_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_FFT(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_ifft_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_iFFT(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function Untitled_69_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_downsample_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX*SameY*SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
else
    cb='test';
    GLW_downsample(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function Untitled_70_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_selectepochs_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical number of epochs across datafiles');
else
    cb='test';
    GLW_selectepochs(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function proc_selectchannels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_selectchannels(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function proc_selectindexes_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameIndex==0)
    msgbox('This function requires identical indexes across datafiles');
else
    cb='test';
    GLW_selectindexes(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function Untitled_71_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_72_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_stFFT_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_stFFT(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_artifacts_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_ARamplitude_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical X dimensions across datafiles');
else
    cb='test';
    GLW_ARamplitude(cb,inputfiles,send_update_status(handles));
end;



% --------------------------------------------------------------------
function Untitled_74_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_importVHDR_Callback(hObject, eventdata, handles)
cb='test';
GLW_importVHDR(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_importCNT_Callback(hObject, eventdata, handles)
cb='test';
GLW_importCNT(cb,send_update_status(handles));

% --------------------------------------------------------------------
function proc_importBDF_Callback(hObject, eventdata, handles)
cb='test';
GLW_importBDF(cb,send_update_status(handles));

% --------------------------------------------------------------------
function proc_importTRC_Callback(hObject, eventdata, handles)
cb='test';
GLW_importTRC(cb,send_update_status(handles));


% --------------------------------------------------------------------
function Untitled_78_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_import_ASCII_multiple_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_import_ASCII_Callback(hObject, eventdata, handles)
cb='test';
GLW_importASCII(cb,send_update_status(handles));

% --------------------------------------------------------------------
function Untitled_82_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_ica_runica_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ica_runica(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function proc_segmentevent_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_segmentation(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_butterlow_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_butterlow(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function proc_butterhigh_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_butterhigh(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_butterband_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_butterband(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_SNR_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical X dimensions across datafiles');
else
    cb='test';
    GLW_SNR(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_crop_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
cb='test';
GLW_crop(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_interpolate_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
cb='test';
GLW_interpolate(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_chunk_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
cb='test';
GLW_chunk(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function figures_tab_Callback(hObject, eventdata, handles)




% --------------------------------------------------------------------
function proc_ttest_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
cb='test';
GLW_ttest(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function Untitled_85_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_86_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_ANOVA_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameChannels==0)
    msgbox('This function requires identical epochs dimensions across datafiles');
    return;
end;
if (SameIndex==0)
    msgbox('This function requires identical index dimensions across datafiles');
    return;
end;
cb='test';
GLW_ANOVA_withpermutation(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_wilcoxon_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameY==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
if (SameZ==0)
    msgbox('This function requires identical XYZ dimensions across datafiles');
    return;
end;
cb='test';
GLW_wilcoxon(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_rereference_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_rereference(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_ica_jader_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ica_jader(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_ica_filter_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_ica_filter(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_ica_assignfile_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_ica_assignfile(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_ica_unmix_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ica_unmix(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_ica_remix_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ica_remix(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_multiview_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        cb='test';
        GLW_multiview(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function proc_mapmultiviewer_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_peakviewer_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_segmentation_alt_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_segmentation_mult(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_merge_epochs_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameX==0);
        msgbox('This function requires identical X dimensions across datafiles');
    else
        if (SameY==0);
            msgbox('This function requires identical Y dimensions across datafiles');
        else
            if (SameZ==0);
                msgbox('This function requires identical Z dimensions across datafiles');
            else
                if (SameIndex==0);
                    msgbox('This function requires identical index dimensions across datafiles');
                else     
                    cb='test';
                    GLW_merge_epochs(cb,inputfiles,send_update_status(handles));
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_merge_channels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    if (SameX==0);
        msgbox('This function requires identical X dimensions across datafiles');
    else
        if (SameY==0);
            msgbox('This function requires identical Y dimensions across datafiles');
        else
            if (SameZ==0);
                msgbox('This function requires identical Z dimensions across datafiles');
            else
                if (SameIndex==0);
                    msgbox('This function requires identical index dimensions across datafiles');
                else     
                    cb='test';
                    GLW_merge_channels(cb,inputfiles,send_update_status(handles));
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_merge_indexes_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameIndex==0)
    msgbox('This function requires identical indexes across datafiles');
else
    if (SameX==0);
        msgbox('This function requires identical X dimensions across datafiles');
    else
        if (SameY==0);
            msgbox('This function requires identical Y dimensions across datafiles');
        else
            if (SameZ==0);
                msgbox('This function requires identical Z dimensions across datafiles');
            else
                if (SameIndex==0);
                    msgbox('This function requires identical index dimensions across datafiles');
                else     
                    cb='test';
                    GLW_merge_indexes(cb,inputfiles,send_update_status(handles));
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_duplicate_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_delete_duplicate_events(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_check_matrixfiles_Callback(hObject, eventdata, handles)
inputpath=get(handles.pathedit,'String');
cb='test';
GLW_check_matrixfiles(cb,inputpath,handles);


% --------------------------------------------------------------------
function Untitled_92_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_check_splinefiles_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function Untitled_93_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_94_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_applywaveletfilter_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_applywaveletfilter(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_edit_conditions_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    cb='test';
    GLW_editconditions(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function Untitled_96_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc__SCD_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_SCD(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_conditions_triggers_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_98_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_add_tags_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_addtag(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_edit_tags_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_edittag(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_scalparray_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        if (SameX==0);
            msgbox('This function requires identical X dimensions across datafiles');
        else
            cb='test';
            GLW_scalparray(cb,inputfiles,send_update_status(handles));
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_conditionsviewer_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    cb='test';
    GLW_conditionsviewer(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_buildwaveletfilter_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_buildwaveletfilter(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_MLR_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_MLR(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function Untitled_101_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_102_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_lookupchannels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_lookupchannels(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_assign_hdm_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_assign_hdm(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_assign_mri_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_assign_mri(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_importLW4MAT_Callback(hObject, eventdata, handles)
cb='test';
GLW_importLW4MAT(cb,send_update_status(handles));



% --------------------------------------------------------------------
function proc_importEEGLAB_Callback(hObject, eventdata, handles)
cb='test';
GLW_importSET(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_importSGR_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_103_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_106_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_export_ASCII_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_export_EEGLAB_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function prox_export_LW4MAT_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_exportMATfile_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_export_MATfile(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_exportMATvar_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_export_MATvar(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_import_MAT_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_import_MATvar_Callback(hObject, eventdata, handles)
cb='test';
GLW_importMATvar(cb,send_update_status(handles));


% --------------------------------------------------------------------
function Untitled_112_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_edit_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
if length(inputfiles)>1;
    disp('*** More than one file selected. Only showing events of the first selected file!');
end;
GLW_eventsviewer(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function Untitled_114_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_check_MRI_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_116_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_generate_methods_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_segmentation_chunks_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameX==0)
    msgbox('This function requires identical X dimensions across datafiles');
else
    cb='test';
    GLW_chunkepochs(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_interpolatechannels_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_interpolate_channels(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function Untitled_118_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_math_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    if (SameChannels==0)
        msgbox('This function requires identical channels across datafiles');
    else
        if (SameIndex==0)
            msgbox('This function requires identical indexes across datafiles');
        else
            if (SameX==0)
                msgbox('This function requires identical X across datafiles');
            else
                if (SameY==0)
                    msgbox('This function requires identical Y across datafiles');
                else
                    if (SameZ==0)
                        msgbox('This function requires identical Z across datafiles');
                    else
                        GLW_math(cb,inputfiles,send_update_status(handles));
                    end;
                end;
            end;
        end;
    end;
end;

% --------------------------------------------------------------------
function proc_math_constant_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_math_constant(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function proc_square_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_square(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function Untitled_122_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_123_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_cross_correlation_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_MLRd_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_MLRd(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_figure_wavefigure_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_figure_waves(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function proc_mapseries_figure_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_figure_mapseries(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_peakfigure_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_phasefigure_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_conditionsfigure_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_findpeaks_waves_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_findpeaks_waves(cb,inputfiles,send_update_status(handles));
end;

% --------------------------------------------------------------------
function proc_findpeaks_maps_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_findpeaks_maps(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function Untitled_132_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_133_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_bootstrap_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameX==0)
        msgbox('This function requires identical X dimension across datafiles');
    else
        cb='test';
        GLW_bootstrap(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function proc_dipfit_fitdipole_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameY==0)
    msgbox('This function requires identical Y dimensions across datafiles');
else
    if (SameZ==0)
        msgbox('This function requires identical Z dimensions across datafiles');
    else
        if (SameIndex==0);
            msgbox('This function requires identical indexes across datafiles');
        else
            GLW_fieldtrip_dipfit_fitdipole_events(cb,inputfiles,send_update_status(handles));
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_plotdipoles_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_plotdipoles(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_selectepochs_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    GLW_selectepochs_events(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_selectepochs_events2_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_selectepochs_events2(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_zscore_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_zscore(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_dipfit_fitdipole_ics_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_fitdipole_ics(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_editdipoles_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_editdipoles(cb,inputfiles,send_update_status(handles));

% --------------------------------------------------------------------
function proc_fieldtrip_dipfit_deletedipoles_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_deletedipoles(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_varexplained_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    if (SameChannels==0)
        msgbox('This function requires identical channels across datafiles');
    else
        if (SameIndex==0)
            msgbox('This function requires identical indexes across datafiles');
        else
            if (SameX==0)
                msgbox('This function requires identical X across datafiles');
            else
                if (SameY==0)
                    msgbox('This function requires identical Y across datafiles');
                else
                    if (SameZ==0)
                        msgbox('This function requires identical Z across datafiles');
                    else
                        GLW_varexplained(cb,inputfiles,send_update_status(handles));
                    end;
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function Untitled_134_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function proc_view_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_view_events(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_add_events2_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_delete_duplicate_events_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_delete_duplicate_events(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_compare_events2_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_compare_events2(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_compare_events1_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_compare_events(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_fastwavelet_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fastwavelet(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_artefactsuppression_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_artefactsuppression(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_leveltrigger_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_leveltrigger(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_ttest_value_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ttest_value(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_segmentevent_ssep_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_segmentation_ssep(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_grandaverage_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    if (SameChannels==0)
        msgbox('This function requires identical channels across datafiles');
    else
        if (SameIndex==0)
            msgbox('This function requires identical indexes across datafiles');
        else
            if (SameX==0)
                msgbox('This function requires identical X across datafiles');
            else
                if (SameY==0)
                    msgbox('This function requires identical Y across datafiles');
                else
                    if (SameZ==0)
                        msgbox('This function requires identical Z across datafiles');
                    else
                        GLW_grandaverage(cb,inputfiles,send_update_status(handles));
                    end;
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function proc_concatenate_epochs_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameEpochs==0)
    msgbox('This function requires identical epochs across datafiles');
else
    if (SameChannels==0)
        msgbox('This function requires identical channels across datafiles');
    else
        if (SameIndex==0)
            msgbox('This function requires identical indexes across datafiles');
        else
            if (SameX==0)
                msgbox('This function requires identical X across datafiles');
            else
                if (SameZ==0)
                    msgbox('This function requires identical Z across datafiles');
                else
                    GLW_concatenate_epochs(cb,inputfiles,send_update_status(handles));
                end;
            end;
        end;
    end;
end;


% --------------------------------------------------------------------
function Untitled_135_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_butter(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_simpleview_continuous_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
if length(inputfiles)>1;
    disp('*** More than one file selected. Only showing events of the first selected file!');
end;
GLW_simpleview_continuous(cb,inputfiles{1},handles);


% --------------------------------------------------------------------
function proc_threshold_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_threshold(cb,inputfiles,send_update_status(handles));



% --------------------------------------------------------------------
function proc_adduserdata_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
if length(inputfiles)>1;
    disp('*** Userdata can only be added to a single data file!');
    disp('Please select only one data file');
else
    GLW_adduserdata(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_erplab_filter_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
GLW_erplab_filter(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_dipfit_importdipole_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_fieldtrip_dipfit_importdipole(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_dipfit_fitdipole_repeat_event_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_dipfit_fitdipole_repeat_event(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_dipfit_fitdipole_residuals_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_dipfit_fitdipole_residuals(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_dipfit_fitdipole_repeat_IC_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_dipfit_fitdipole_repeat_IC(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_importEDF_Callback(hObject, eventdata, handles)
cb='test';
GLW_importEDF(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_figure_mapfigure_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_figure_maps(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_update_Callback(hObject, eventdata, handles)
cb='test';
GLW_update(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_ERPimage_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_ERPimage(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_equalize_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_equalize(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_multinotch_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_FFTmultinotch(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function Untitled_136_Callback(hObject, eventdata, handles)



% --------------------------------------------------------------------
function proc_linear_CSD_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_linear_CSD(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_linear_channel_map_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_linear_channel_map(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_multiview_avg_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        cb='test';
        GLW_multiview_avg(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function mb_plugin_Callback(hObject, eventdata, handles)




% --------------------------------------------------------------------
function proc_SSEP_explorer_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        cb='test';
        GLW_figure_SSEP(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function proc_weightedchanavg_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        cb='test';
        GLW_weightedchanavg(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function proc_weightedchanavg_apply_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    if (SameEpochs==0)
        msgbox('This function requires identical epochs across datafiles');
    else
        cb='test';
        GLW_weightedchanavg_apply(cb,inputfiles,send_update_status(handles));
    end;
end;


% --------------------------------------------------------------------
function proc_averageharmonics_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_averageharmonics(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_DCremoval_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_DCremoval(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_hilbert_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_hilbert(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_CWT_continuous_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_CWT_continuous(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_slidingaverage_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_slidingaverage(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_figure_correlfigure_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_figure_wave_correl(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_stFFT2_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_stFFT2(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_explore_interval_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_exploreinterval(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function proc_import_DELTAMED_Callback(hObject, eventdata, handles)
cb='test';
GLW_importDELTAMED(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_import_MEGA_Callback(hObject, eventdata, handles)
cb='test';
GLW_importMEGA(cb,send_update_status(handles));


% --------------------------------------------------------------------
function proc_montage_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
[SameX,SameY,SameZ,SameEpochs,SameChannels,SameIndex]=LW_checkheaders(inputfiles);
if (SameChannels==0)
    msgbox('This function requires identical channels across datafiles');
else
    cb='test';
    GLW_montage(cb,inputfiles,send_update_status(handles));
end;


% --------------------------------------------------------------------
function proc_artefactsuppression_continuous_Callback(hObject, eventdata, handles)
inputfiles=getfiles(handles);
cb='test';
GLW_artefactsuppression_continuous(cb,inputfiles,send_update_status(handles));


% --------------------------------------------------------------------
function Untitled_137_Callback(hObject, eventdata, handles)




% --------------------------------------------------------------------
function proc_eventsviewer_Callback(hObject, eventdata, handles)
