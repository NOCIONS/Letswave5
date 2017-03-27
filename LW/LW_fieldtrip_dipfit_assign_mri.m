function [outheader] = LW_fieldtrip_dipfit_assign_mri(header,mri_filename)
% LW_fieldtrip_dipfit_assign_mri(header,mri_filename)
%
% Inputs
% - header (LW5 header)
% - mri_filename : *_mri.mat file with MRI data
%   e.g.'BEM_standard_mri.mat'
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
[p,n,e]=fileparts(mri_filename);
outheader.fieldtrip_dipfit.mrifile=[n,e];

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_fieldtrip_dipfit_assign_mri';
outheader.history(i).date=date;
outheader.history(i).index=mri_filename;