function LW_checkepochs(header,data)
% LW_checkepochs
%
% Inputs
% - header : LW5 header
% - data : LW5 data
%
% Outputs
% - outheader : LW5 header
% - outdata : LW5 data
%
% Dependencies : none
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

ok=0;

for epochpos=1:header.datasize(1);
    for chanpos=1:header.datasize(2);
        emin=min(data(epochpos,chanpos,1,1,1,:));
        emax=max(data(epochpos,chanpos,1,1,1,:));
        if emin==emax;
            disp(['Problem found : epoch ' num2str(epochpos) ' channel ' header.chanlocs(chanpos).labels]);
            ok=1;
        end;
    end;
end;

if ok==1;
    disp('*** Problems were found !!!');
else
    disp('*** No problems found !');
end;

        
end

