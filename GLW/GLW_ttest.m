function varargout = GLW_ttest(varargin)
% GLW_TTEST MATLAB code for GLW_ttest.fig
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
                   'gui_OpeningFcn', @GLW_ttest_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ttest_OutputFcn, ...
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





% --- Executes just before GLW_ttest is made visible.
function GLW_ttest_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ttest (see VARARGIN)
% Choose default command line output for GLW_ttest
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
st=get(handles.filebox,'String');
%set leftedit and rightedit
set(handles.leftedit,'String',st{1});
set(handles.rightedit,'String',st{2});
%set outputedit
[p,n,e]=fileparts(st{1});
set(handles.outputedit,'String',[p,filesep,'ttest.lw5']);




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ttest_OutputFcn(hObject, eventdata, handles) 
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
% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
leftfile=get(handles.leftedit,'String');
rightfile=get(handles.rightedit,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Statistics : t-test.',1,0);
%load left header and data
update_status.function(update_status.handles,['Loading : ' leftfile],1,0);
[leftheader,leftdata]=LW_load(leftfile);
%load right header and data
update_status.function(update_status.handles,['Loading : ' rightfile],1,0);
[rightheader,rightdata]=LW_load(rightfile);
%set type,tails,alpha
typestring={'paired','nonpaired'};
typeindex=get(handles.typemenu,'Value');
tailstring={'both','right','left'};
tailindex=get(handles.tailmenu,'Value');
alpha=str2num(get(handles.alphaedit,'String'));
%process
update_status.function(update_status.handles,'Performing t test.',1,0);
testtype=typestring{typeindex};
tail=tailstring{tailindex};
update_status.function(update_status.handles,['Tails : ' tail ' Test type : ' testtype ' Alpha : ' num2str(alpha)],1,0);
%ttest
%loop through channels
for chanpos=1:size(leftdata,2);
    %loop through dz
    for dz=1:size(leftdata,4);
        %ttest
        for dy=1:size(leftdata,5);
            t1=squeeze(leftdata(:,chanpos,1,dz,dy,:)); %left
            t2=squeeze(rightdata(:,chanpos,1,dz,dy,:)); %right
            if strcmpi(testtype,'paired');
                %[H,P,CI,STATS]
                [H,actual_tres_pvalue(dy,:),CI,STATS]=ttest(t1,t2,alpha,tail);
                actual_tres_Tvalue(dy,:)=STATS.tstat;
            else
                [H,actual_tres_pvalue(dy,:),CI,STATS]=ttest2(t1,t2,alpha,tail);
                actual_tres_Tvalue(dy,:)=STATS.tstat;
            end;
        end;
        out_data(1,chanpos,1,dz,:,:)=actual_tres_pvalue;
        out_data(1,chanpos,2,dz,:,:)=actual_tres_Tvalue;
    end;
end;
%out_header
out_header=leftheader;
out_header.datasize=size(out_data);
%set index labels
out_header.indexlabels{1}='p-value';
out_header.indexlabels{2}='T-value';

%clustersize thresholding?
if get(handles.cluster_chk,'Value')==1;
    figure; %figure to draw evolution of criticals
    update_status.function(update_status.handles,['Performing cluster-based thresholding. This may take a while!'],1,0);
    update_status.function(update_status.handles,['Check command window and figure for update on progress.'],1,0);
    num_permutations=str2num(get(handles.num_permutations_edit,'String'));
    criticalz=str2num(get(handles.z_threshold_edit,'String'));
    update_status.function(update_status.handles,['Number of permutations : ' num2str(num_permutations)],1,0);
    update_status.function(update_status.handles,['Cluster threshold : ' num2str(criticalz)],1,0);
    cluster_criterion=get(handles.criterion_popup,'Value');
    %merge
    merged_data=zeros(size(leftdata));
    merged_data(:,:,1,:,:,:)=leftdata(:,:,1,:,:,:);
    merged_data(:,:,2,:,:,:)=rightdata(:,:,1,:,:,:);
    merged_cat(:,1)=zeros(size(merged_data,1),1)+1;
    merged_cat(:,2)=zeros(size(merged_data,1),1)+2;
    merged_cat
    %loop
    blobsizes=[];
    for iter=1:num_permutations;
        disp(['Permutation : ' num2str(iter)]);
        %loop through channels
        for chanpos=1:size(leftdata,2);
            %loop through dz
            for dz=1:size(leftdata,4);
                %permutation
                for epochpos=1:size(merged_cat,1);
                    r=rand(size(merged_cat,2),1);
                    [a,b]=sort(r);
                    rnd_cat(epochpos,:)=b;
                end;
                tres=[];
                %ttest (output is tres with p values and T values tres_pvalue / tres_Tvalue)
                for dy=1:size(leftdata,5);
                    for epochpos=1:size(merged_data,1);
                        t1(epochpos,:)=squeeze(merged_data(epochpos,chanpos,rnd_cat(epochpos,1),dz,dy,:));
                        t2(epochpos,:)=squeeze(merged_data(epochpos,chanpos,rnd_cat(epochpos,2),dz,dy,:));
                    end;
                    if strcmpi(testtype,'paired');
                        %[H,P,CI,STATS]
                        [H,P,CI,STATS]=ttest(t1,t2,alpha,tail);
                        tres_pvalue(dy,:)=H.*P;
                        tres_Tvalue(dy,:)=H.*STATS.tstat;
                    else
                        [H,P,CI,STATS]=ttest2(t1,t2,alpha,tail);
                        tres_pvalue(dy,:)=H.*P;
                        tres_Tvalue(dy,:)=H.*STATS.tstat;
                    end;
                end;
                %blobology
                RLL=bwlabel(tres_Tvalue,4);
                RLL_size=[];
                blobpos=1;
                for i=1:max(max(RLL));
                    ff=find(RLL==i);
                    v=sum(sum(abs(RLL(ff))));
                    if v>0;
                        RLL_size(blobpos)=v;
                        blobpos=blobpos+1;
                    end;
                end;
                if isempty(RLL_size);
                    RLL_size=0;
                end;
                %blob summary
                blob_size(chanpos,dz).size(iter)=mean(RLL_size);
                blob_size_max(chanpos,dz).size(iter)=max(RLL_size);
                %critical
                switch cluster_criterion
                    case 1;
                        criticals(chanpos,dz)=(criticalz*std(blob_size(chanpos,dz).size))+mean(blob_size(chanpos,dz).size);
                    case 2;
                        criticals(chanpos,dz)=(criticalz*std(blob_size_max(chanpos,dz).size))+mean(blob_size_max(chanpos,dz).size);
                    case 3;
                        criticals(chanpos,dz)=prctile(blob_size(chanpos,dz).size,100*(1-criticalz));
                    case 4;
                        criticals(chanpos,dz)=prctile(blob_size_max(chanpos,dz).size,100*(1-criticalz));
                end;
            end;
        end;
        tp_plot(iter,:)=squeeze(criticals(:,1));
        plot(tp_plot);
        drawnow;
    end;
    
    %display criticals
    for chanpos=1:size(criticals,1);
        for dz=1:size(criticals,2);
            update_status.function(update_status.handles,['Critical S [' num2str(chanpos) ',' num2str(dz) '] : ' num2str(criticals(chanpos,dz,:))],1,0);
        end;
    end;

    %process actual data (outheader_pvalue/outheader_Fvalue)
    outdata_pvalue=out_data(1,:,1,:,:,:);
    outdata_Tvalue=out_data(1,:,2,:,:,:);
    tres=zeros(size(outdata_pvalue));
    tp=find(outdata_pvalue<alpha);
    tres(tp)=1;
    blob_size=[];
    %loop through channels
    for chanpos=1:size(tres,2);
        %loop through z
        for dz=1:size(tres,4);
            tps=squeeze(tres(1,chanpos,1,dz,:,:));
            tp_Tvalues=squeeze(outdata_Tvalue(1,chanpos,1,dz,:,:));
            tp_pvalues=squeeze(outdata_pvalue(1,chanpos,1,dz,:,:));
            tp2=bwlabel(tps,4);
            %loop through blobs
            toutput_Tvalues=zeros(size(tp_Tvalues));
            toutput_pvalues=ones(size(tp_pvalues));
            for i=1:max(max(tp2));
                %sum Tvalues
                idx=find(tp2==i);
                blob_size=sum(sum(abs(tp_Tvalues(idx))));
                update_status.function(update_status.handles,['B' num2str(i) ': ' num2str(blob_size)],1,0);
                if sum(sum(tps(find(tp2==i))))>0;
                    if blob_size>criticals(chanpos,dz);
                        update_status.function(update_status.handles,'FOUND a significant cluster!',1,0);
                        toutput_Tvalues(idx)=tp_Tvalues(idx);
                        toutput_pvalues(idx)=tp_pvalues(idx);
                    end;
                end;
            end;
            outdata_Tvalue(2,chanpos,1,dz,:,:)=toutput_Tvalues;
            outdata_pvalue(2,chanpos,1,dz,:,:)=toutput_pvalues;
        end;
    end;
    %update out_data
    out_data(2,:,1,:,:,:)=outdata_pvalue(2,:,:,:,:,:);
    out_data(2,:,2,:,:,:)=outdata_Tvalue(2,:,:,:,:,:);
    %adjust header.datasize
    out_header.datasize(1)=2;
end;

%save header data
LW_save(get(handles.outputedit,'String'),[],out_header,out_data);
update_status.function(update_status.handles,'Finished!',0,1);




% --- Executes on selection change in methodmenu.
function methodmenu_Callback(hObject, eventdata, handles)
% hObject    handle to methodmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function methodmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to methodmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in typemenu.
function typemenu_Callback(hObject, eventdata, handles)
% hObject    handle to typemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.typemenu,'Value')==1;
    set(handles.cluster_chk,'Enable',1);
