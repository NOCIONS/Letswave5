function [outheader,outdata] = LW_square(header,data)
% LW_square
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
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
%

%transfer header to outheader
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_square';
outheader.history(i).date=date;
outheader.history(i).index=[];

%square
outdata=data.^2;
