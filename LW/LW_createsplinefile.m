function outheader=LW_createsplinefile(header,filename,varargin)
% LW_createsplinefile
% Create a splinefile using chanlocs
% outputs updated dataset, with assigned name of splinefile file
%
% Inputs
% - header (LW5 header)
% - filename : name of splinefile
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

%fetch chanlocs
chanlocs=header.chanlocs;

%parse chanlocs according to topo_enabled
k=1;
for chanpos=1:length(chanlocs);
    if chanlocs(chanpos).topo_enabled==1
        chanlocs2(k)=chanlocs(chanpos);
        k=k+1;
    end;
end;

%verify filename
[path,name,ext]=fileparts(filename);
filename=[name,'.spl'];
fullfilename=fullfile(path,filename);
disp(fullfilename);

%build spl
headplot('setup',chanlocs2,fullfilename,varargin{:});

%outheader
outheader=header;
outheader.filename_spl=filename;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_createsplinefile';
outheader.history(i).date=date;
outheader.history(i).index=filename;