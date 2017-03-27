function [outheader,outdata] = LW_ica_runica(header,data,numIC);
% LW_runica
% ICA using the runica function
%
% Inputs
% - header : LW5 header
% - data : LW5 data
% - numIC : numIC=0: square mixing matrix
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : runica
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

%horzcat data
tpdata=zeros(size(data,2),size(data,6)*size(data,1));
for epochpos=1:size(data,1);
    tpdata=horzcat(tpdata,squeeze(data(epochpos,:,1,1,1,:)));
end;

%ica
if numIC==0;
    [ica.weights,ica.sphere,ica.compvars,ica.bias,ica.signs,ica.lrates,ica.activations]=runica(tpdata);
else
    [ica.weights,ica.sphere,ica.compvars,ica.bias,ica.signs,ica.lrates,ica.activations]=runica(tpdata,'pca',numIC);
end;

%unmixing matrix
ica_um=ica.weights*ica.sphere;

%mixing matrix
ica_mm=pinv(ica_um);

%outdata
outdata(1,:,1,1,1,:)=ica_um';
outdata(1,:,2,1,1,:)=ica_mm;

%outheader
outheader=header;
outheader.datasize=size(outdata);
outheader.xstart=1;
outheader.xstep=1;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_ica';
outheader.history(i).date=date;
outheader.history(i).index=[numIC];

%clear events
if isfield(outheader,'events');
    outheader=rmfield(outheader,'events');
end;

%clear conditions
if isfield(outheader,'conditions');
    outheader=rmfield(outheader,'conditions');
end;
if isfield(outheader,'condition_labels');
    outheader=rmfield(outheader,'condition_labels');
end;

end

