function LW_renamefile(inputheaderfilename,outputheaderfilename)
% LW_renamefile
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

    
%rename

iname=inputheaderfilename;
oname=outputheaderfilename;
movefile(iname,oname);

[p,n,e]=fileparts(iname);
iname=[p filesep n '.mat'];
[p,n,e]=fileparts(oname);
oname=[p filesep n '.mat'];
movefile(iname,oname);

