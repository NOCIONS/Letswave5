function varargout = GLW_ANOVA_withpermutation(varargin)
%GLW_ANOVA_withpermutation M-file for GLW_ANOVA_withpermutation.fig
%      GLW_ANOVA_withpermutation, by itself, creates a new GLW_ANOVA_withpermutation or raises the existing
%      singleton*.
%
%      H = GLW_ANOVA_withpermutation returns the handle to a new GLW_ANOVA_withpermutation or the handle to
%      the existing singleton*.
%
%      GLW_ANOVA_withpermutation('Property','Value',...) creates a new GLW_ANOVA_withpermutation using the
%      given property value pairs. Unrecognized properties are passed via
%      varargin to GLW_ANOVA_withpermutation_OpeningFcn.  This calling syntax produces a
%      warning when there is an existing singleton*.
%
%      GLW_ANOVA_withpermutation('CALLBACK') and GLW_ANOVA_withpermutation('CALLBACK',hObject,...) call the
%      local function named CALLBACK in GLW_ANOVA_withpermutation.M with the given input
%      arguments.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GLW_ANOVA_withpermutation

% Last Modified by GUIDE v2.5 05-Jul-2014 06:45:07

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GLW_ANOVA_withpermutation_OpeningFcn, ...
                   'gui_OutputFcn',  @GLW_ANOVA_withpermutation_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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








% --- Executes just before GLW_ANOVA_withpermutation is made visible.
function GLW_ANOVA_withpermutation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)
% Choose default command line output for GLW_ANOVA_withpermutation
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
set(handles.filebox,'String',varargin{2});
%clear table
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
set(handles.factoredit,'UserData',{});
%inputfiles
inputfiles=get(handles.filebox,'String');
%cleanfiles
for i=1:length(inputfiles);
    [p,n,e]=fileparts(inputfiles{i});
    cleanfiles{i}=n;
end;
%set RowName
set(handles.uitable,'RowName',cleanfiles);






% --- Outputs from this function are returned to the command line.
function varargout = GLW_ANOVA_withpermutation_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;







% --- Executes during object creation, after setting all properties.
function figure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to figure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called







% --- Executes on button press in processbutton.
function processbutton_Callback(hObject, eventdata, handles)
% hObject    handle to processbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
inputfiles=get(handles.filebox,'String');
fig_title=get(handles.figure,'Name');
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Statistics : ANOVA.',1,0);
set(handles.figure,'Name',[fig_title ' (Running']);
%parfor?
%matlabpool
parfor_chk=get(handles.parfor_chk,'Value');
if parfor_chk==1;
    update_status.function(update_status.handles,['Starting parallel pool...'],1,0);
    try
        if exist('parpool')==2;
            disp('Using parpool function');
            parpool;
        else
            disp('Using matlabpool function');
            matlabpool(parcluster);
        end;
    end
    update_status.function(update_status.handles,['Parallel pool is now enabled.'],1,0);
end;
%headers datas
for i=1:length(inputfiles);
    [headers(i).header,datas(i).data]=LW_load(inputfiles{i});
end;
%groups
%groups : matrix n datafiles x m groups
groups=cell2mat(get(handles.uitable,'Data'));
groups=groups-1;
%within
%within : vector of m groups (0=between;1=within)
factors=get(handles.factoredit,'UserData');
for i=1:length(factors);
    within(i)=factors(i).within;
    label{i}=factors(i).label;
end;

%within_levels, within_labels
if isempty(find(within==1));
    within_levels=[];
    within_labels={};
else
    within_levels=groups(:,find(within==1));
    within_labels=label(find(within==1));
end;

%between_levels, between_labels
if isempty(find(within==0));
    between_levels=[];
    between_labels={};
else
    between_levels=groups(:,find(within==0));
    between_labels=label(find(within==0));
end;

%size(within_levels)
%within_labels
%between_levels
%between_labels

%anovan
update_status.function(update_status.handles,'Computing ANOVA. This may take a while!',1,0);
time=cputime;
if parfor_chk==1;
    [outheader_pvalue,outdata_pvalue,outheader_Fvalue,outdata_Fvalue]=LW_custANOVA_parfor(headers,datas,within_levels,within_labels,between_levels,between_labels);
else
    [outheader_pvalue,outdata_pvalue,outheader_Fvalue,outdata_Fvalue]=LW_custANOVA(headers,datas,within_levels,within_labels,between_levels,between_labels);
end;
update_status.function(update_status.handles,['Operation time : ' num2str(time) ' seconds.'],1,0);

