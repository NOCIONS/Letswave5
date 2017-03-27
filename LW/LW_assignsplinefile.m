function outheader=LW_assignsplinefile(header,filename)
% LW_assignfsplinefile
% Assign a splinefile to a LW5 file
%
% Inputs
% - header (LW5 header)
% - filename : name of splinefile
%
% Outputs
% - outheader (LW5 header)
%
% Dependencies : none.
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




%verify filename
[path,name,ext]=fileparts(filename);
filename=[name,ext];

%outdata
outheader=header;
outheader.filename_spl=filename;

%add history
i=size(outheader.history,2)+1;
outheader.history(i).description='LW_assignsplinefile';
outheader.history(i).date=date;
outheader.history(i).index=filename;