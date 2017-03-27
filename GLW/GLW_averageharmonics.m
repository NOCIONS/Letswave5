function varargout = GLW_averageharmonics(varargin)
% GLW_AVERAGEHARMONICS M-file for GLW_averageharmonics.fig






% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @GLW_averageharmonics_OpeningFcn, ...
    'gui_OutputFcn',  @GLW_averageharmonics_OutputFcn, ...
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


% --- Executes just before GLW_averageharmonics is made visible.
function GLW_averageharmonics_OpeningFcn(hObject, eventdata, handles, varargin)
% Choose default command line output for GLW_averageharmonics
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
%output
set(handles.processbutton,'Userdata',varargin{3});
axis off;
%fill listbox with inputfiles
inputfiles=varargin{2};
set(handles.filebox,'String',inputfiles);





% --- Outputs from this function are returned to the command line.
function varargout = GLW_averageharmonics_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
varargout{1} = handles.output;



function Harmonics_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to Harmonics_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function Harmonics_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Harmonics_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





function baseFreq_textbox_Callback(hObject, eventdata, handles)
% hObject    handle to baseFreq_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function baseFreq_textbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to baseFreq_textbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





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





% --- Executes on button press in process_button.
function process_button_Callback(hObject, eventdata, handles)
% hObject    handle to process_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
update_status=get(handles.processbutton,'UserData');
update_status.function(update_status.handles,'*** Average harmonics.',1,0);
%Get frequencies 
BaseFreq = eval(sprintf('[%s]',get(handles.baseFreq_textbox,'String')));
Harmonics = eval(sprintf('[%s]',get(handles.Harmonics_textbox,'String')));
freqBins = Harmonics.*BaseFreq;
%Do we need to add harmonic nb to filename?
if get(handles.checkbox_addHarmonicName,'Value')
    HarmonicsFileName = sprintf('%i-',Harmonics);
    HarmonicsFileName(end) = [];
else
    HarmonicsFileName = '';
