function [outheader] = LW_fieldtrip_dipfit_assign_hdm(header,hdm_filename)
% LW_fieldtrip_dipfit_assign_hdm(header,hdm_filename)
%
% Inputs
% - header (LW5 header)
% - hdm_filename : .hdm file with headmodel
%   e.g.'BEM_standard_vol.mat'
%
% Outputs
% - outheader (LW5 header)
%
% Dependencies : none.
%
% Author : 
% Andr? Mouraux
% Institute of Neurosciences (IONS)
% Universit? catholique de louvain (UCL)
% Belgium
% 
% Contact : andre.mouraux@uclouvain.be
% This function is part of Letswave 5
% See http://nocions.webnode.com/letswave for additional information



outheader=header;
[p,n,e]=fileparts(hdm_filename);
outheader.fieldtrip_dipfit.hdmfile=[n,e];

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_fieldtrip_dipfit_assign_hdm';
outheader.history(i).date=date;
outheader.history(i).index=hdm_filename;