else
    set(handles.cluster_chk,'Value',0);
    set(handles.cluster_chk,'Enable',0);
end;




% --- Executes during object creation, after setting all properties.
function typemenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to typemenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in tailmenu.
function tailmenu_Callback(hObject, eventdata, handles)
% hObject    handle to tailmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function tailmenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tailmenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function leftedit_Callback(hObject, eventdata, handles)
% hObject    handle to leftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function leftedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to leftedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function rightedit_Callback(hObject, eventdata, handles)
% hObject    handle to rightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function rightedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to rightedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.leftedit,'String');
set(handles.leftedit,'String',get(handles.rightedit,'String'));
set(handles.rightedit,'String',st);







function alphaedit_Callback(hObject, eventdata, handles)
% hObject    handle to alphaedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function alphaedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alphaedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function processbutton_CreateFcn(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called







function outputedit_Callback(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function outputedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on button press in cluster_chk.
function cluster_chk_Callback(hObject, eventdata, handles)
% hObject    handle to cluster_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if get(handles.cluster_chk,'Value')==1;
    set(handles.num_permutations_edit,'Enable','on');
    set(handles.z_threshold_edit,'Enable','on');
else
    set(handles.num_permutations_edit,'Enable','off');
    set(handles.z_threshold_edit,'Enable','off');
end;    







function num_permutations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function num_permutations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to num_permutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







function z_threshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to z_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function z_threshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to z_threshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end






% --- Executes on selection change in criterion_popup.
function criterion_popup_Callback(hObject, eventdata, handles)
% hObject    handle to criterion_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)






% --- Executes during object creation, after setting all properties.
function criterion_popup_CreateFcn(hObject, eventdata, handles)
% hObject    handle to criterion_popup (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