end
%Get filenames to process
inputfiles=get(handles.filebox,'String');
%Init
data2XLSExport = {};
for filepos=1:length(inputfiles);
    update_status.function(update_status.handles,['Loading : ' inputfiles{filepos}],1,0);    
    [header,data]=LW_load(inputfiles{filepos});
    %process
    update_status.function(update_status.handles,'Averaging harmonics.',1,0);    
    %     tp=1:1:header.datasize(6);
    %     freqAxis = ((tp-1)*header.xstep)+header.xstart;
    binHarmonics = round(freqBins./header.xstep +1);
    %flag to determine whether we need to average harmonics or extract
    %individual harmonics.
    averageH = 0;
    outXsize = length(binHarmonics);
    if get(handles.radiobutton_averageH,'Value');
        averageH = 1;
        outXsize = 2; 
    end
    %loop through all the data
    outdata = data(:,:,:,:,:,1:outXsize);
    for epochpos=1:size(data,1);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    % if we average harmonics, we'll end up with the 6th
                    % dimension of data as a signal point, which does not
                    % work. Thus, let's repeat the average twice, so we'll
                    % have 2 data points.
                    if averageH
                        avgH=squeeze(mean(data(epochpos,:,indexpos,dz,dy,binHarmonics),6));
                        %update outdata
                        outdata(epochpos,:,indexpos,dz,dy,:)=repmat(avgH',[1 2]);
                    else
                        %update outdata
                        outdata(epochpos,:,indexpos,dz,dy,:)=data(epochpos,:,indexpos,dz,dy,binHarmonics);
                    end
                end;
            end;
        end;
    end;
    %output
    data = outdata;
    if get(handles.checkbox_export2excell,'value');     
        data2XLSExport{1,1} = 'Filename';
        data2XLSExport{1,2} = 'Epoch';
        data2XLSExport{1,3} = 'Electrode';
        data2XLSExport{1,4} = 'BaseFrequency';
        data2XLSExport{1,5} = 'Harmonic_nb';
        data2XLSExport{1,6} = 'Harmonic_freq';
        data2XLSExport{1,7} = 'Harmonic_binNb';
        data2XLSExport{1,8} = 'Data';        
        %DAN's FUNCTION
        data2XLSExport=LW_harmexport(data2XLSExport,data,n,header,freqBins,Harmonics,BaseFreq,binHarmonics,averageH);
    end    
    %deal with output header
    %add history
    i=length(header.history)+1;
    header.history(i).description='LW_AverageHarmonics';
    header.history(i).date=date;
    %update xaxis values (arbitrary)
    header.xstart = 1;
    header.xstep = 1;
    header.datasize = size(data);
    %save: define filename  
    [p,n,e]=fileparts(inputfiles{filepos});
    saveNameBase = [p,filesep,get(handles.prefixtext,'String'),' H_',HarmonicsFileName,' ',n];
    %save
    LW_save(saveNameBase,[],header,data);    
end;
if get(handles.checkbox_export2excell,'value');
    c=clock;
    [p,n,e]=fileparts(inputfiles{1});
    savename = strrep(sprintf('%i-%02d-%02d_%02dh%02dm%02ds_%s',c(1),c(3),c(2),c(4),c(5),round(c(6)),n),' ','_');
    %open excell to determine which version is available
    % Prepare proper filename extension.
    % Get the Excel version because if it's verions 11 (Excel 2003) the
    % file extension should be .xls,
    % but if it's 12.0 (Excel 2007) then we'll need to use an extension
    % of .xlsx to avoid mistakes.
    Excel = actxserver('Excel.Application');
    excelVersion = str2double(Excel.Version);
    if excelVersion < 12
        excelExtension = '.xls';
    else
        excelExtension = '.xlsx';
    end
    update_status.function(update_status.handles,'Writing Excel file.',1,0);    
    xlswrite([savename,excelExtension],data2XLSExport);
end
update_status.function(update_status.handles,'Finished!',0,1);






function prefixtext_Callback(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function prefixtext_CreateFcn(hObject, eventdata, handles)
% hObject    handle to prefixtext (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in checkbox_addHarmonicName.
function checkbox_addHarmonicName_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_addHarmonicName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes on button press in radiobutton_extractH.
function radiobutton_extractH_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_extractH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton_extractH,'Value',1);
set(handles.radiobutton_averageH,'Value',0);




% --- Executes on button press in radiobutton_averageH.
function radiobutton_averageH_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton_averageH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.radiobutton_extractH,'Value',0);
set(handles.radiobutton_averageH,'Value',1);





% --- Executes on button press in checkbox_export2excell.
function checkbox_export2excell_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox_export2excell (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





function data2XLSExport=LW_harmexport(data2XLSExport,data,filename,header,freqBins,Harmonics,BaseFreq,binHarmonics,averageH);
if averageH
    sizeND=size(data2XLSExport);
    sizeD=size(data);
    for i=1:sizeD(1)
        sizeND=size(data2XLSExport);
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),8)=num2cell(data(i,:,1,1,1,1))';
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),1)={filename};
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),2)={i};
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),3)={header.chanlocs(1,1:sizeD(2)).labels}';
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),4)={BaseFreq};
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),5)={'average'};
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),6)={'average'};
        data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),7)={mat2str(Harmonics)};
    end
else
    sizeND=size(data2XLSExport);
    sizeD=size(data);
    
    for i=1:sizeD(1)
        for j=1:sizeD(6)
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),8)=num2cell(data(i,:,1,1,1,j))';
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),1)={filename};
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),2)={i};
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),3)={header.chanlocs(1,1:sizeD(2)).labels}';
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),4)={BaseFreq};
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),5)={Harmonics(j)};
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),6)={freqBins(j)};
            data2XLSExport(sizeND(1)+1:sizeND(1)+sizeD(2),7)={binHarmonics(j)};
            sizeND=size(data2XLSExport);
        end
    end
end


% --- Executes on selection change in listbox2.
function listbox2_Callback(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function listbox2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to listbox2 (see GCBO)
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



function edit4_Callback(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes on button press in checkbox3.
function checkbox3_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in checkbox4.
function checkbox4_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




function edit5_Callback(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit6_Callback(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)





% --- Executes during object creation, after setting all properties.
function edit6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
