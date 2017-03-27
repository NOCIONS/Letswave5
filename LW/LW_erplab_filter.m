function [outheader,outdata] = LW_erplab_filter(header,data,parameters)
% LW_erplab_filter
% ERPLAB filter
%
% Inputs
% - header : LW5 header
% - data   : LW5 data
% - parameters : to be defined
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
%

%transfer header to outheader
outheader=header;

%add a history entry
outheader.history(end+1).description='LW_erplab_filter';
outheader.history(end).date=date;
outheader.history(end).index=parameters;

%prepare outdata
outdata=zeros(size(data));

%apply the filter
        
end