%permutation?
if get(handles.cluster_chk,'Value')==1
    figure;
    %number of permutations
    numpermutations=str2num(get(handles.numpermutations_edit,'String'));
    update_status.function(update_status.handles,['Performing cluster-based thresholding. This may take a while!'],1,0);
    update_status.function(update_status.handles,['Check command window and figure for update on progress.'],1,0);
    update_status.function(update_status.handles,['Total expected time for permutation (s): ' num2str(time*numpermutations)],1,0);
    criticalz=str2num(get(handles.clusterthreshold_edit,'String'));
    criticalp=str2num(get(handles.pvalue_edit,'String'));
    cluster_criterion=get(handles.clustercriterion_edit,'Value');
    datas2=datas;
    tres0=zeros(size(outdata_pvalue));
    update_status.function(update_status.handles,['Number of permutations : ' num2str(numpermutations)],1,0);
    update_status.function(update_status.handles,['Cluster threshold : ' num2str(criticalz)],1,0);
    %loop through permutations
    for iter=1:numpermutations;
        %loop through epochs
        for i=1:size(datas(1).data,1);
            r=rand(length(datas),1);
            [a,b]=sort(r);
            for j=1:length(datas);
                datas2(j).data(i,:,:,:,:,:)=datas(b(j)).data(i,:,:,:,:,:);
            end;
        end;
        disp(['permutation : ' num2str(iter)]);
        if parfor_chk==1;
            [outheader2_pvalue,outdata2_pvalue,outheader2_Fvalue,outdata2_Fvalue]=LW_custANOVA_parfor(headers,datas2,within_levels,within_labels,between_levels,between_labels);
        else
            [outheader2_pvalue,outdata2_pvalue,outheader2_Fvalue,outdata2_Fvalue]=LW_custANOVA(headers,datas2,within_levels,within_labels,between_levels,between_labels);
        end;
        %threshold
        tres=tres0;
        tp=find(outdata2_pvalue<criticalp);
        tres(tp)=1;
       
        %loop through channels
        for chanpos=1:size(tres,2);
            %loop through z
            for dz=1:size(tres,4);
                %loop through index
                for indexpos=1:size(tres,3);
                    tps=squeeze(tres(1,chanpos,indexpos,dz,:,:));
                    tp_Fvalues=squeeze(outdata2_Fvalue(1,chanpos,indexpos,dz,:,:));
                    tp2=bwlabel(tps,4);
                    %loop through blobs
                    tpsize=[];
                    for i=1:max(max(tp2));
                        %sum Fvalues
                        if sum(sum(tps(find(tp2==i))))>0;
                            tpsize(i)=sum(sum(tp_Fvalues(find(tp2==i))));
                        end;
                    end;
                    if isempty(tpsize);
                        blob_size(chanpos,dz,indexpos).size(iter)=0;
                        blob_size_max(chanpos,dz,indexpos).size(iter)=0;
                    else
                        blob_size(chanpos,dz,indexpos).size(iter)=mean(tpsize);
                        blob_size_max(chanpos,dz,indexpos).size(iter)=max(tpsize);
                    end;
                    %criticals(chanpos,dz,indexpos)=(criticalz*std(blob_size(chanpos,dz,indexpos).size))+mean(blob_size(chanpos,dz,indexpos).size);
                    switch cluster_criterion
                        case 1;         
                            criticals(chanpos,dz,indexpos)=(criticalz*std(blob_size(chanpos,dz,indexpos).size))+mean(blob_size(chanpos,dz,indexpos).size);
                        case 2;
                            criticals(chanpos,dz,indexpos)=(criticalz*std(blob_size_max(chanpos,dz,indexpos).size))+mean(blob_size_max(chanpos,dz,indexpos).size);
                        case 3;
                            criticals(chanpos,dz,indexpos)=prctile(blob_size(chanpos,dz,indexpos).size,100*(1-criticalz));
                        case 4;
                            criticals(chanpos,dz,indexpos)=prctile(blob_size_max(chanpos,dz,indexpos).size,100*(1-criticalz));
                    end;
                end;
            end;
        end;
        for chanpos=1:size(criticals,1);
            for dz=1:size(criticals,2);
                update_status.function(update_status.handles,['Critical S [' num2str(chanpos) ',' num2str(dz) '] : ' num2str(criticals(chanpos,dz,:))],1,0);
            end;
        end;
        tp_plot(iter,:)=squeeze(criticals(1,1,:));
        plot(tp_plot);
        drawnow;
    end;

    %distribution
    update_status.function(update_status.handles,'Calculating distributions',1,0);
    blob_size_dist_x=0:0.1:100;
    for chanpos=1:size(tres,2);
        for dz=1:size(tres,4);
            for indexpos=1:size(tres,3);
                for i=1:length(blob_size_dist_x);
                    blob_size_dist(chanpos,dz,indexpos,i)=prctile(blob_size(chanpos,dz,indexpos).size,blob_size_dist_x(i));
                    blob_size_max_dist(chanpos,dz,indexpos,i)=prctile(blob_size_max(chanpos,dz,indexpos).size,blob_size_dist_x(i));
                end;
            end;
        end;
    end;
    
    
    %zscore
    %for chanpos=1:size(blob_size,1);
    %    for dz=1:size(blob_size,2);
    %        for indexpos=1:size(blob_size,3);
    %            criticals(chanpos,dz,indexpos)=(criticalz*std(blob_size(chanpos,dz,indexpos).size))+mean(blob_size(chanpos,dz,indexpos).size);
    %        end;
    %    end;
    %end;
    %process actual data (outheader_pvalue/outheader_Fvalue)
    tres=tres0;
    tp=find(outdata_pvalue<criticalp);
    tres(tp)=1;
    blob_size=[];
   
    
    
    %loop through channels
    for chanpos=1:size(tres,2);
        %loop through z
        for dz=1:size(tres,4);
            %loop through index
            for indexpos=1:size(tres,3);
                tps=squeeze(tres(1,chanpos,indexpos,dz,:,:));
                tp_Fvalues=squeeze(outdata_Fvalue(1,chanpos,indexpos,dz,:,:));
                tp_pvalues=squeeze(outdata_pvalue(1,chanpos,indexpos,dz,:,:));
                tp2=bwlabel(tps,4);
                %loop through blobs
                toutput_Fvalues=zeros(size(tp_Fvalues));
                toutput_pvalues=ones(size(tp_pvalues));
                toutput_cluster_perc=zeros(size(tp_pvalues));
                toutput_cluster_perc_max=zeros(size(tp_pvalues));
                for i=1:max(max(tp2));
                    %sum Fvalues
                    idx=find(tp2==i);
                    blob_size=sum(sum(tp_Fvalues(idx)));
                    update_status.function(update_status.handles,['B' num2str(i) ': ' num2str(blob_size)],1,0);
                    if sum(sum(tps(find(tp2==i))))>0;
                        if blob_size>criticals(chanpos,dz,indexpos);
                            update_status.function(update_status.handles,'FOUND a significant cluster!',1,0);
                            toutput_Fvalues(idx)=tp_Fvalues(idx);
                            toutput_pvalues(idx)=tp_pvalues(idx);
                        end;
                        %add cluster statistic sum values
                        [a,b]=min(abs(squeeze(blob_size_dist(chanpos,dz,indexpos,:))-blob_size));
                        toutput_cluster_perc(idx)=blob_size_dist_x(b);
                        [a,b]=min(abs(squeeze(blob_size_max_dist(chanpos,dz,indexpos,:))-blob_size));
                        toutput_cluster_perc_max(idx)=blob_size_dist_x(b);
                    end;
                end;
                outdata_Fvalue(2,chanpos,indexpos,dz,:,:)=toutput_Fvalues;
                outdata_pvalue(2,chanpos,indexpos,dz,:,:)=toutput_pvalues;
                outdata_Fvalue(3,chanpos,indexpos,dz,:,:)=toutput_cluster_perc;
                outdata_Fvalue(4,chanpos,indexpos,dz,:,:)=toutput_cluster_perc_max;
                outdata_pvalue(3,chanpos,indexpos,dz,:,:)=toutput_cluster_perc;
                outdata_pvalue(4,chanpos,indexpos,dz,:,:)=toutput_cluster_perc_max;
                %
            end;
        end;
    end;
    %adjust header.datasize
    outheader_Fvalue.datasize(1)=4;
    outheader_pvalue.datasize(1)=4;
    %Store to apply other thresholds without rerunning tests...
    outheader_Fvalue.ANOVA_permutation_distrib.cluster_values=blob_size;
    outheader_Fvalue.ANOVA_permutation_distrib.cluster_values=blob_size_max;
    outheader_pvalue.ANOVA_permutation_distrib.cluster_values=blob_size;
    outheader_pvalue.ANOVA_permutation_distrib.cluster_values=blob_size_max;
    
