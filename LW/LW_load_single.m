function [outheader,outdata] = LW_load_single(filename)

[p,n,e]=fileparts(filename);
%load header
st=[p,filesep,n,'.lw5'];
disp(['loading ',st]);
load(st,'-MAT');
outheader=header;
%load data
st=[p,filesep,n,'.mat'];
load(st,'-MAT');
outdata=single(data);

end

