function GLW_disp(handles,text_string)
%update letswave_gui logtext
st=get(handles.logtext,'String');
st{length(st)+1}=text_string;
set(handles.logtext,'String',st);
set(handles.logtext,'Value',length(st));
end

