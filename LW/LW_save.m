function LW_save(filename,suffix,header,data)

[p,n,e]=fileparts(filename);
if isempty(suffix);
    st=[p,filesep,n,'.lw5'];
else
    st=[p,filesep,suffix,' ',n,'.lw5'];
end;
%save header
save(st,'-MAT','header');
%save data
if isempty(suffix);
    st=[p,filesep,n,'.mat'];
else
    st=[p,filesep,suffix,' ',n,'.mat'];
end;
data=single(data);
%data=double(data);

save(st,'-MAT','-v7.3','data');
    
end



