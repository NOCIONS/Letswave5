function varargout = GLW_ttest_value(varargin)
% GLW_TTEST_VALUE MATLAB code for GLW_ttest_value.fig
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
                   'gui_OpeningFcn', @GLW_ttest_value_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ttest_value_OutputFcn, ...
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





% --- Executes just before GLW_ttest_value is made visible.
function GLW_ttest_value_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GLW_ttest_value (see VARARGIN)
% Choose default command line output for GLW_ttest_value
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
st=get(handles.filebox,'String');




% --- Outputs from this function are returned to the command line.
function varargout = GLW_ttest_value_OutputFcn(hObject, eventdata, handles) 
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
inputfiles=get(handles.filebox,'String');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Statistics : t-test.',1,0);
value=str2num(get(handles.valueedit,'String'));
tailstring={'both','right','left'};
tailindex=get(handles.tailmenu,'Value');
tail=tailstring{tailindex};
alpha=str2num(get(handles.alphaedit,'String'));
update_status.function(update_status.handles,['Tails : ' tail ' Alpha : ' num2str(alpha) ' Constant : ' num2str(value)],1,0);
%loop through files
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,['Performing t-test...'],1,0);
    tail=tailstring{tailindex};
    %ttest
    %loop through channels
    for chanpos=1:size(data,2);
        %loop through dz
        for dz=1:size(data,4);
            %ttest
            for dy=1:size(data,5);
                t1=squeeze(data(:,chanpos,1,dz,dy,:))-value; 
                %[H,P,CI,STATS]
                [H,actual_tres_pvalue(dy,:),CI,STATS]=ttest(t1,0,alpha,tail);
                actual_tres_Tvalue(dy,:)=STATS.tstat;
            end;
            out_data(1,chanpos,1,dz,:,:)=actual_tres_pvalue;
            out_data(1,chanpos,2,dz,:,:)=actual_tres_Tvalue;
        end;
    end;
    %out_header
    out_header=header;
    out_header.datasize=size(out_data);
    %set index labels
    out_header.indexlabels{1}='p-value';
    out_header.indexlabels{2}='T-value';
    
    blob_size=[];
    blob_size_max=[];
    tp_plot=[];

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
        %loop
        blobsizes=[];
        tres_Tvalue=[];
        tres_pvalue=[];
        rnd_data=zeros(size(data,1),size(data,5),size(data,6));
        tres_pvalue=zeros(size(rnd_data,2),size(rnd_data,3));
        tres_Tvalue=zeros(size(rnd_data,2),size(rnd_data,3));
        for iter=1:num_permutations;
            disp(['Permutation : ' num2str(iter)]);
            %loop through channels
            for chanpos=1:size(data,2);
                %loop through dz
                for dz=1:size(data,4);
                    %permutation (random sign change across epochs)
                    for epochpos=1:size(data,1);
                        r=rand(2,1);
                        [a,b]=sort(r);
                        if b(1)==1;
                            rnd_data(epochpos,:,:)=squeeze((data(epochpos,chanpos,1,dz,:,:)-value)*1);
                        else
                            rnd_data(epochpos,:,:)=squeeze((data(epochpos,chanpos,1,dz,:,:)-value)*-1);
                        end;
                    end;
                    tres=[];
                    %ttest (output is tres with p values and T values tres_pvalue / tres_Tvalue)
                    for dy=1:size(rnd_data,2);
                        %[H,P,CI,STATS]
                        %ttest(tpleft,value,alpha,tail)
                        [H,P,CI,STATS]=ttest(squeeze(rnd_data(:,dy,:)),0,alpha,tail);
                        tres_pvalue(dy,:)=H.*P;
                        tres_Tvalue(dy,:)=H.*STATS.tstat;
                    end;
                    %blobology
                    RLL=bwlabel(tres_Tvalue,4);
                    RLL_size=[];
                    blobpos=1;
                    %plot(tres_Tvalue);
                    for i=1:max(max(RLL));
                        ff=find(RLL==i);
                        v=sum(sum(RLL(ff)));
                        if v>0;
                            %size(tres_Tvalue);
                            RLL_size(blobpos)=sum(sum(abs(tres_Tvalue(ff))));
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
    LW_save(inputfiles{filepos},get(handles.prefixedit,'String'),out_header,out_data);
end;
update_status.function(update_status.handles,'Finished!',0,1);




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



function prefixedit_Callback(hObject, eventdata, handles)
% hObject    handle to prefixedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function prefixedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




function valueedit_Callback(hObject, eventdata, handles)
% hObject    handle to valueedit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function valueedit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to valueedit (see GCBO)
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
