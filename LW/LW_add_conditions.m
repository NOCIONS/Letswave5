function outheader=LW_add_conditions(header,condition_labels,condition_data);
% LW_add_conditions
% Adds conditions to a LW5 file
%
% Inputs
% - header (LW5 header)
% - condition_labels{condition} : a cell array condition labels describing the conditions 
% - condition_data(trialpos,condition) : a matrix of condition values
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




%outdata
outheader=header;

%add history
i=size(outheader.history,2)+1;
st='LW_add_conditions ';
for i=1:length(condition_labels);
    st=[st condition_labels{i} ' '];
end;
outheader.history(i).description=st;    
outheader.history(i).date=date;
outheader.history(i).index=[];

%Verify its structure
if size(condition_data,1)==outheader.datasize(1);
else
    Disp('!!! not adding the conditions because non-matching number of epochs!!!');
    return;
end;


%add condition_headers
outheader.condition_labels=condition_labels;

%add condition_data
outheader.conditions=condition_data;