function [outheader,outdata] = LW_SNR2(header,data,dx1,dx2,numextremes,operation)
% LW_SNR
%
% Inputs
% - header (LW5 header)
% - data (LW5 data)
% - dx1 : begin of sliding baseline interval (bin)
% - dx2 : end of sliding baseline interval (bin)
% - operation : 'subtract','snr','percent'
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
%


%transfer header to outheader
outheader=header;


%add history
i=length(outheader.history)+1;
outheader.history(i).description='LW_SNR';
outheader.history(i).date=date;
outheader.history(i).index=[dx1,dx2,operation];

outdata=zeros(size(data));

%loop through all the data
for epochpos=1:size(data,1);
    for channelpos=1:size(data,2);
        for indexpos=1:size(data,3);
            for dz=1:size(data,4);
                for dy=1:size(data,5);
                    tp=squeeze(data(epochpos,channelpos,indexpos,dz,dy,:));
                    tp2=zeros(size(tp));
                    %subtraction
                    if strcmpi(operation,'subtract')==1;
                        for dx=dx2+1:size(data,6)-dx2;
                            tp3=sort(tp([dx-dx2:dx-dx1,dx+dx1:dx+dx2]));
                            tp3=tp3(1+numextremes:length(tp3)-numextremes);
                            bl(dx)=mean(tp3);
                        end;
                        tp2=tp-bl;
                    end;
                    %snr
                    if strcmpi(operation,'snr')==1;
                        for dx=dx2+1:size(data,6)-dx2;
                            tp3=sort(tp([dx-dx2:dx-dx1,dx+dx1:dx+dx2]));
                            tp3=tp3(1+numextremes:length(tp3)-numextremes);
                            bl(dx)=mean(tp3);
                        end;
                        tp2=tp./bl;
                    end;
                    %percent
                    if strcmpi(operation,'percent')==1;
                        for dx=dx2+1:size(data,6)-dx2;
                            tp3=sort(tp([dx-dx2:dx-dx1,dx+dx1:dx+dx2]));
                            tp3=tp3(1+numextremes:length(tp3)-numextremes);
                            bl(dx)=mean(tp3);
                        end;
                        tp2=tp-bl;
                        tp2=tp2./bl;
                    end;
                    outdata(epochpos,channelpos,indexpos,dz,dy,:)=tp2;
                end;
            end;
        end;
    end;
end;


end

