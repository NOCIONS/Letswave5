function [outheader] = LW_ica_assignfile(header,matrixfilename);
% LW_ica_assignfile
% store name of matrixfilename
%
% Inputs
% - header : LW5 header
% - matrixfilename : string with filename of ica matrix
%
% Outputs
% - outheader : LW5 header
%
% Dependencies : none
%
% Author : 
% André Mouraux
% Institute of Neurosciences (IONS)
% Université catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information
%

%verify filename
[path,name,ext]=fileparts(matrixfilename);
filename=[name,ext];

%outdata
outheader=header;
outheader.filename_bss=filename;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ica_assignfile';
outheader.history(i).date=date;
outheader.history(i).index=matrixfilename;

end