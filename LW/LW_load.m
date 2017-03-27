function [outheader,outdata] = LW_load(filename)

[p,n,e]=fileparts(filename);
%load header
st=[p,filesep,n,'.lw5'];
load(st,'-MAT');
outheader=header;
%load data
st=[p,filesep,n,'.mat'];
load(st,'-MAT');
outdata=double(data);

end

