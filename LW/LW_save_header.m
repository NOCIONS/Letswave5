function LW_save_header(filename,suffix,header)

[p,n,e]=fileparts(filename);
if isempty(suffix);
    st=[p,filesep,n,'.lw5'];
else
    st=[p,filesep,suffix,' ',n,'.lw5'];
end;
%save header
save(st,'-MAT','header');
    
end