end;
%save pvalues
[p n e]=fileparts(inputfiles{1});
[p2 n2 e2]=fileparts(get(handles.prefixtext_p,'String'));
st=[p filesep n2 '.lw5'];
LW_save(st,[],outheader_pvalue,outdata_pvalue);
%save Fvalues
[p2 n2 e2]=fileparts(get(handles.prefixtext_F,'String'));
st=[p filesep n2 '.lw5'];
LW_save(st,[],outheader_Fvalue,outdata_Fvalue);
%matlabpool close
if parfor_chk==1;
    update_status.function(update_status.handles,'Closing parallel pool.',1,0);
    try
        if exist(parpool)==2;
            delete(gcp('nocreate'));
        else
            matlabpool close;
        end;
    end
    update_status.function(update_status.handles,'Parallel pool is shut down.',1,0);
end;
update_status.function(update_status.handles,'Finished!',0,1);
set(handles.figure,'Name',fig_title);






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







% --- Executes on button press in addwithinbutton.
function addwithinbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addwithinbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.factoredit,'String');
factordata=get(handles.factoredit,'UserData');
tp=length(factordata)+1;
factordata(tp).label=st;
factordata(tp).within=1;
set(handles.factoredit,'UserData',factordata);
update_table_headers(handles);
%table data
data=get(handles.uitable,'Data');
numrows=get(handles.uitable,'RowName');
tp=num2cell(ones(length(numrows),1));
data=horzcat(data,tp);
set(handles.uitable,'Data',data);





