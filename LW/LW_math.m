function [outheader,outdata] = LW_math(header1,data1,header2,data2,operation)
% LW_varexplained
% how much does dataset1 explain dataset2? 
%
% Inputs
% - header1 (LW5 header)
% - data1 (LW5 data)
% - header2 (LW5 header)
% - data2 (LW5 data)
% - operation : 'add','subtract','multiply','divide' : data1 operation data2
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


%transfer header to outheader
outheader=header1;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_math';
outheader.history(i).date=date;
outheader.history(i).index=[operation];

%outdata
outdata=zeros(outheader.datasize);

%process
switch operation
    case {'add'};
        outdata=data1+data2;
    case {'subtract'};
        outdata=data1-data2;
    case {'multiply'};
        outdata=data1.*data2;
    case {'divide'};
        outdata=data1./data2;
end;

end

