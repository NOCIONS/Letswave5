function [outheader,outdata] = LW_varexplained(header1,data1,header2,data2,channels)
% LW_varexplained
% how much does dataset1 explain dataset2? 
%
% Inputs
% - header1 (LW5 header)
% - data1 (LW5 data)
% - header2 (LW5 header)
% - data2 (LW5 data)
% - channels : selected channels
%
% Outputs
% - outheader (LW5 header)
% - outdata (LW5data)
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


%transfer header to outheader
outheader=header1;

%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_varexplained';
outheader.history(i).date=date;
outheader.history(i).index=[channels];

%modify outheader
outheader.datasize(2)=1;
chanlocs(1).labels='varexp';
chanlocs(1).topo_enabled=0;
outheader.chanlocs=chanlocs;

%outdata
outdata=zeros(outheader.datasize);

%process
%loop through epochs
for epochpos=1:header1.datasize(1);
    %loop through index
    for indexpos=1:header1.datasize(3);
        %loop through z
        for dz=1:header1.datasize(4);
            %loop through y
            for dy=1:header1.datasize(5);
                %loop through selected channels
                for chanpos=1:length(channels);
                    tp1=squeeze(data1(epochpos,channels(chanpos),indexpos,dz,dy,:));
                    tp2=squeeze(data2(epochpos,channels(chanpos),indexpos,dz,dy,:));
                    tp(:,chanpos)=abs(tp2-tp1);
                    tpa(:,chanpos)=abs(tp2);
                end;
                outdata(epochpos,1,indexpos,dz,dy,:)=1-(sum(tp,2)./sum(tpa,2));
            end;
        end;
    end;
end;

end