function update_table_headers(handles);
factordata=get(handles.factoredit,'UserData');
factorstring={};
for i=1:length(factordata);
    if factordata(i).within==1;
        factorstring{i}=['W:' factordata(i).label];
    else
        factorstring{i}=['B:' factordata(i).label];        
    end;
    editable(i)=true;
end;
set(handles.uitable,'ColumnName',factorstring);
set(handles.uitable,'ColumnEditable',editable);





function factoredit_Callback(hObject, eventdata, handles)
% hObject    handle to factoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)







% --- Executes during object creation, after setting all properties.
function factoredit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to factoredit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end







% --- Executes on button press in addbetweenbutton.
function addbetweenbutton_Callback(hObject, eventdata, handles)
% hObject    handle to addbetweenbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
st=get(handles.factoredit,'String');
factordata=get(handles.factoredit,'UserData');
tp=length(factordata)+1;
factordata(tp).label=st;
factordata(tp).within=0;
set(handles.factoredit,'UserData',factordata);
update_table_headers(handles);
%table data
data=get(handles.uitable,'Data');
numrows=get(handles.uitable,'RowName');
tp=num2cell(ones(length(numrows),1));
data=horzcat(data,tp);
set(handles.uitable,'Data',data);
%disable cluster_thresholding
set(handles.cluster_chk,'Value',0);
set(handles.cluster_chk,'Enable','off');





% --- Executes on button press in clearbutton.
function clearbutton_Callback(hObject, eventdata, handles)
% hObject    handle to clearbutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.uitable,'ColumnName',{});
set(handles.uitable,'Data',{});
set(handles.factoredit,'UserData',{});










% --- Executes when entered data in editable cell(s) in uitable.
function uitable_CellEditCallback(hObject, eventdata, handles)
% hObject    handle to uitable (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) edited
%	PreviousData: previous data for the cell(s) edited
%	EditData: string(s) entered by the user
%	NewData: EditData or its converted form set on the Data property. Empty if Data was not changed
%	Error: error string when failed to convert EditData to appropriate value for Data
% handles    structure with handles and user data (see GUIDATA)



function prefixtext_F_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext_F (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function prefixtext_F_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixtext_F (see GCBO)
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






function clusterthreshold_edit_Callback(hObject, eventdata, handles)
% hObject    handle to clusterthreshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function clusterthreshold_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clusterthreshold_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function numpermutations_edit_Callback(hObject, eventdata, handles)
% hObject    handle to numpermutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function numpermutations_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to numpermutations_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function pvalue_edit_Callback(hObject, eventdata, handles)
% hObject    handle to pvalue_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function pvalue_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pvalue_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in clustercriterion_edit.
function clustercriterion_edit_Callback(hObject, eventdata, handles)
% hObject    handle to clustercriterion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
criterion=get(handles.clustercriterion_edit,'Value');
switch criterion
    case 1;
        thr=2;
    case 2;
        thr=2;
    case 3;
        thr=0.05;
    case 4;
        thr=0.05;
end;
set(handles.clusterthreshold_edit,'String',num2str(thr));




% --- Executes during object creation, after setting all properties.
function clustercriterion_edit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to clustercriterion_edit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in parfor_chk.
function parfor_chk_Callback(hObject, eventdata, handles)
% hObject    handle to parfor_chk (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of parfor_chk
