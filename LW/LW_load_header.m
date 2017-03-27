function [outheader] = LW_load_header(filename)

[p,n,e]=fileparts(filename);
%load header
st=[p,filesep,n,'.lw5'];
load(st,'-MAT');
outheader=header;
end

