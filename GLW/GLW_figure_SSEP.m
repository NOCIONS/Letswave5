function varargout = GLW_figure_SSEP(varargin)
% GLW_FIGURE_SSEP MATLAB code for GLW_figure_SSEP.fig




% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_figure_SSEP_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_figure_SSEP_OutputFcn, ...
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





% --- Executes just before GLW_figure_SSEP is made visible.
function GLW_figure_SSEP_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_figure_SSEP (see VARARGIN)
% Choose default command line output for GLW_figure_SSEP
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
axis off;
%fill listbox with inputfiles
set(handles.filebox,'UserData',varargin{2});
inputfiles=get(handles.filebox,'UserData');
cleanfiles={};
for i=1:length(inputfiles);
    [p n e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
set(handles.filebox,'String',cleanfiles);
%load headers and datas
for i=1:length(inputfiles);
    [header,data]=LW_load(inputfiles{i});
    idata(i).header=header;
    idata(i).data=data;
end;
set(handles.epochbox,'UserData',idata);
updateboxes(handles);



    



function updateboxes(handles);
%get filepos
filepos=get(handles.filebox,'Value');
%get data
data=get(handles.epochbox,'UserData');
header=data(filepos).header;
%update epochbox
string={};
for i=1:header.datasize(1);
    string{i}=num2str(i);
end;
set(handles.epochbox,'String',string);
tp=get(handles.epochbox,'Value');
tp(find(tp>header.datasize(1)))=[];
set(handles.epochbox,'Value',tp);
%update channelbox
string={};
for i=1:header.datasize(2);
    string{i}=header.chanlocs(i).labels;
end;
set(handles.channelbox,'String',string);
tp=get(handles.channelbox,'Value');
tp(find(tp>header.datasize(2)))=[];
set(handles.channelbox,'Value',tp);
%update indexbox
string={};
if isfield(header,'indexlabels');
    for i=1:header.datasize(3);
        string{i}=header.indexlabels{i}
    end;
else
    for i=1:header.datasize(3);
        string{i}=num2str(i);
    end;
end;
set(handles.indexbox,'String',string);
tp=get(handles.indexbox,'Value');
tp(find(tp>header.datasize(3)))=[];
set(handles.indexbox,'Value',tp);







function updatewavebox(handles);
%wavedata
wavedata=get(handles.wavebox,'UserData');
%headerdata
data=get(handles.epochbox,'UserData');
%filestring
filestring=get(handles.filebox,'String');
%build string
st={};
if isempty(wavedata);
else
    for i=1:length(wavedata);
        filepos=wavedata(i).filepos;
        header=data(filepos).header;
        %chanlabel
        if wavedata(i).channelpos==0;
            chanlabel='AVG';
        else
            chanlabel=header.chanlocs(wavedata(i).channelpos).labels;
        end;
        if isfield(header,'indexlabels');
            st{i}=[filestring{filepos} ' E:' num2str(wavedata(i).epochpos) ' C:' chanlabel ' I:' header.indexlabels{wavedata(i).indexpos}];
        else
            st{i}=[filestring{filepos} ' E:' num2str(wavedata(i).epochpos) ' C:' chanlabel ' I:' num2str(wavedata(i).indexpos)];
        end;
    end;
end;
set(handles.wavebox,'String',st);
    



% --- Outputs from this function are returned to the command line.
function varargout = GLW_figure_SSEP_OutputFcn(hObject, eventdata, handles) 
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
updateboxes(handles);




% --- Executes during object creation, after setting all properties.
function filebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to filebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function [af1,af2,af1f2]=findfrequencies(f1,f2,num_harmonics,header)
freqmin=header.xstart;
freqmax=header.xstart+((header.datasize(6)-1)*header.xstep);
%f1,f2
for n=1:num_harmonics;
    af1(n)=f1*n;
    af2(n)=f2*n;
end;
%f1f2
i=1;
for n=1:num_harmonics;
    for m=1:num_harmonics;
        af1f2(i)=af1(n)+af2(m);
        i=i+1;
        af1f2(i)=abs(af1(n)-af2(m));
        i=i+1;
    end;
end;
%check ranges
af1(find(af1<freqmin))=[];
af1(find(af1>freqmax))=[];
af2(find(af2<freqmin))=[];
af2(find(af2>freqmax))=[];
af1f2(find(af1f2<freqmin))=[];
af1f2(find(af1f2>freqmax))=[];
%sort
af1=unique(sort(af1));
af2=unique(sort(af2));
af1f2=unique(sort(af1f2));
%disp
%disp(['F1 : ' num2str(af1)]);
%disp(['F2 : ' num2str(af2)]);
%disp(['F1F2 : ' num2str(af1f2)]);



% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
%data
wavedata=get(handles.wavebox,'UserData');
wavestring=get(handles.wavebox,'String');
wavestring=strrep(wavestring,'_',' ');
%f2_chk
f2_chk=get(handles.f2_chk,'Value');
%headers
data=get(handles.epochbox,'UserData');
disp(['Graph size : ' num2str(length(wavedata))]);
if length(wavedata)>0;
    for wavepos=1:length(wavedata);
        %fetch f1, f2 and num_harmonics
        f1=str2num(get(handles.f1_edit,'String'));
        f2=str2num(get(handles.f2_edit,'String'));
        num_harmonics=str2num(get(handles.harm_edit,'String'));
        %calculate the data to be displayed
        %loop through rows
        %each row will appear as an additional bar within each bar stack
        %header
        header=data(wavedata(wavepos).filepos).header;
        %calc af1,af2,af1f2
        [af1,af2,af1f2]=findfrequencies(f1,f2,num_harmonics,header);
        %tpx
        tpx=1:1:header.datasize(6);
        tpx=((tpx-1)*header.xstep)+header.xstart;
        %df1, df2, df1f2
        for i=1:length(af1);
            [cf1(i),df1(i)]=min(abs(tpx-af1(i)));
        end;
        if f2_chk==1;
            for i=1:length(af2);
                [cf2(i),df2(i)]=min(abs(tpx-af2(i)));
            end;
            for i=1:length(af1f2);
                [cf1f2(i),df1f2(i)]=min(abs(tpx-af1f2(i)));
            end;
        end;
        %tolerance
        tolerance=str2num(get(handles.tolerance_edit,'String'));
        df1_min=df1-tolerance;
        df1_min(find(df1_min<1))=1;
        df1_max=df1+tolerance;
        df1_max(find(df1_max>header.datasize(6)))=header.datasize(6);
        if f2_chk==1;
            df2_min=df2-tolerance;
            df2_min(find(df2_min<1))=1;
            df2_max=df2+tolerance;
            df2_max(find(df2_max>header.datasize(6)))=header.datasize(6);
            df1f2_min=df1f2-tolerance;
            df1f2_min(find(df1f2_min<1))=1;
            df1f2_max=df1f2+tolerance;
            df1f2_max(find(df1f2_max>header.datasize(6)))=header.datasize(6);
        end;
        %discard ambiguous frequencies
        if get(handles.ambiguous_chk,'Value')==1;
            if f2_chk==1;
                %f1
                df1_remove=[];
                for i=1:length(df1);
                    tpdf1_min=df1_min;
                    tpdf2_min=df2_min;
                    tpdf1f2_min=df1f2_min;
                    tpdf1_max=df1_max;
                    tpdf2_max=df2_max;
                    tpdf1f2_max=df1f2_max;
                    tpdf1_min(i)=[];
                    tpdf1_max(i)=[];
                    tp_min=[tpdf1_min tpdf2_min tpdf1f2_min];
                    tp_max=[tpdf1_max tpdf2_max tpdf1f2_max];
                    for j=1:length(tp_min);
                        if df1_min(i)>=tp_min(j);
                            if df1_max(i)<=tp_max(j);
                                df1_remove=[df1_remove i];
                            end;
                        end;
                    end;
                end;
                %f2
                df2_remove=[];
                for i=1:length(df2);
                    tpdf1_min=df1_min;
                    tpdf2_min=df2_min;
                    tpdf1f2_min=df1f2_min;
                    tpdf1_max=df1_max;
                    tpdf2_max=df2_max;
                    tpdf1f2_max=df1f2_max;
                    tpdf2_min(i)=[];
                    tpdf2_max(i)=[];
                    tp_min=[tpdf1_min tpdf2_min tpdf1f2_min];
                    tp_max=[tpdf1_max tpdf2_max tpdf1f2_max];
                    for j=1:length(tp_min);
                        if df2_min(i)>=tp_min(j);
                            if df2_max(i)<=tp_max(j);
                                df2_remove=[df2_remove i];
                            end;
                        end;
                    end;
                end;
                %f1f2
                df1f2_remove=[];
                for i=1:length(df1f2);
                    tpdf1_min=df1_min;
                    tpdf2_min=df2_min;
                    tpdf1f2_min=df1f2_min;
                    tpdf1_max=df1_max;
                    tpdf2_max=df2_max;
                    tpdf1f2_max=df1f2_max;
                    tpdf1f2_min(i)=[];
                    tpdf1f2_max(i)=[];
                    tp_min=[tpdf1_min tpdf2_min tpdf1f2_min];
                    tp_max=[tpdf1_max tpdf2_max tpdf1f2_max];
                    for j=1:length(tp_min);
                        if df1f2_min(i)>=tp_min(j);
                            if df1f2_max(i)<=tp_max(j);
                                df1f2_remove=[df1f2_remove i];
                            end;
                        end;
                    end;
                end;
                if length(df1_remove)>0;
                    disp(['F1 : removing ambiguous frequencies (Hz) : ' num2str(af1(df1_remove))]);
                    disp(['F1 : removing ambiguous frequencies (bin) : ' num2str(df1(df1_remove))]);
                    af1(df1_remove)=[];
                    cf1(df1_remove)=[];
                    df1(df1_remove)=[];
                    df1_min(df1_remove)=[];
                    df1_max(df1_remove)=[];
                end;
                if length(df2_remove)>0;
                    disp(['F2 : removing ambiguous frequencies (Hz) : ' num2str(af2(df2_remove))]);
                    disp(['F2 : removing ambiguous frequencies (bin) : ' num2str(df2(df2_remove))]);
                    af2(df2_remove)=[];
                    cf2(df2_remove)=[];
                    df2(df2_remove)=[];
                    df2_min(df2_remove)=[];
                    df2_max(df2_remove)=[];
                end;
                if length(df1f2_remove)>0;
                    disp(['F1xF2 : removing ambiguous frequencies (Hz) : ' num2str(af1f2(df1f2_remove))]);
                    disp(['F1xF2 : removing ambiguous frequencies (bin) : ' num2str(df1f2(df1f2_remove))]);
                    af1f2(df1f2_remove)=[];
                    cf1f2(df1f2_remove)=[];
                    df1f2(df1f2_remove)=[];
                    df1f2_min(df1f2_remove)=[];
                    df1f2_max(df1f2_remove)=[];
                end;
            end;
        end;
        %epoch,channel,index positions
        epochpos=wavedata(wavepos).epochpos;
        channelpos=wavedata(wavepos).channelpos;
        indexpos=wavedata(wavepos).indexpos;
        %fetch data, average if needed, calculate sd if needed
        tpdata_sd=0;
        tpdata=data(wavedata(wavepos).filepos).data(:,:,indexpos,1,1,:);
        if channelpos>0;
            tpdata=tpdata(:,channelpos,:,:,:,:);
            tpdata_sd=tpdata.*0;
        else
            disp('Averaging channels');
            tpdata_sd=std(tpdata,0,2);
            tpdata=mean(tpdata,2);
        end;
        if epochpos>0;
            tpdata=tpdata(epochpos,:,:,:,:,:);
            tpdata_sd=tpdata.*0;
        else
            disp('Averaging epochs');
            tpdata_sd=std(tpdata,0,1);
            tpdata=mean(tpdata,1);
        end;
        tpdata=squeeze(tpdata);
        tpdata_sd=squeeze(tpdata_sd);
        %graph_data.f1(:,wavepos)=tpdata(df1);
        for i=1:length(df1);
            [graph_data.f1(i,wavepos),selected_df1(i)]=max(tpdata(df1_min(i):df1_max(i)));
        end;
        selected_df1=selected_df1+df1_min-1;
        if f2_chk==1;
            %graph_data.f2(:,wavepos)=tpdata(df2);
            for i=1:length(df2);
                [graph_data.f2(i,wavepos),selected_df2(i)]=max(tpdata(df2_min(i):df2_max(i)));
            end;
            selected_df2=selected_df2+df2_min-1;
            %graph_data.f1f2(:,wavepos)=tpdata(df1f2);
            for i=1:length(df1f2);
                [graph_data.f1f2(i,wavepos),selected_df1f2(i)]=max(tpdata(df1f2_min(i):df1f2_max(i)));
            end;
            selected_df1f2=selected_df1f2+df1f2_min-1;
        end;
        graph_data.f1_sd(:,wavepos)=tpdata_sd(selected_df1);
        if f2_chk==1;
            graph_data.f2_sd(:,wavepos)=tpdata_sd(selected_df2);
            graph_data.f1f2_sd(:,wavepos)=tpdata_sd(selected_df1f2);
        end;
    end;
    %check if sd should be displayed
    if get(handles.errorbars_chk,'Value')==0;
        graph_data.sd='no';
    else
        graph_data.sd='yes';
    end;
    %create figure
    if get(handles.average_chk,'Value')==0;
        if strcmpi(graph_data.sd,'no');
            %F1
            figure('name','F1');
            bar(graph_data.f1);
            set(gca,'XTickMode','manual');
            set(gca,'XTick',1:length(af1));
            set(gca,'XTickLabel',num2cell(af1));
            if f2_chk==1;
                %F2
                figure('name','F2');
                bar(graph_data.f2);
                set(gca,'XTickMode','manual');
                set(gca,'XTick',1:length(af2));
                set(gca,'XTickLabel',num2cell(af2));
                %F1F2
                figure('name','F1xF2');
                bar(graph_data.f1f2);
                set(gca,'XTickMode','manual');
                set(gca,'XTick',1:length(af1f2));
                set(gca,'XTickLabel',num2cell(af1f2));
            end;
        else;
            %F1
            figure('name','F1');
            barwitherr(graph_data.f1_sd,graph_data.f1);
            set(gca,'XTickMode','manual');
            set(gca,'XTick',1:length(af1));
            set(gca,'XTickLabel',num2cell(af1));
            if f2_chk==1;
                %F2
                figure('name','F2');
                barwitherr(graph_data.f2_sd,graph_data.f2);
                set(gca,'XTickMode','manual');
                set(gca,'XTick',1:length(af2));
                set(gca,'XTickLabel',num2cell(af2));
                %F1F2
                figure('name','F1xF2');
                barwitherr(graph_data.f1f2_sd,graph_data.f1f2);
                set(gca,'XTickMode','manual');
                set(gca,'XTick',1:length(af1f2));
                set(gca,'XTickLabel',num2cell(af1f2));
            end;
        end;
    else
        if strcmpi(graph_data.sd,'no');
            figure;
            tp(1,:)=mean(graph_data.f1,1);
            tp_label{1}='F1';
            if f2_chk==1;
                tp(2,:)=mean(graph_data.f2,1);
                tp(3,:)=mean(graph_data.f1f2,1);
                tp_label{2}='F2';
                tp_label{3}='F1xF2';
            end;
            bar(tp);
            set(gca,'XTickMode','manual');
            set(gca,'XTick',1:length(tp_label));
            set(gca,'XTickLabel',tp_label);
        else
            figure;
            tp(1,:)=mean(graph_data.f1,1);
            tp_sd(1,:)=mean(graph_data.f1_sd,1);
            tp_label{1}='F1';
            if f2_chk==1;
                tp(2,:)=mean(graph_data.f2,1);
                tp(3,:)=mean(graph_data.f1f2,1);
                tp_sd(2,:)=mean(graph_data.f2_sd,1);
                tp_sd(3,:)=mean(graph_data.f1f2_sd,1);
                tp_label{2}='F2';
                tp_label{3}='F1xF2';
            end;
            barwitherr(tp_sd,tp);
            set(gca,'XTickMode','manual');
            set(gca,'XTick',1:length(tp_label));
            set(gca,'XTickLabel',tp_label);
        end;
    end;
end;
    




% --- Executes on selection change in epochbox.
function epochbox_Callback(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function epochbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to epochbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on selection change in channelbox.
function channelbox_Callback(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function channelbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to channelbox (see GCBO)
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







% --- Executes on button press in addbutton.
function addbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
wavepos=length(wavedata)+1;
wavedata(wavepos).filepos=get(handles.filebox,'Value');
wavedata(wavepos).epochpos=get(handles.epochbox,'Value');
wavedata(wavepos).channelpos=get(handles.channelbox,'Value');
wavedata(wavepos).indexpos=get(handles.indexbox,'Value');
%if average
if get(handles.average_epochs_chk,'Value')==1;
    wavedata(wavepos).epochpos=0;
end;
if get(handles.average_channels_chk,'Value')==1;
    wavedata(wavepos).channelpos=0;
end;
set(handles.wavebox,'UserData',wavedata);
updatewavebox(handles);






% --- Executes on selection change in wavebox.
function wavebox_Callback(hObject, eventdata, handles)
% hObject    handle to wavebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
%update using current selection
selected=get(handles.wavebox,'Value');
if isempty(selected);
else
    set(handles.filebox,'Value',wavedata(selected).filepos);
    updateboxes(handles);
    if wavedata(selected).epochpos>0;
        set(handles.epochbox,'Value',wavedata(selected).epochpos);
        set(handles.average_epochs_chk,'Value',0);
    else
        set(handles.epochbox,'Value',1);
        set(handles.average_epochs_chk,'Value',1);
    end;
    if wavedata(selected).channelpos>0;
        set(handles.channelbox,'Value',wavedata(selected).channelpos);
        set(handles.average_channels_chk,'Value',0);
    else
        set(handles.channelbox,'Value',1);
        set(handles.average_channels_chk,'Value',1);
    end;
    set(handles.indexbox,'Value',wavedata(selected).indexpos);
end;






% --- Executes during object creation, after setting all properties.
function wavebox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to wavebox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in deletebutton.
function deletebutton_Callback(hObject, eventdata, handles)
% hObject    handle to deletebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavedata=get(handles.wavebox,'UserData');
wavepos=get(handles.wavebox,'Value');
if isempty(wavedata)
else
    wavedata(wavepos)=[];
    set(handles.wavebox,'UserData',wavedata);
    wavepos2=wavepos-1;
    if wavepos2==0
        wavepos2=1;
    end;
    set(handles.wavebox,'Value',wavepos2);
end;
updatewavebox(handles);






% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.wavebox,'UserData',[]);
set(handles.wavebox,'Value',[]);
updatewavebox(handles);






% --- Executes on button press in updatebutton.
function updatebutton_Callback(hObject, eventdata, handles)
% hObject    handle to updatebutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
wavepos=get(handles.wavebox,'Value');
if isempty(wavepos);
else
    wavedata=get(handles.wavebox,'UserData');
    if isempty(wavedata);
    else
        wavedata(wavepos).filepos=get(handles.filebox,'Value');
        wavedata(wavepos).epochpos=get(handles.epochbox,'Value');
        wavedata(wavepos).channelpos=get(handles.channelbox,'Value');
        wavedata(wavepos).indexpos=get(handles.indexbox,'Value');
        %if average
        if get(handles.average_epochs_chk,'Value')==1;
            wavedata(wavepos).epochpos=0;
        end;
        if get(handles.average_channels_chk,'Value')==1;
            wavedata(wavepos).channelpos=0;
        end;
        set(handles.wavebox,'UserData',wavedata);
        updatewavebox(handles);
    end;
end;





function xlim1_Callback(hObject, eventdata, handles)
% hObject    handle to xlim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function xlim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function xlim2_Callback(hObject, eventdata, handles)
% hObject    handle to xlim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function xlim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xlim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in xlimchk.
function xlimchk_Callback(hObject, eventdata, handles)
% hObject    handle to xlimchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function ylim1_Callback(hObject, eventdata, handles)
% hObject    handle to ylim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function ylim1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function ylim2_Callback(hObject, eventdata, handles)
% hObject    handle to ylim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function ylim2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ylim2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in ylimchk.
function ylimchk_Callback(hObject, eventdata, handles)
% hObject    handle to ylimchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function xintervaledit_Callback(hObject, eventdata, handles)
% hObject    handle to xintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xintervaledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function xanchoredit_Callback(hObject, eventdata, handles)
% hObject    handle to xanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function xanchoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in xtickchk.
function xtickchk_Callback(hObject, eventdata, handles)
% hObject    handle to xtickchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function yintervaledit_Callback(hObject, eventdata, handles)
% hObject    handle to yintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function yintervaledit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yintervaledit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function yanchoredit_Callback(hObject, eventdata, handles)
% hObject    handle to yanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function yanchoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to yanchoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in ytickchk.
function ytickchk_Callback(hObject, eventdata, handles)
% hObject    handle to ytickchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes on button press in ydirchk.
function ydirchk_Callback(hObject, eventdata, handles)
% hObject    handle to ydirchk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






function row_edit_Callback(hObject, eventdata, handles)
% hObject    handle to row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function row_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to row_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function col_edit_Callback(hObject, eventdata, handles)
% hObject    handle to col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function col_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to col_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on selection change in colormap_popup.
function colormap_popup_Callback(hObject, eventdata, handles)
% hObject    handle to colormap_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function colormap_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to colormap_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function cmin_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function cmin_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmin_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function cmax_edit_Callback(hObject, eventdata, handles)
% hObject    handle to cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function cmax_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cmax_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on button press in backgroundbutton.
function backgroundbutton_Callback(hObject, eventdata, handles)
% hObject    handle to backgroundbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes on button press in grid_chk.
function grid_chk_Callback(hObject, eventdata, handles)
% hObject    handle to grid_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








% --- Executes on button press in average_epochs_chk.
function average_epochs_chk_Callback(hObject, eventdata, handles)
% hObject    handle to average_epochs_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








% --- Executes on button press in average_channels_chk.
function average_channels_chk_Callback(hObject, eventdata, handles)
% hObject    handle to average_channels_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)








function f1_edit_Callback(hObject, eventdata, handles)
% hObject    handle to f1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function f1_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f1_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






function f2_edit_Callback(hObject, eventdata, handles)
% hObject    handle to f2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function f2_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to f2_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function harm_edit_Callback(hObject, eventdata, handles)
% hObject    handle to harm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function harm_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to harm_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in errorbars_chk.
function errorbars_chk_Callback(hObject, eventdata, handles)
% hObject    handle to errorbars_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in f2_chk.
function f2_chk_Callback(hObject, eventdata, handles)
% hObject    handle to f2_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in ambiguous_chk.
function ambiguous_chk_Callback(hObject, eventdata, handles)
% hObject    handle to ambiguous_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







function tolerance_edit_Callback(hObject, eventdata, handles)
% hObject    handle to tolerance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function tolerance_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tolerance_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in legend_chk.
function legend_chk_Callback(hObject, eventdata, handles)
% hObject    handle to legend_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in average_chk.
function average_chk_Callback(hObject, eventdata, handles)
% hObject    handle to average_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of average_chk
