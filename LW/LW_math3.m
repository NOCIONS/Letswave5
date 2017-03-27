function [outheader,outdata] = LW_math3(header,data,constant,operation)
% LW_varexplained
% how much does dataset1 explain dataset2? 
%
% Inputs
% - header1 (LW5 header)
% - data1 (LW5 data)
% - constant
% - operation : 'add','subtract','multiply','divide' 
% outdata=data1 operation constant
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
outheader=header;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_math3';
outheader.history(i).date=date;
outheader.history(i).index=[operation constant];


%process
switch operation
    case {'add'};
        outdata=data+constant;
    case {'subtract'};
        outdata=data-constant;
    case {'multiply'};
        outdata=data*constant;
    case {'divide'};
        outdata=data/constant;
end;

end

