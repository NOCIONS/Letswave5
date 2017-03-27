function [outheader,outdata] = LW_math2(header1,data1,header2,data2,epochpos,channelpos,indexpos,operation)
% LW_varexplained
% how much does dataset1 explain dataset2? 
%
% Inputs
% - header1 (LW5 header)
% - data1 (LW5 data)
% - header2 (LW5 header)
% - data2 (LW5 data)
% - epochpos
% - channelpos
% - indexpos
% - operation : 'add','subtract','multiply','divide' 
% outdata=data1 operation data2(epochpos,channelpos,indexpos)
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
outheader.history(i).description='LW_math2';
outheader.history(i).date=date;
outheader.history(i).index=[operation];

%epoch_index
if epochpos==0;
    epoch_index=1:1:outheader.datasize(1);
else
    epoch_index=zeros(outheader.datasize(1),1)+epochpos;
end;
%channel_index
if channelpos==0;
    channel_index=1:1:outheader.datasize(2);
else
    channel_index=zeros(outheader.datasize(2),1)+channelpos;
end;
%index_index
if indexpos==0;
    index_index=1:1:outheader.datasize(3);
else
    index_index=zeros(outheader.datasize(3),1)+indexpos;
end;


%outdata
outdata=zeros(outheader.datasize);

%process

%loop through epochs
for epochi=1:outheader.datasize(1);
    for channeli=1:outheader.datasize(2);
        for indexi=1:outheader.datasize(3);
            switch operation
                case {'add'};
                    outdata(epochi,channeli,indexi,:,:,:)=squeeze(data1(epochi,channeli,indexi,:,:,:))+squeeze(data2(epoch_index(epochi),channel_index(channeli),index_index(indexi),:,:,:));
                case {'subtract'};
                    outdata(epochi,channeli,indexi,:,:,:)=squeeze(data1(epochi,channeli,indexi,:,:,:))-squeeze(data2(epoch_index(epochi),channel_index(channeli),index_index(indexi),:,:,:));
                case {'multiply'};
                    outdata(epochi,channeli,indexi,:,:,:)=squeeze(data1(epochi,channeli,indexi,:,:,:)).*squeeze(data2(epoch_index(epochi),channel_index(channeli),index_index(indexi),:,:,:));
                case {'divide'};
                    outdata(epochi,channeli,indexi,:,:,:)=squeeze(data1(epochi,channeli,indexi,:,:,:))./squeeze(data2(epoch_index(epochi),channel_index(channeli),index_index(indexi),:,:,:));
            end;
        end;
    end;
end;

end

