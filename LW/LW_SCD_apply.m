function [outheader,outdata] = LW_SCD_apply(header,data,G,H)
% LW_SCD_getGH
%
% Inputs
% - header (LW5 header) (must contain chanlocs with topo_enabled=1) and
%              must correspond to the header used to create G and G
% - data (LW5 data)
% - G (output of LW_SCD_getGH)
% - H (output of LW_SCD_getGH)
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5 data)
%
% Dependencies : CSDtoolbox.
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

%get usable list of electrodes
idx=[];
for chanpos=1:header.datasize(2);
    if header.chanlocs(chanpos).topo_enabled==1;
        idx=[idx,chanpos];
    end;
end;

%transfer header
outheader=header;

%adjust outheader.chanlocs
outheader.chanlocs=header.chanlocs(idx);

%adjust outheader.datasize
outheader.datasize(2)=size(idx,2);

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_SCD_apply';
outheader.history(i).date=date;
outheader.history(i).index=[];

%get usable data
scddata=data(:,idx,:,:,:,:);

%prepare outdata
outdata=zeros(outheader.datasize);

for epochpos=1:header.datasize(1);
    for indexpos=1:header.datasize(3);
        for dz=1:header.datasize(4);
            for dy=1:header.datasize(5);
                eeg=single(squeeze(scddata(epochpos,:,indexpos,dz,dy,:)));
                res=CSD(eeg,G,H);
                outdata(epochpos,:,indexpos,dz,dy,:)=double(res(:,:));
            end;
        end;
    end;
end;
