function [outheader] = LW_fieldtrip_dipfit_lookupchannels(header,location_filename)
% LW_fieldtrip_lookupchannels
% Assign channel locations according to channel labels
%
% Inputs
% - header (LW5 header)
% - location_filename : e.g. BEM_standard_1005.elc
%
% Outputs
% - outheader (LW5 header)
%
% Dependencies : readlocs (EEGLAB); see help readlocs for details.
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
%read location_filename
locs=readlocs(location_filename);
%assign locations to channels with matched labels
for chanpos=1:length(header.chanlocs);
    outheader.chanlocs(chanpos).fieldtrip_dipfit.enabled=0;
    for locpos=1:length(locs);
        if strcmpi(header.chanlocs(chanpos).labels,locs(locpos).labels);
            outheader.chanlocs(chanpos).fieldtrip_dipfit.theta=locs(locpos).theta;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.radius=locs(locpos).radius;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.sph_theta=locs(locpos).sph_theta;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.sph_phi=locs(locpos).sph_phi;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.sph_theta_besa=locs(locpos).sph_theta_besa;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.sph_phi_besa=locs(locpos).sph_phi_besa;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.X=locs(locpos).X;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.Y=locs(locpos).Y;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.Z=locs(locpos).Z;
            outheader.chanlocs(chanpos).fieldtrip_dipfit.enabled=1;
        end;
    end;
end;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_fieldtrip_dipfit_lookupchannels';
outheader.history(i).date=date;
outheader.history(i).index=location_filename;